
#import "MenuViewController.h"
#import "MenuViewCell.h"
#import "PKRevealController.h"
#import "ProgrammeViewController.h"
#import "ActualiteViewController.h"
#import "RaceViewController.h"
#import "MesNotesViewController.h"
#import "MesAlertesViewController.h"
#import "CalculPariViewController.h"
#include "DotInUIImageView.h"

@implementation MenuViewController

@synthesize menuSectionTableViewArray,
    menuSectionStatus,
    overlay,
    menuSectionArray,
    menuElementsArray,
    requestData,
    menuElementsArrayPersistant,
    cellSubSection,
    json_error,
    json_need_update,
    menuTableView,
    timer,
    searchBar2;

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout     = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor       = [UIColor colorWithRed:35.0/255 green:32.0/255 blue:28.0/255 alpha:1];
    
    //Initialisation variables
    NSNumber *yesObj = [NSNumber numberWithBool:YES];
    NSNumber *noObj  = [NSNumber numberWithBool:NO];
    
    self.menuSectionStatus          = [[NSMutableArray alloc ] initWithObjects:noObj, yesObj, noObj, noObj, yesObj, noObj, nil];
    self.menuSectionArray           = [[NSArray alloc ] initWithObjects:@"reunions", @"quinte", @"pratique", @"actualite", nil];
    self.menuSectionTableViewArray  = [[NSArray alloc ] initWithObjects:@"Partants - pronostics - rapports", @"Quinté", @"Pratique", @"Actualités", nil];
    self.cellSubSection             = -1;
    
    // Appel du FLUX en mode Asynchrone (non bloquant)
    self.requestData                = [NSMutableData data];
    self.json_need_update           = 0;
    [self triggerJson];
    
    // Scroll to Refresh de la TableView (CUSTOM)
    [refreshTableView setBackgroundColor:[UIColor colorWithRed:35.0/255 green:32.0/255 blue:28.0/255 alpha:1]];
    refreshTableViewAnim.color                          = [UIColor colorWithRed:224.0/255 green:207.0/255 blue:194.0/255 alpha:1];
    refreshTableViewText.textColor                      = [UIColor colorWithRed:224.0/255 green:207.0/255 blue:194.0/255 alpha:1];
    [refreshTableView addTarget:self action:@selector(triggerJson) forControlEvents:UIControlEventValueChanged];
    [self.menuTableView addSubview:refreshTableView];
    [self.menuTableView sendSubviewToBack:refreshTableView];
    
    // Moteur de recherche du Xib
    self.searchBar2.delegate        = self;
    self.searchBar2.placeholder     = @"Recherche";
    [[UISearchBar appearance] setBackgroundColor:[UIColor colorWithRed:35.0/255 green:32.0/255 blue:28.0/255 alpha:1]];
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1]];
    
    // Problème de la Status Bar à partir de la v7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
        // SearchBar
        self.searchBar2.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        // Tableview
        CGRect frame                = self.menuTableView.frame;
        frame.origin.y              = statusBarFrame.size.height + self.searchBar2.frame.size.height;
        frame.size.height = CGRectGetHeight(frame) - statusBarFrame.size.height;
        self.menuTableView.frame = frame;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.menuTableView.separatorInset       = UIEdgeInsetsZero;
    }
    
}

