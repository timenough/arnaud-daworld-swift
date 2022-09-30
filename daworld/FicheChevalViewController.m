
#import "FicheChevalViewController.h"
#import "NSString+HTML.h"
#import "NSString+MKNetworkKitAdditions.h"

@interface FicheChevalViewController ()

@end

@implementation FicheChevalViewController

@synthesize mWebView, backButton, htmlText, horseId, horsesArray, right_rightbuttoninstance,  pushAlertID;

- (void)viewWillAppear:(BOOL)animated
{
    if(pageType==2){
        
        UIButton *left_leftbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
        [left_leftbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_back_icon.png"] forState:UIControlStateNormal];
        [left_leftbuttoninstance addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
        left_leftbuttoninstance.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        UIBarButtonItem *NewleftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_leftbuttoninstance];
        self.navigationItem.leftBarButtonItem = NewleftBarButtonItem;
        
        /* AVANT
        UIImage *backButtonImage = [UIImage imageNamed:@"button_back_icon.png"];
        UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissView:)];
        [self.navigationItem setLeftBarButtonItem: customItem];
        */
        
    }
    else if(pageType==3){
        
        UIButton *left_leftbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
        [left_leftbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_back_icon.png"] forState:UIControlStateNormal];
        [left_leftbuttoninstance addTarget:self action:@selector(showSearchView:) forControlEvents:UIControlEventTouchUpInside];
        left_leftbuttoninstance.frame = CGRectMake(0.0, 0.0, 24.0, 24.0);
        UIBarButtonItem *NewleftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_leftbuttoninstance];
        self.navigationItem.leftBarButtonItem = NewleftBarButtonItem;
        
        /* AVANT
        UIImage *backButtonImage = [UIImage imageNamed:@"button_back_icon.png"];
        UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(showSearchView:)];
         [self.navigationItem setLeftBarButtonItem: customItem];
         */
        
    }
    
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
    
    //_banner is an instance variable with default lifetime qualifier, which means it is __strong:
    //the banner will be retained by the controller until it is released.
    [self loadAdsBanner:nil isforView:self.view withBackgroundColor:[UIColor blackColor] atPositionX:0 atPositionY:0+startPositionY];
    
    // Affichage de la Bannière pub
    [self displayAdsBanner:@"FicheChevalViewController"];
    
    /* Préparation du rendu de la liste des partants */
    CGRect rect = CGRectMake(0,53.0f+startPositionY,self.view.frame.size.width,self.view.frame.size.height-53.0f-startPositionY);
    mWebView = [[UIWebView alloc] initWithFrame:rect];
    mWebView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    mWebView.delegate = self;
    mWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [self.view addSubview:mWebView];
    
    /* Appel du FLUX en mode Asynchrone (non bloquant) */
    
    self.liveJsonDataContainer      = [NSMutableData data];
    self.liveJsonNeedsUpdate        = 0;
    
    // Requete JSON
    NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_horse_html.php?device_id=%@&source=iphone&r=%d&%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], self.horseId, rand()];
    
    NSLog(@"%@", local_uri_json);
    [self sendJsonRequest_ASync:local_uri_json];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)loadHTML{
    NSError *error;
    
    
	self.htmlText=[NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"FicheChevalTemplate.html"] encoding:NSUTF8StringEncoding error:&error];
	
    self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_INFORMATIONS_" withString:[[horsesArray valueForKey:@"informations"] stringByDecodingHTMLEntities]];
    
    self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_PERFORMANCES_" withString:[[horsesArray valueForKey:@"performances"] stringByDecodingHTMLEntities]];
    
	NSString *path =[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""];
	NSURL* contentBaseURL=[NSURL fileURLWithPath:path ];
    [mWebView loadHTMLString:htmlText baseURL:contentBaseURL];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"2/2 | Données reçues [Connexion JSON Asynchrone terminée] : %d éléments",self.liveJsonDataContainer.length);
    
    self.view.userInteractionEnabled = YES;
    
    self.liveJsonNeedsUpdate = 1;
    
    [self updateContentArrayAfterJson:@"fiche"];
    
    self.horsesArray  = [currentControllerTableViewContentArray valueForKey:@"horse"];
    self.pushAlertID  = [[self.horsesArray objectForKey:@"push_alert_id"] integerValue];
    
    [self loadHTML];
    
    if(self.pushAlertID>0){
        [self.right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_alert_moins_icon.png"] forState:UIControlStateNormal];
       
    }else{
        [self.right_rightbuttoninstance setBackgroundImage:[UIImage imageNamed:@"button_alert_plus_icon.png"] forState:UIControlStateNormal];
    }
 
    
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
}

#pragma mark - Actions
-(void) switchActiveAlert:(id) sender{
    NSURL *url;
    
    if(self.pushAlertID > 0){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail_action.php?device_id=%@&source=iphone&alert_id=4&push_alert_id=%d&action=del", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], self.pushAlertID]];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail_action.php?device_id=%@&source=iphone&alert_id=4&action=add&horse_id=%@&horse_name=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], [horsesArray valueForKey:@"id"], [[horsesArray valueForKey:@"name"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte Partants" message:@"Exception lors d'action sur les alertes" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    });
    
    
}

@end