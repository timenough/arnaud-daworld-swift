
#import "MesAlertesViewController.h"
#import "MesAlertesDetailViewCell.h"
#import "PKRevealController.h"

@interface MesAlertesViewController ()

@end

@implementation MesAlertesViewController

@synthesize headerView,
    menuSelect,
    addButton,
    feed_type_Array,
    feed_type_selected,
    alertType,
    alertViewBoxArray,
    ficheChevalViewController,
    raceViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
    }
    return self;
    
}

- (void)viewDidLoad
{
    
    self.pageTitle = @"Mes alertes";
    self.pageType  = 1;
    
    [super viewDidLoad];
    
    /* Gestion de la tableView courante */
    CGRect tableFrame   = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    currentControllerTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    currentControllerTableView.scrollEnabled = YES;
    currentControllerTableView.showsVerticalScrollIndicator = YES;
    currentControllerTableView.userInteractionEnabled = YES;
    currentControllerTableView.separatorColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    currentControllerTableView.delegate = self;
    currentControllerTableView.dataSource = self;
    currentControllerTableView.autoresizesSubviews = YES;
    currentControllerTableView.sectionFooterHeight = 0.0f;
    currentControllerTableView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    // programmeTableView.sectionHeaderHeight = 0.0f;
    [self.view addSubview:currentControllerTableView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        currentControllerTableView.separatorInset       = UIEdgeInsetsZero;
    }
    
    /* PRECHARGEMENT de la Bannière pub */
    [self loadAdsBanner:self.currentControllerTableView isforView:nil withBackgroundColor:[UIColor blackColor] atPositionX:0 atPositionY:0];
    
    /* DETERMINATION du type de flux à charger */
    feed_type_Array                 = [[NSMutableArray alloc] init];
    [feed_type_Array addObject:@[@"Mes notifications",@"notifications"]];       // id = 0
    [feed_type_Array addObject:@[@"Mes alertes Quinté",@"quinte"]];             // id = 1
    [feed_type_Array addObject:@[@"Mes alertes Partants",@"partants"]];         // id = 2
    
    /* Appel du FLUX en mode Asynchrone (non bloquant) */
    self.liveJsonDataContainer      = [NSMutableData data];
    self.liveJsonNeedsUpdate        = 1;
    //[local_user_memory setObject:self.searchDatabase forKey:@"ZoneTurf_user_searchDatabase"];
    local_user_memory                                       = [NSUserDefaults standardUserDefaults];
    self.feed_type_selected         = [local_user_memory integerForKey:@"ZoneTurf_user_lastSelectedAlertType"];
    
    [self consequenceOnTableView:self.feed_type_selected];
    
    /* Appel du FLUX en mode synchrone (bloquant tant que toutes les données n'ont pas été chargé) */
    //self.liveJsonDataContainer    = [NSMutableData data];
    //[self sendJsonRSync];
    
    /* Scroll to Refresh de la TableView (CUSTOM) */
    [refreshTableView setBackgroundColor:[UIColor whiteColor]];
    refreshTableViewAnim.color                          = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
    refreshTableViewText.textColor                      = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
    [refreshTableView addTarget:self action:@selector(consequenceOnTableView:) forControlEvents:UIControlEventValueChanged];
    [currentControllerTableView addSubview:refreshTableView];
    [currentControllerTableView sendSubviewToBack:refreshTableView];
    
    /* ATTENTE QU'UNE NOTIFICATION SOIT REÇUE POUR... */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triggerJson_for_Alertes_Partants_only) name:@"Please_Reload_MesAlertesViewController_TableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableControllerRightButton) name:@"Please_Enable_RightButtonItem" object:nil];
    
    /* SI C'EST LES PARTANTS : ON AJOUTE LES PANNEAUX DE SUPPRESSION */
    alertType                                           = [[feed_type_Array objectAtIndex:self.feed_type_selected] objectAtIndex:1];
    if([alertType isEqualToString: @"partants"]){
        [currentControllerTableView setEditing:YES animated:NO];
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    currentControllerTableView.separatorColor               = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id myArray;
    if([currentControllerTableViewContentArray isKindOfClass:[NSDictionary class]])
        myArray         = self.currentControllerTableViewContentArray;
    else
        myArray         = [self.currentControllerTableViewContentArray objectAtIndex:indexPath.row];
    alertType           = [[feed_type_Array objectAtIndex:self.feed_type_selected] objectAtIndex:1];
    
    ////// INSTANCIATION :
    raceViewController                          = [[RaceViewController alloc] init];

    ////// NOTIFICATIONS
    if([alertType isEqualToString: @"notifications"]){
        
        if([[myArray valueForKey:@"alert_id"] intValue] == 1){
            NSLog(@" ON DECLENCHE LA VUE + TAB = PRONOSTICS : %@",[[myArray valueForKey:@"params"] valueForKey:@"race"]);
        }
        else if([[myArray valueForKey:@"alert_id"] intValue] == 4){
            NSLog(@" ON DECLENCHE LA VUE + TAB = PARTANTS");
        }
        else if([[myArray valueForKey:@"alert_id"] intValue] == 5){
            NSLog(@" ON DECLENCHE LA VUE + TAB = RAPPORTS");
        }
        
        //////// DECLENCHE LE CONTROLLEUR :
        raceViewController.raceId               = [[[[myArray valueForKey:@"params"] valueForKey:@"race"] valueForKey:@"id"] intValue];
        raceViewController.raceTabIndexSelected = [[[[myArray valueForKey:@"params"] valueForKey:@"race"] valueForKey:@"tab_index_selected"] intValue];
        raceViewController.raceContexte         = [[[myArray valueForKey:@"params"] valueForKey:@"contexte"] valueForKey:@"name_complet"];
        raceViewController.pageTitle            = [[[myArray valueForKey:@"params"] valueForKey:@"race"] valueForKey:@"name_complet"];
        raceViewController.raceArrivee          = [[[myArray valueForKey:@"params"] valueForKey:@"race"] valueForKey:@"finish_result"];
        raceViewController.pageType             = 2;
        [self.navigationController pushViewController:raceViewController animated:YES];
        
    }
    ////// PARTANTS
    else if([alertType isEqualToString: @"partants"]){
        
        ///////
        /////// AppDelegate + NavigationController Instance
        ///////
        [get_the_delegate.revealController showViewController:get_the_delegate.revealController.frontViewController];
        UINavigationController *thenav          = (UINavigationController *)get_the_delegate.revealController.frontViewController;
        
        ///////
        /////// FicheCheval Instance
        ///////
        ficheChevalViewController               = [[FicheChevalViewController alloc] init];
        ficheChevalViewController.horseId       = [[myArray valueForKey:@"horse_id"] intValue];
        ficheChevalViewController.pageTitle     = @"Fiche cheval";
        ficheChevalViewController.pageType      = 2; //searchCase
        [thenav pushViewController:ficheChevalViewController animated:YES];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ([self.currentControllerTableViewContentArray isKindOfClass:[NSDictionary class]])? 1 : [self.currentControllerTableViewContentArray count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id myArray;
    alertType         = [[feed_type_Array objectAtIndex:self.feed_type_selected] objectAtIndex:1];
    
    if([currentControllerTableViewContentArray isKindOfClass:[NSDictionary class]])
        myArray = self.currentControllerTableViewContentArray;
    else
        myArray = [self.currentControllerTableViewContentArray objectAtIndex:indexPath.row];
    
    MesAlertesDetailViewCell *cell   = [[MesAlertesDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MesAlertesDetailViewCellIdentifier" withType:alertType];
    
    if (cell == nil){
        cell = [[MesAlertesDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MesAlertesDetailViewCellIdentifier" withType:alertType];
    }
    
    ///////
    /////// MES NOTIFICATIONS
    ///////
    if([alertType isEqualToString: @"notifications"]){
        cell.lblTitle.text                  = [myArray objectForKey:@"message"];
        cell.accessoryType                  = UITableViewCellAccessoryCheckmark;
    }
    ///////
    /////// ALERTES QUINTE & DERNIERE MINUTE
    ///////
    else if([alertType isEqualToString: @"quinte"]){
        cell.lblTitle.text                  = [myArray objectForKey:@"name"];
        if([[myArray objectForKey:@"active"] isEqualToString:@"oui"]){
            [cell.switchActiveButton setOn:YES animated:NO];
            cell.actionUrlParams            = @"del";
        }
        else{
            [cell.switchActiveButton setOn:NO animated:NO];
            cell.actionUrlParams            = @"add";
        }
    }
    ///////
    /////// ALERTES PARTANTS
    ///////
    else{
        [cell.switchActiveButton setOn:YES animated:NO];
        cell.actionUrlParams                = @"del";
        cell.pushAlertIDUrlParams           = [myArray objectForKey:@"id"];
        cell.indexPathCell                  = indexPath;
        cell.mesAlertesViewController       = self;
        cell.lblTitle.text                  = [myArray objectForKey:@"name"];
        
        // A LA SECTION :
        UIView *selectionColor              = [[UIView alloc] init];
        selectionColor.backgroundColor      = [UIColor colorWithRed:228.0/255 green:223.0/255 blue:216.0/255 alpha:1];
        cell.selectedBackgroundView         = selectionColor;
        cell.selectionStyle                 = UITableViewCellSelectionStyleDefault;
        cell.accessoryType                  = UITableViewCellAccessoryCheckmark;
    }

    cell.alertIDUrlParams = [myArray objectForKey:@"alert_id"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    headerView                              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    
    ///////
    /////// SELECT
    ///////
    NSMutableArray *selectMenuValues        = [[NSMutableArray alloc] init];
    for(NSUInteger j=0;j<[feed_type_Array count];j++){
        [selectMenuValues addObject:[[feed_type_Array objectAtIndex:j] objectAtIndex:0]];
    }
    menuSelect                              = [[MenuSelect alloc] initWithFrame:CGRectMake(6,6,274,28)]; // cellule de 40.0 de haut
    menuSelect.herited_delegate             = self;
    [menuSelect setBackgroundColor:[UIColor DaWorldMainColor]];
    [menuSelect setSelectListData:selectMenuValues];
    [menuSelect setDefaultValue:self.feed_type_selected];
    
    ///////
    /////// ADD BUTTON
    ///////
    addButton                               = [UIButton buttonWithType:UIButtonTypeContactAdd];
    addButton.hidden                        = NO;
    addButton.tintColor                     = [UIColor DaWorldMainColor];
    [addButton setFrame:CGRectMake(285.0, 5.0, 30.0, 30.0)];
    [addButton setBackgroundColor:[UIColor clearColor]];
    [addButton addTarget:self.parentViewController.navigationController action:@selector(showSearchView:) forControlEvents:UIControlEventTouchDown];
    [addButton setTintColor:[UIColor DaWorldMainColor]];
    [addButton setTag:998];
    
    if(self.feed_type_selected == 2){
        [addButton setAlpha:1.0];
        [addButton setEnabled:YES];
    }
    else{
        [addButton setAlpha:.5];
        [addButton setEnabled:NO];
    }
    
    headerView.clipsToBounds                = YES;
    headerView.backgroundColor              = [UIColor colorWithRed:228.0/255 green:223.0/255 blue:216.0/255 alpha:1];
    [headerView addSubview:menuSelect];
    [headerView addSubview:addButton];
    
    return headerView;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(![alertType isEqualToString: @"partants"]){
        return UITableViewCellEditingStyleNone;
    }
    else{
        return UITableViewCellEditingStyleDelete;
    }
    
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        ////////
        //////// RECUPERATION D'INFORMATIONS SUR LA CELLULE EN QUESTION :
        ////////
        id myArray;
        if([currentControllerTableViewContentArray isKindOfClass:[NSDictionary class]])
            myArray             = self.currentControllerTableViewContentArray;
        else
            myArray             = [self.currentControllerTableViewContentArray objectAtIndex:indexPath.row];
        ////////
        //////// CONFIRMATION :
        ////////
        UIAlertView *alert      = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:[NSString stringWithFormat:@"Êtes-vous sûr de vouloir supprimer l'alerte sur %@",[myArray objectForKey:@"name"]] delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui", nil];
        alertViewBoxArray       = @[indexPath,[myArray objectForKey:@"alert_id"],[myArray objectForKey:@"id"]]; // ON TRANSMET AU DELEGATE
        [alert show];
        ////////
        //////// ENVOI NATUEL AU DELEGATE
        ////////
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        ////////
        //////// RECUPERATION D'INFORMATIONS SUR LA CELLULE :
        ////////
        MesAlertesDetailViewCell *myCell;
        myCell              = [[MesAlertesDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MesAlertesDetailViewCellIdentifier" withType:alertType];
        
        ////////
        //////// SUPPRESSION EFFECTIVE :
        ////////
        myCell.actionUrlParams              = @"del";
        myCell.pushAlertIDUrlParams         = [alertViewBoxArray objectAtIndex:2];
        myCell.mesAlertesViewController     = self;
        myCell.alertIDUrlParams             = [alertViewBoxArray objectAtIndex:1]; // TRANSMIS DEPUIS LE commitEditingStyle
        [myCell switchActiveAlert:self];
        
        ////////
        //////// RELOAD DE LA TABLEVIEW
        ////////
        [self.currentControllerTableViewContentArray removeObjectAtIndex:[[alertViewBoxArray objectAtIndex:0] row]];  // TRANSMIS DEPUIS LE commitEditingStyle
        // ON MET A JOUR LE TABLEAU QUI DIT D'EXCLURE DE ELEMENTS DE LA RECHERCHE (car éléments déja sélectionnés)
        get_the_delegate.searchDatabaseHiddenShared      = self.currentControllerTableViewContentArray;
		[self.currentControllerTableView reloadData];
    }
    else if (buttonIndex == 0)
    {
        ////////
        //////// ANNULATION
        ////////
        UITableViewCell *need_the_cell          = [self.currentControllerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[alertViewBoxArray objectAtIndex:0] row] inSection:0]];
        [need_the_cell setEditing:NO];
        [need_the_cell setEditing:YES];
    }
    
}

/* Apple met automatiquement les 3 barres pour déplacer
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
 toIndexPath:(NSIndexPath *)toIndexPath {
 NSString *item = [self.currentControllerTableViewContentArray objectAtIndex:fromIndexPath.row];
 [self.currentControllerTableViewContentArray removeObject:item];
 [self.currentControllerTableViewContentArray insertObject:item atIndex:toIndexPath.row];
 
 }
 */

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES; // METTRE à NO + [super setEditing:YES animated:YES]; dans le ViewDidLoad + [cell setEditing:YES] dans le cellForRowAtIndexPath
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"[MesAlertesViewController] 4/5 = connectionDidFinishLoading | Données reçues [Connexion JSON Asynchrone terminée] : %d éléments",self.liveJsonDataContainer.length);
    
    self.view.userInteractionEnabled                = YES;
    
    self.currentControllerTableViewContentArray     = [[NSMutableArray alloc] initWithCapacity:2];
    
    self.liveJsonNeedsUpdate                        = 1;
    
    /////////
    ///////// RETOUR JSON DIFFERENT SELON LE SELECT
    /////////
    [currentControllerTableView setEditing:NO animated:NO];
    if(self.feed_type_selected == 0){
        [self updateTableViewAfterJson:@"MesAlertesViewController" withNode:@"notification"];
        
        //
        ////
        ////// PASTILLE LOGO DE L'APPLI
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self.currentControllerTableViewContentArray count]];
        //////
        ////
        //
        
    }
    else{
        [self updateTableViewAfterJson:@"MesAlertesViewController" withNode:@"push_alerte"];
        if(self.feed_type_selected == 2){
            [currentControllerTableView setEditing:YES animated:NO];
        }
    }
    
    //////// ON MET A JOUR LE TABLEAU QUI DIT D'EXCLURE DE ELEMENTS DE LA RECHERCHE (car éléments déja sélectionnés)
    get_the_delegate.searchDatabaseHiddenShared      = self.currentControllerTableViewContentArray;
    
    //////// SUITE NORMALE
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
    
    [self stopTableViewRefresh];
    
}

#pragma mark - Actions

-(void)enableControllerRightButton
{
    
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
}

-(void)consequenceOnTableView:(int)selectedValue
{
    
    if(selectedValue>[feed_type_Array count]){
        selectedValue                               = self.feed_type_selected;
    }
    self.feed_type_selected                         = selectedValue;
    [local_user_memory removeObjectForKey:@"ZoneTurf_user_lastSelectedAlertType"];
    [local_user_memory setInteger:self.feed_type_selected forKey:@"ZoneTurf_user_lastSelectedAlertType"];
    
    ///////////
    /////////// on reload la tableView du parent (Valider)
    ///////////
    if(self.feed_type_selected == 0){
        [self triggerJson_for_Notifications];
    }
    else{
        // RAZ DE LA PASTILLE LOGO DE L'APPLI
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        [self triggerJson_for_Alertes:[[feed_type_Array objectAtIndex:self.feed_type_selected] objectAtIndex:1]];
    }
    
}

-(void)triggerJson_for_Notifications
{
    
    NSLog(@"LOAD JSON des notifications !");
    
    NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_push_notifications.php?device_id=c7ae1bb085c506735d54fb83bb954837629f6823dc77a39aa4beedf2fa5692a4&source=iphone&%d", rand()];
    //NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_push_notifications.php?device_id=%@&source=iphone&%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], rand()];
    
    [self sendJsonRequest_ASync:local_uri_json];
    
}

-(void)triggerJson_for_Alertes:(NSString *)alert_Type
{
    
    NSLog(@"LOAD JSON des Alertes");
    
    NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail.php?device_id=%@&source=iphone&rubrique=%@&%d", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"],alert_Type,rand()];
    
    [self sendJsonRequest_ASync:local_uri_json];
    
}

-(void)triggerJson_for_Alertes_Partants_only
{
    
    [self triggerJson_for_Alertes:@"partants"];
    
}

@end