#pragma mark - SearchBar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    // On active le SearchDisplayController
    [self showSearchView:self];
    
    return NO;
    
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotate
{
    
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskAll;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return YES;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
    MenuViewCell *cell;

    if (currentSelectedIndexPath)
    {
        cell = (MenuViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.type==MENU_SECTION){
            
            //Derouler et reloader le tableau
            if(cell.status == SECTION_CLOSE){
                cell.status = SECTION_OPEN;
                [self.menuSectionStatus replaceObjectAtIndex:cell.subSectionNumber withObject:[NSNumber numberWithBool:YES]];
            }else{
                cell.status = SECTION_CLOSE;
                [self.menuSectionStatus replaceObjectAtIndex:cell.subSectionNumber withObject:[NSNumber numberWithBool:NO]];
            }
            
            [self changeMenuElementsArray];
            [tableView reloadData];
            
        }else if(cell.type==MENU_REUNION){
            
            //Charger le controller des reunions
            ProgrammeViewController *programmeViewController = [[ProgrammeViewController alloc] init];
            UINavigationController *programmeNavigationViewController = [[UINavigationController alloc] initWithRootViewController:programmeViewController];
            programmeViewController.reunionDate     = cell.reunionDate;
            programmeViewController.reunionSelected = cell.reunionNumber;
            programmeViewController.isScrolling     = YES;
            programmeViewController.pageTitle       = cell.raceName;
            
            self.revealController.frontViewController = programmeNavigationViewController;
            [self.revealController showViewController:self.revealController.frontViewController];
            
        }else if(cell.type==MENU_QUINTE){
            if(cell.isClicable){
                RaceViewController *raceViewController = [[RaceViewController alloc] init];
                UINavigationController *raceNavigationViewController = [[UINavigationController alloc] initWithRootViewController:raceViewController];
                raceViewController.raceInfoTabStatus    = cell.raceInfoTabStatus;
                raceViewController.raceId               = cell.raceId;
                raceViewController.raceTabIndexSelected = cell.raceTabSelected;
                raceViewController.raceContexte         = cell.raceContexte;
                raceViewController.pageTitle            = cell.raceName;
                raceViewController.raceArrivee          = cell.raceArrivee;
                raceViewController.pageType             = 1;
                
                [self.navigationController pushViewController:raceViewController animated:YES];
            
                self.revealController.frontViewController = raceNavigationViewController;
                [self.revealController showViewController:self.revealController.frontViewController];
            }
        }else{
            if([cell.lblReunion.text isEqualToString:@"MES NOTES"]){
                MesNotesViewController *pratiqueViewController = [[MesNotesViewController alloc] init];
                UINavigationController *pratiqueNavigationViewController = [[UINavigationController alloc] initWithRootViewController:pratiqueViewController];
                pratiqueViewController.pageTitle = @"Mes notes";
                pratiqueViewController.pageType  = 1;
                
                self.revealController.frontViewController = pratiqueNavigationViewController;
            }else if([cell.lblReunion.text isEqualToString:@"MES ALERTES"]){
                MesAlertesViewController *pratiqueViewController = [[MesAlertesViewController alloc] init];
                UINavigationController *pratiqueNavigationViewController = [[UINavigationController alloc] initWithRootViewController:pratiqueViewController];
                pratiqueViewController.pageTitle = @"Mes alertes";
                pratiqueViewController.pageType  = 1;
                self.revealController.frontViewController = pratiqueNavigationViewController;
            }else if([cell.lblReunion.text isEqualToString:@"CALCULER LE PRIX DE MON PARI"]){
                CalculPariViewController *pratiqueViewController = [[CalculPariViewController alloc] init];
                UINavigationController *pratiqueNavigationViewController = [[UINavigationController alloc] initWithRootViewController:pratiqueViewController];
                pratiqueViewController.pageTitle = @"Calculer mon pari";
                pratiqueViewController.pageType  = 1;
                
                self.revealController.frontViewController = pratiqueNavigationViewController;
            }else{
                ActualiteViewController *pratiqueViewController = [[ActualiteViewController alloc] init];
                UINavigationController *pratiqueNavigationViewController = [[UINavigationController alloc] initWithRootViewController:pratiqueViewController];
                
                if([cell.lblReunion.text isEqualToString:@"A LA UNE"])
                    pratiqueViewController.actualiteFilter = 0;
                else if([cell.lblReunion.text isEqualToString:@"QUINTE"])
                        pratiqueViewController.actualiteFilter = 1;
                else 
                    pratiqueViewController.actualiteFilter = 2;
           
                
                self.revealController.frontViewController = pratiqueNavigationViewController;
            }
            
            //rappelle la frontView
            [self.revealController showViewController:self.revealController.frontViewController];
        }
        
        [tableView deselectRowAtIndexPath:currentSelectedIndexPath animated:YES];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
	return [[self.menuElementsArray objectAtIndex:section] count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
	return [self.menuSectionArray count];
    
}


- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    
    UIImageView *view        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    view.backgroundColor    = [UIColor colorWithRed:23.0/255 green:21.0/255 blue:17.0/255 alpha:1];
    UILabel *label          = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width, 35)];
    
    label.text              = [menuSectionTableViewArray objectAtIndex:section];
    label.textColor         = [UIColor whiteColor];
    label.backgroundColor   = [UIColor clearColor];
    label.font              = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
    [view addSubview:label];
    
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int dotcol;
    MenuViewCell *cell      = nil;
    NSInteger sectionIndex  = indexPath.section;
    NSDictionary *myArray = [[self.menuElementsArray objectAtIndex:sectionIndex] objectAtIndex:indexPath.row];
    
    switch (sectionIndex) {
            
            //Section reunion hier / aujourd'hui / demain
        case 0:
            if([[myArray objectForKey:@"id"] isEqual:@"0"]){
                
                
                cell   = [tableView dequeueReusableCellWithIdentifier:@"menuReunionSectionCellIdentifier"];
                
                
                if (cell == nil){
                    cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuReunionSectionCellIdentifier" withType:MENU_SECTION];
                    
                    self.cellSubSection++;
                    cell.subSectionNumber = self.cellSubSection;
                    
                    if(![[self.menuSectionStatus objectAtIndex:self.cellSubSection] boolValue])
                        cell.status=SECTION_CLOSE;
                    else
                        cell.status=SECTION_OPEN;
                    
                }
                
                cell.lblReunion.text        = [myArray objectForKey:@"date"];
                
                if(cell.status==SECTION_CLOSE){
                    cell.imgQuinteView.image    = [UIImage imageNamed:@"icon_section_menu_fleche_haut.png"];
                }else{
                    cell.imgQuinteView.image    = [UIImage imageNamed:@"icon_section_menu_fleche_bas.png"];
                }
                
                cell.subSectionStatus = [[menuSectionStatus objectAtIndex:self.cellSubSection] boolValue];
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier: @"HomeReunionViewCell"];
                
                
                if (cell == nil) {
                    cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeReunionViewCell"  withType:MENU_REUNION];
                }
                
                        if([[myArray objectForKey:@"status"] isEqualToString:@"icon_reunion_green.png"]){
                            dotcol = 1;
                        }
                        else if([[myArray objectForKey:@"status"] isEqualToString:@"icon_reunion_red.png"]){
                            dotcol = 2;
                        }
                        else{
                            dotcol = 0;
                        }
                        [DotInUIImageView colorizeDot:cell.imgReunionView dotOpacity:1.0 dotSize:7.4f dotColor:dotcol strokeSize:.6f];
                        //cell.imgReunionView.image   = [UIImage imageNamed:[myArray objectForKey:@"status"]];
                
                if([[myArray objectForKey:@"quinte"] isEqual:@"1"]){
                    cell.imgQuinteView.image    = [UIImage imageNamed:@"logo_quinte.png"];
                }else{
                    cell.imgQuinteView.image    = nil;
                }
                
                cell.lblReunion.text        = [myArray objectForKey:@"reunion"];
                cell.reunionDate            = [myArray objectForKey:@"date_string"];
                cell.reunionNumber          = [[myArray objectForKey:@"index"] intValue];
                cell.lblReunionHour.text    = [myArray objectForKey:@"hour"];
               
                
                cell.subSectionStatus = [[self.menuSectionStatus objectAtIndex:self.cellSubSection] boolValue];
                
            }
            
            break;
            
            //Section quinté
        case 1:
            if([[myArray objectForKey:@"id"] isEqual:@"0"]){
                
                
                
                cell   = [tableView dequeueReusableCellWithIdentifier:@"menuQuinteSectionCellIdentifier"];
                
                
                if (cell == nil){
                    cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuQuinteSectionCellIdentifier" withType:MENU_SECTION];
                    self.cellSubSection++;
                    cell.subSectionNumber = self.cellSubSection;
                    
                    if(![[self.menuSectionStatus objectAtIndex:self.cellSubSection] boolValue])
                        cell.status=SECTION_CLOSE;
                    else
                        cell.status=SECTION_OPEN;
                }
                
                cell.lblReunion.text        = [myArray objectForKey:@"date"];
                
                
                if(cell.status==SECTION_CLOSE){
                    cell.imgQuinteView.image    = [UIImage imageNamed:@"icon_section_menu_fleche_haut.png"];
                }else{
                    cell.imgQuinteView.image    = [UIImage imageNamed:@"icon_section_menu_fleche_bas.png"];
                }
                
                cell.subSectionStatus   = [[self.menuSectionStatus objectAtIndex:self.cellSubSection] boolValue];
                
                
            }else{
                
                cell = [tableView dequeueReusableCellWithIdentifier:@"menuQuinteCellIdentifier"];
                
                
                if (cell == nil)
                {
                    cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuQuinteCellIdentifier"  withType:MENU_QUINTE];
                    
                }
                cell.isClicable              = YES;
                
                cell.lblReunion.text         = [[[self.menuElementsArray objectAtIndex:sectionIndex] objectAtIndex:indexPath.row] objectForKey:@"libelle"];
                
                                if([[myArray objectForKey:@"status"] isEqualToString:@"icon_reunion_green.png"]){
                                    dotcol = 1;
                                }
                                else if([[myArray objectForKey:@"status"] isEqualToString:@"icon_reunion_red.png"]){
                                    dotcol = 2;
                                }
                                else{
                                    dotcol = 0;
                                }
                                [DotInUIImageView colorizeDot:cell.imgReunionView dotOpacity:1.0 dotSize:7.4f dotColor:dotcol strokeSize:.6f];
                                //cell.imgReunionView.image    = [UIImage imageNamed:[myArray objectForKey:@"status"]];
                
                cell.raceId                  = [[myArray objectForKey:@"id"] intValue];
                
                
                if([cell.lblReunion.text isEqualToString:@"PARTANTS"]){
                    cell.raceTabSelected     = 0;
                    cell.raceInfoTabStatus   = [[NSArray alloc ] initWithObjects:@"true", [myArray objectForKey:@"hasprono"], [myArray objectForKey:@"hasrapport"], nil];
                }else if([cell.lblReunion.text isEqualToString:@"PRONOSTICS"]){
                    if([[myArray objectForKey:@"hasprono"] isEqual:@"false"]){
                        cell.isClicable = NO;
                        cell.lblReunion.textColor = [UIColor colorWithRed:80.0f/255 green:73.0f/255 blue:63.0f/255 alpha:1];
                    }
                    cell.raceTabSelected     = 1;
                    
                    cell.raceInfoTabStatus   = [[NSArray alloc ] initWithObjects:@"true", [myArray objectForKey:@"hasprono"], [myArray objectForKey:@"hasrapport"], nil];
                }else{
                    if([[myArray objectForKey:@"hasrapport"] isEqual:@"false"]){
                        cell.isClicable = NO;
                        cell.lblReunion.textColor = [UIColor colorWithRed:80.0f/255 green:73.0f/255 blue:63.0f/255 alpha:1];
                    }else{
                        cell.lblReunion.textColor = [UIColor whiteColor];
                    }
                    cell.raceTabSelected     = 2;
                    
                    cell.raceInfoTabStatus   = [[NSArray alloc ] initWithObjects:@"true", [myArray objectForKey:@"hasprono"], [myArray objectForKey:@"hasrapport"], nil];
                }
                
                cell.raceName         = [myArray objectForKey:@"namecomplet"];
                cell.raceContexte     = [myArray objectForKey:@"contexte"];
                cell.raceArrivee      = [myArray objectForKey:@"finishresult"];
                cell.subSectionStatus = [[self.menuSectionStatus objectAtIndex:self.cellSubSection] boolValue];
            }
            
            break;
            //Section pratique
        case 2:
            cell  = [tableView dequeueReusableCellWithIdentifier:@"menuPratiqueCellIdentifier"];
            
            if (cell == nil){
                cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuPratiqueCellIdentifier"  withType:MENU_BASIC];
            }
            
            //////
            ////// BADGE TOTAL NOTIFICATIONS
            //////
            //cell.lblBadgeValue.text = @"33";
            //[cell.lblBadgeValue setHidden:NO];
            
            
            cell.lblReunion.text  = [[menuElementsArray objectAtIndex:sectionIndex] objectAtIndex:indexPath.row];
        break;
            
            //Section actualités
        default:
            cell  =  [tableView dequeueReusableCellWithIdentifier:@"menuActualiteCellIdentifier"];
            
            if (cell == nil){
                
                cell = [[MenuViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuActualiteCellIdentifier" withType:MENU_BASIC];
                
            }
            cell.lblReunion.text  = [[menuElementsArray objectAtIndex:sectionIndex] objectAtIndex:indexPath.row];
            break;
            
    }
    cell.backgroundColor    = [UIColor colorWithRed:55.0/255 green:50.0/255 blue:43.0/255 alpha:1];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger sectionIndex      = indexPath.section;
    CGFloat cellHeight;
    
    if(sectionIndex < 2 && [[[[self.menuElementsArray objectAtIndex:sectionIndex] objectAtIndex:indexPath.row] objectForKey:@"id"] isEqual:@"0"])
        cellHeight = 20.0f;
    else
        cellHeight = 25.0f;
    
    return cellHeight;
    
}

