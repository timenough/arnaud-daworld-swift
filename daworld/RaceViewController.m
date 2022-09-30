
#import "RaceViewController.h"
#import "CategorySegmentedControl.h"
#import "FicheChevalViewController.h"

@interface RaceViewController ()

@end

@implementation RaceViewController

@synthesize mWebView,
    raceSegmentedControl,
    raceInfoTab,
    raceInfoTabStatus,
    raceTabNameSelected,
    raceId,
    racePartantsArray,
    racePronosArray,
    raceRapportsArray,
    raceTabIndexSelected,
    raceContexte,
    raceArrivee,
    backButton,
    htmlText,
    pushAlertID,
    right_rightbuttoninstance;

- (void)viewWillAppear:(BOOL)animated
{
    
    if(pageType==2){
        
        UIButton *left_leftbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
        [left_leftbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_back_icon.png"] forState:UIControlStateNormal];
        [left_leftbuttoninstance addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        left_leftbuttoninstance.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        UIBarButtonItem *NewleftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_leftbuttoninstance];
        self.navigationItem.leftBarButtonItem = NewleftBarButtonItem;
        
    }
    
    // SI ON VEUT SAVOIR L'INDEX/DEPTH DES SUBVIEWS D'UNE VIEW
    //[self TOOLViewSubViewDetails:self.navigationController.navigationBar depth:nil push:nil];
    
    self.right_rightbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_alert_icon.png"] forState:UIControlStateNormal];
    [self.right_rightbuttoninstance addTarget:self action:@selector(switchActiveAlert:) forControlEvents:UIControlEventTouchUpInside];
    self.right_rightbuttoninstance.frame = CGRectMake(200.0, 0.0, 24.0, 24.0);
    UIBarButtonItem *NewrightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right_rightbuttoninstance];
    self.navigationItem.rightBarButtonItem = NewrightBarButtonItem;

    [super viewDidAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.topItem.title = self.pageTitle;
    
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    
    float startPositionY    = 0;
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];

    if(sysVer >= 7.0f)
        startPositionY = 63.0f;

    
    [super viewDidLoad];
    
    
    //Gestion du segmentedcontrol
    raceSegmentedControl = [[CategorySegmentedControl alloc] initWithFrame:CGRectMake(0, startPositionY, self.view.frame.size.width, 30.0f)];
    
    [raceSegmentedControl insertSegmentWithTitle:@"Partants" atIndex:0 animated:TRUE];
    [raceSegmentedControl insertSegmentWithTitle:@"Pronostics" atIndex:1 animated:TRUE];
    [raceSegmentedControl insertSegmentWithTitle:@"Rapports" atIndex:2 animated:TRUE];
    
    //Désactive les segments non renseignés pour la course
    for(int index=0; index<self.raceSegmentedControl.numberOfSegments; index++)
    {
        if([[raceInfoTabStatus objectAtIndex:index] isEqual:@"true"]){
            [raceSegmentedControl setEnabled:YES forSegmentAtIndex:index];
        }else{
            [raceSegmentedControl setEnabled:NO forSegmentAtIndex:index];
        }
    }
    
    raceSegmentedControl.selectedSegmentIndex = self.raceTabIndexSelected;
    self.raceTabNameSelected = [raceSegmentedControl titleForSegmentAtIndex:raceTabIndexSelected];
    
    [raceSegmentedControl addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:raceSegmentedControl];
    
    //Ligne Graphique
    UIView *lineView   = [[UIView alloc] initWithFrame:CGRectMake(0, 30.0f+startPositionY, self.view.frame.size.width, 3.0f)];
    lineView.backgroundColor = [UIColor colorWithRed:23.0/255 green:21.0/255 blue:17.0/255 alpha:1];
    [self.view addSubview:lineView];
    
    //_banner is an instance variable with default lifetime qualifier, which means it is __strong:
    //the banner will be retained by the controller until it is released.
    [self loadAdsBanner:nil isforView:self.view withBackgroundColor:[UIColor blackColor] atPositionX:0 atPositionY:33.0f+startPositionY];
    
    // Affichage de la Bannière pub
    [self displayAdsBanner:@"RaceViewController"];
    
    /* Préparation du rendu de la liste des partants */
    CGRect rect = CGRectMake(0,86.0f+startPositionY,self.view.frame.size.width,self.view.frame.size.height-86.0f-startPositionY);
    mWebView = [[UIWebView alloc] initWithFrame:rect];
    mWebView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    mWebView.delegate = self;
    mWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    mWebView.backgroundColor = [UIColor colorWithRed:228.0/255 green:223.0/255 blue:216.0/255 alpha:1];
    
    // Scroll to Refresh de la TableView (CUSTOM)
    [refreshTableView setBackgroundColor:[UIColor colorWithRed:228.0/255 green:223.0/255 blue:216.0/255 alpha:1]];
    refreshTableViewAnim.color                          = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
    refreshTableViewText.textColor                      = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
    [refreshTableView addTarget:self action:@selector(triggerJson) forControlEvents:UIControlEventValueChanged];
    [mWebView.scrollView addSubview:refreshTableView];
    [mWebView.scrollView sendSubviewToBack:refreshTableView];
    
    [self.view addSubview:mWebView];
    
    /* Appel du FLUX en mode Asynchrone (non bloquant) */
    self.liveJsonDataContainer      = [NSMutableData data];
    self.liveJsonNeedsUpdate        = 0;
    
    // Requete JSON
    [self triggerJson];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Actions

-(void)loadHTML:(NSString *)templateHTML
{
    
    NSString *linkHorse;
    
    NSString *stringConstruct = @"";
    int occurence             = 0;
    NSString *classCss        = @"";
    NSError *error;
    
    
	self.htmlText=[NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:templateHTML] encoding:NSUTF8StringEncoding error:&error];
    
    if([templateHTML isEqualToString:@"RacePartantsTemplate.html"]){
        for (NSDictionary *item in racePartantsArray){
            NSString *odds  = (![[item objectForKey:@"odds"] isEqualToString:@"-"])? [NSString stringWithFormat:@"<a class='small button yellow'>%@</a>", [item objectForKey:@"odds"]] : @"";
            
            classCss            = (occurence % 2 == 0)? @" class='even'" : @"";
            
            //linkHorse         = [@"cheval:" stringByAppendingFormat:@"%@",[item objectForKey:@"id"]];
            linkHorse       = [@"cheval:" stringByAppendingFormat:@"%@/%@",[item objectForKey:@"id"],[item objectForKey:@"name"]];
            
            stringConstruct = [stringConstruct stringByAppendingFormat:@"<tr%@><td class='number'><a href='%@'><b>%@</b></a></td><td class='casaque'><a href='%@'><img src='http://www.zone-turf.fr/media/picture/casaque/%@' /></a></td><td><a href='%@'><strong>%@</strong></a><a href='%@'>%@ </a><a href='%@'>%@</a></td><td class='tr'>%@</td></tr>", classCss, linkHorse, [item objectForKey:@"number"], linkHorse, [item objectForKey:@"casaque"], linkHorse, [item objectForKey:@"libelle"], linkHorse, [item objectForKey:@"jockey"],linkHorse,[item objectForKey:@"musique"], odds];
            
            occurence++;
           
        }
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_CONTEXTE_" withString:self.raceContexte];
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_TABLE_PARTANTS_" withString:stringConstruct];
    }else if([templateHTML isEqualToString:@"RacePronosticsTemplate.html"]){
        NSString *forecast1, *forecast2, *forecast3, *forecast4, *forecast5, *forecast6, *forecast7, *forecast8, *forecastC, *forecastE;
        
        for (NSDictionary *item in racePronosArray){
            
            forecast1 = [[item objectForKey:@"forecast1"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast1"];
            forecast2 = [[item objectForKey:@"forecast2"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast2"];
            forecast3 = [[item objectForKey:@"forecast3"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast3"];
            forecast4 = [[item objectForKey:@"forecast4"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast4"];
            forecast5 = [[item objectForKey:@"forecast5"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast5"];
            forecast6 = [[item objectForKey:@"forecast6"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast6"];
            forecast7 = [[item objectForKey:@"forecast7"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast7"];
            forecast8 = [[item objectForKey:@"forecast8"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecast8"];
            forecastC = [[item objectForKey:@"forecastC"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecastC"];
            forecastE = [[item objectForKey:@"forecastE"] isEqualToString:@"0"]? @"" : [item objectForKey:@"forecastE"];
            
            if(occurence==0)
                self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_TYPE_PARIS_" withString:[item objectForKey:@"pari"]];
            
            classCss      = (occurence == 0)? @" class='first'" : @"";
            
            stringConstruct = [stringConstruct stringByAppendingFormat:@"<tr%@><td><strong>%@</strong></td><td class='tc even'><b>%@</b></td><td class='tc'><b>%@</b></td><td class='tc even'><b>%@</b></td><td class='tc'><b>%@</b></td><td class='tc even'><b>%@</b></td><td class='tc'><b>%@</b></td><td class='tc even'><b>%@</b></td><td class='tc'><b>%@</b></td></tr>", classCss, [item objectForKey:@"forecaster"], forecast1, forecast2, forecast3, forecast4, forecast5, forecast6, forecast7, forecast8];
            
            if([[item objectForKey:@"forecaster"] isEqualToString:@"Zone-Turf.fr"] && ![[item objectForKey:@"topchance"] isEqualToString:@"0"]){
                
                if(![forecastC isEqualToString:@""]){
                
                    stringConstruct = [stringConstruct stringByAppendingFormat:@"<tr><td colspan='9' class='speciale'><table cellspacing='0' cellpadding='0' border='0'><tr><td class='tc'><strong>Top chance : %@</strong></td><td class='tc'><strong>Dernière minute : %@</strong></td></tr></table></td></tr>", [item objectForKey:@"topchance"], forecastC];
                }else{
                    stringConstruct = [stringConstruct stringByAppendingFormat:@"<tr><td colspan='9' class='speciale'><table cellspacing='0' cellpadding='0' border='0'><tr><td class='tc'><strong>Top chance : %@</strong></td></tr></table></td></tr>", [item objectForKey:@"topchance"]];
                }
            
            }
            
            if([[item objectForKey:@"forecaster"] isEqualToString:@"Le Diplomate"] && ![forecastE isEqualToString:@""]){
                stringConstruct = [stringConstruct stringByAppendingFormat:@"<tr><td colspan='9' class='speciale'><table cellspacing='0' cellpadding='0' border='0'><tr><td class='tc'><strong>Base : %@</strong></td><td class='tc'><strong>Top Secret : %@</strong></td><td class='tc'><strong>Joker : %@</strong></td></tr></table></td></tr>", [item objectForKey:@"forecastD"], [item objectForKey:@"forecastE"],[item objectForKey:@"forecastF"]];
                
            }
          
            occurence++;
        }
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_TABLE_PRONOS_" withString:stringConstruct];
        
    }else{
        classCss      = (occurence % 2 == 0)? @" class='first'" : @"";
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_ARRIVEE_OFFICIELLE_" withString:[NSString stringWithFormat:@"<h2>Arrivée officielle : %@</h2>", self.raceArrivee]];
        
        for (NSDictionary *item in raceRapportsArray){
            
            
            if([[item objectForKey:@"type"] isEqualToString:@"Type"]){
                stringConstruct = [stringConstruct stringByAppendingFormat:@"<tr%@><th class='tc'>%@</th><th class='tc'>%@</th><th class='tc'>%@</th><th class='tc'>%@</th></tr>", classCss ,[item objectForKey:@"combinaison"], [item objectForKey:@"type"], [item objectForKey:@"mise1"], [item objectForKey:@"mise2"]];
            }else{
                stringConstruct = [stringConstruct stringByAppendingFormat:@"<tr%@><td class='tc'>%@</td><td class='tc'>%@</td><td class='tc'>%@</td><td class='tc'>%@</td></tr>", classCss, [item objectForKey:@"combinaison"], [item objectForKey:@"type"], [item objectForKey:@"mise1"], [item objectForKey:@"mise2"]];
            }
            
        }   
        
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_TABLE_RAPPORTS_" withString:stringConstruct];
    }
    
	NSString *path =[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""];
	NSURL* contentBaseURL=[NSURL fileURLWithPath:path ];
    [mWebView loadHTMLString:htmlText baseURL:contentBaseURL];
    
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [request URL];
		NSString *val=[URL scheme];
		if([val isEqualToString:@"cheval"]){
            NSString *URLString = [NSString stringWithFormat:@"%@", URL];
            
            NSArray *stringArray1 = [URLString componentsSeparatedByString:@":"];
            NSLog(@"%@",[stringArray1 objectAtIndex:1]);
            NSArray *stringArray2 = [[stringArray1 objectAtIndex:1] componentsSeparatedByString:@"/"];
            
            
            FicheChevalViewController *ficheChevalViewController  = [[FicheChevalViewController alloc] init];
            ficheChevalViewController.horseId       = [[stringArray1 objectAtIndex:1] intValue];
        
            ficheChevalViewController.pageTitle     = [[stringArray2 objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            ficheChevalViewController.pageType      = 2;
            
        
            
            [self.navigationController pushViewController:ficheChevalViewController animated:YES];
        }
	}
	return YES;
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"2/2 | Données reçues [Connexion JSON Asynchrone terminée] : %d éléments",self.liveJsonDataContainer.length);
    
    self.view.userInteractionEnabled = YES;
    
    self.liveJsonNeedsUpdate = 1;
    
    [self updateContentArrayAfterJson:@"course"];
    
    self.racePartantsArray  = [[currentControllerTableViewContentArray valueForKey:@"partants"] objectForKey:@"partant"];
    self.racePronosArray    = [[currentControllerTableViewContentArray valueForKey:@"pronostics"] objectForKey:@"pronostic"];
    self.raceRapportsArray  = [[currentControllerTableViewContentArray valueForKey:@"rapports"] objectForKey:@"rapport"];
    self.pushAlertID        = [[currentControllerTableViewContentArray valueForKey:@"push_alert_id"] integerValue];
    
    [self loadHTML:[NSString stringWithFormat:@"Race%@Template.html",self.raceTabNameSelected]];
    
    if(self.pushAlertID>0){
        [self.right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_alert_moins_icon.png"] forState:UIControlStateNormal];
        
    }else{
        [self.right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_alert_plus_icon.png"] forState:UIControlStateNormal];
    }
    
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
    
    [self stopTableViewRefresh];
    
}


#pragma mark - Actions
-(void) switchActiveAlert:(id) sender
{
    
    NSURL *url;
    
    if(self.pushAlertID > 0){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail_action.php?device_id=%@&source=iphone&alert_id=1&action=del", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"]]];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail_action.php?device_id=%@&source=iphone&alert_id=1&action=add", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"]]];
    }
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10.0f];
    NSString *paramStr = [NSString stringWithFormat:@""];
    [request setHTTPBody:[NSData dataWithBytes:[paramStr UTF8String] length:[paramStr length]]];
    
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        @try {
            NSDictionary *Json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSString *responseMessage = [[Json objectForKey:@"message"] objectForKey:@"value"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte Partants" message:responseMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            
            
            if(self.pushAlertID>0){
                [self.right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_alert_plus_icon.png"] forState:UIControlStateNormal];
            }else{
                [self.right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_alert_moins_icon.png"] forState:UIControlStateNormal];
            }
            
            self.pushAlertID = [[[Json objectForKey:@"message"] objectForKey:@"params"] integerValue];
            
        }
        @catch (NSException *exception) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte Quinté" message:@"Exception lors d'action sur les alertes" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    });

}

-(void)changeTab:(id)sender
{
    
    NSString *templateHTML;
    
    raceSegmentedControl    = (CategorySegmentedControl *)sender;
    templateHTML            = [NSString stringWithFormat:@"Race%@Template.html",[raceSegmentedControl titleForSegmentAtIndex:raceSegmentedControl.selectedSegmentIndex]];
    
    self.raceTabNameSelected = [raceSegmentedControl titleForSegmentAtIndex:raceSegmentedControl.selectedSegmentIndex];
    
    [self loadHTML:templateHTML];
    
}

-(IBAction) dismissView:(id) sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)triggerJson
{
    
    NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_courses.php?device_id=%@&source=iphone&c=%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], self.raceId];
    NSLog(@"%@", local_uri_json);
    [self sendJsonRequest_ASync:local_uri_json];
    
}

@end