#pragma mark - Actions

- (void)changeMenuElementsArray
{
    
    //Manipulation du tableau persistant pour gerer l'acordion
    NSMutableArray *myMutableArray;
    int indiceSection = 0;
    BOOL hasReunion = NO;
    
    self.menuElementsArray = [[NSMutableArray alloc] initWithCapacity:[menuSectionArray count]];
    
    for(NSUInteger i=0;i<[self.menuElementsArrayPersistant count];i++){
        
        if(i==0 || i==1){
            myMutableArray = [[NSMutableArray alloc] init];
            
            for(NSUInteger j=0;j<[[self.menuElementsArrayPersistant objectAtIndex:i] count];j++){
                if([[[[self.menuElementsArrayPersistant objectAtIndex:i] objectAtIndex:j] valueForKey:@"id"] isEqual:@"0"]){
                    
                    hasReunion = [[self.menuSectionStatus objectAtIndex:indiceSection] boolValue];
                    
                    [myMutableArray addObject:[[self.menuElementsArrayPersistant objectAtIndex:i] objectAtIndex:j]];
                    indiceSection++;
                }else{
                    if(hasReunion){
                        [myMutableArray addObject:[[self.menuElementsArrayPersistant objectAtIndex:i] objectAtIndex:j]];
                    }
                }
            }
            [self.menuElementsArray insertObject:myMutableArray  atIndex:i];
            myMutableArray = nil;
        }else{
            [self.menuElementsArray insertObject:[self.menuElementsArrayPersistant objectAtIndex:i]  atIndex:i];
            
        }
    }
    
}

-(void)triggerJson
{
    
    [self sendJsonRAsync];
    
}

- (void)sendJsonRAsync
{
    
    self.overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlay.center;
    [self.overlay addSubview:self.activityIndicator];
    
    [activityIndicator startAnimating];
    [self.menuTableView addSubview:self.overlay];
    
    NSMutableURLRequest *urlRequest = [
                                       NSURLRequest
                                       //requestWithURL:[
                                       //  NSURL URLWithString:@"http://www.daworld.co/json_menu.php?15"]
                                       requestWithURL:[
                                                       NSURL URLWithString:@"http://www.daworld.co/json_menu.php?15"]
                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                       timeoutInterval:10.0
                                       ];
    NSURLConnection *conn2 = [
                             [NSURLConnection alloc]
                             initWithRequest:urlRequest
                             delegate:self
                             ];
    if (conn2) {
        NSLog(@"[MenuViewController] 1/5 = sendJsonRAsync | Connexion au flux jSON en Asynchrone réussie...");
    }
    else {
        NSLog(@"[MenuViewController] 1/5 = sendJsonRAsync | ERREUR : impossible de se connecter pour récuper le flux jSON en Asynchrone.");
    }
    
    // et là Hop on pass aux méthode de gestion du NSURLConnection (voir plus bas)
    // - didReceiveResponse
    // - didReceiveData
    // - didFailWithError
    // - connectionDidFinishLoading
}

- (void)sendLoadAfterJson
{
    
    NSError *error = self.json_error;
    NSMutableArray *elementsKeys;
    NSMutableArray *menuJSONElementsArray;
    
    if (error == nil)
    {
        // Parse data here
        NSData *jsonData = self.requestData;
        NSLog(@"[MenuViewController] 5/5 = sendLoadAfterJson | Total to Treat : %d elements.",jsonData.length);
        
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if(self.json_need_update == 1){
            [self.menuElementsArray removeAllObjects];
        }
        
        //On rempli le tableau avec toutes les datas du JSON
        for (NSString *key in self.menuSectionArray) {
            if([key isEqual:@"reunions"]){
                elementsKeys = [[jsonObjects objectForKey:key] objectForKey:@"reunion"];
                menuJSONElementsArray = [[NSMutableArray alloc] initWithCapacity:[elementsKeys count]];
                for (NSDictionary *item in elementsKeys){
                    [menuJSONElementsArray addObject:item];
                }
            }else if([key isEqual:@"quinte"]){
                elementsKeys = [[jsonObjects objectForKey:key] objectForKey:@"course"];
                menuJSONElementsArray = [[NSMutableArray alloc] initWithCapacity:[elementsKeys count]];
                for (NSDictionary *item in elementsKeys){
                    [menuJSONElementsArray addObject:item];
                }
            }else if([key isEqual:@"pratique"]){
                elementsKeys = [[jsonObjects objectForKey:key] objectForKey:@"libelle"];
                menuJSONElementsArray = [[NSMutableArray alloc] initWithCapacity:[elementsKeys count]];
                menuJSONElementsArray = elementsKeys;
                
            }else if([key isEqual:@"actualite"]){
                elementsKeys = [[jsonObjects objectForKey:key] objectForKey:@"libelle"];
                menuJSONElementsArray = [[NSMutableArray alloc] initWithCapacity:[elementsKeys count]];
                menuJSONElementsArray = elementsKeys;
            }
            
            [self.menuElementsArray addObject:menuJSONElementsArray];
            menuJSONElementsArray = nil;
            elementsKeys = nil;
        }
    }
    
    self.menuElementsArrayPersistant = self.menuElementsArray;
    
    [self changeMenuElementsArray];
    
    // Each view can dynamically specify the min/max width that can be revealed.
    [self.revealController setMinimumWidth:280.0f maximumWidth:324.0f forViewController:self];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"[MenuViewController] 2/5 = didReceiveResponse | Réponse reçue");
    [self.requestData setLength:0];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.requestData appendData:data];
    NSLog(@"[MenuViewController] 3/5 = didReceiveData | Données reçues [Connexion JSON asynchrone non terminée] : %d éléments",self.requestData.length);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [activityIndicator stopAnimating];
    [self.overlay removeFromSuperview];
    
    [self stopTableViewRefresh];
    
    NSLog(@"[MenuViewController] 3/5 = connectionDidFinishLoading | ERREUR à la fin [Connexion JSON asynchrone terminée] : %d éléments",self.requestData.length);
    
    [liveJsonErrorAlert show];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"[MenuViewController] 4/5 = connectionDidFinishLoading | Données reçues [Connexion JSON asynchrone terminée] : %d éléments",self.requestData.length);
    
    self.menuElementsArrayPersistant = nil;
    
    self.view.userInteractionEnabled = YES;
    
    self.menuElementsArray          = [[NSMutableArray alloc] initWithCapacity:[menuSectionArray count]];
    self.menuElementsArrayPersistant= [[NSMutableArray alloc] initWithCapacity:[menuSectionArray count]];
    
    self.json_need_update = 1;
    [self sendLoadAfterJson];
    [self.menuTableView reloadData];
    
    [activityIndicator stopAnimating];
    [self.overlay removeFromSuperview];
    
    [self stopTableViewRefresh];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                   willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    
    // Return nil to indicate not necessary to store a cached response for this connection
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)[cachedResponse response];
    
    // Look up the cache policy used in our request
    if([connection currentRequest].cachePolicy == NSURLRequestUseProtocolCachePolicy) {
        NSDictionary *headers = [httpResponse allHeaderFields];
        NSString *cacheControl = [headers valueForKey:@"Cache-Control"];
        NSString *expires = [headers valueForKey:@"Expires"];
        if((cacheControl == nil) && (expires == nil)) {
            NSLog(@"(MenuViewController) server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
            return nil; // don't cache this
        }
    }
    return cachedResponse;
    
}

@end