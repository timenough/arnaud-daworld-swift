
#import "SearchViewController.h"
#import "SearchResultViewCell.h"
#import "RaceViewController.h"
#import "PKRevealController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize searchDisplayController,
    searchResults,
    searchBar,
    searchDatabase,
    ficheChevalViewController;

- (void)viewDidLoad
{
    
    ///////////////////////////
    // MOTEUR DE RECHERCHE
    ///////////////////////////
    local_user_memory                                       = [NSUserDefaults standardUserDefaults];
    searchBar                                               = [[UISearchBar alloc] init];
    [[UISearchBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UISearchBar appearance] setBackgroundColor:[UIColor colorWithRed:35.0/255 green:32.0/255 blue:28.0/255 alpha:1]];
    [[UISearchBar appearance] setTintColor:[UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    }
    else{
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor blackColor]];
    }
    [searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:224.0/255 green:207.0/255 blue:194.0/255 alpha:1], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [searchBar setScopeBarButtonTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
	[searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[searchBar sizeToFit /*setScopeButtonTitles:[NSArray arrayWithObjects:@"Tout",@"Chevaux",@"Proprietaires",nil]*/];
    searchBar.placeholder                                   = @"Recherche";
    searchBar.delegate                                      = self;
    [searchBar becomeFirstResponder];
    [self.view addSubview:searchBar];
    [self.view bringSubviewToFront:searchBar];
    
    //////////////////////////////
    // SEARCH DISPLAY CONTROLLER
    //////////////////////////////
    searchDisplayController                                 = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    searchDisplayController.delegate                        = self;
    searchDisplayController.searchResultsDataSource         = self;
    searchDisplayController.searchResultsDelegate           = self;
    [searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1]];
    searchDisplayController.searchResultsTableView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        searchDisplayController.searchResultsTableView.separatorInset       = UIEdgeInsetsZero;
    }
    
    ////////////////////////////////
    // SEARCH DATABASE LOAD ASYNC
    ////////////////////////////////
    NSArray *searchDatabaseFromLocalMemory      = [local_user_memory arrayForKey:@"ZoneTurf_user_searchDatabase"];
    self.searchDatabase                         = [searchDatabaseFromLocalMemory mutableCopy];
    if(self.searchDatabase == nil){
        self.searchDatabase                     = [[NSMutableArray alloc] init];
        NSString *local_uri_json                = @"http://www.daworld.co/json_search.php?s=1";
        [self sendJsonRequest_ASync:local_uri_json];
    }
    
    /* VIDAGE MEMOIRE
     [local_user_memory removeObjectForKey:@"ZoneTurf_user_searchDatabase"];
     [local_user_memory removeObjectForKey:@"ZoneTurf_user_searchTerm"];
     */
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UISearchDisplayControllerDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller         shouldReloadTableForSearchString:(NSString *)searchString
{
    
    NSLog(@"---- LIVE text = %@",searchString);
    
    [self filterContentForSearchText:searchString
                               scope:[
                                      [self.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchBar selectedScopeButtonIndex]
                                      ]
     ];
    
    return YES;

}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSPredicate *resultPredicate            = [NSPredicate predicateWithFormat:@"name contains[cd] %@",searchText];
    self.searchResults                      = [self.searchDatabase filteredArrayUsingPredicate:resultPredicate];

    /////////////////////////////////////
    // SEARCH DATABASE ITEMS TO EXCLUDE
    /////////////////////////////////////
    if(self.view.tag == 998){
        get_the_delegate                    = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSMutableArray *new_searchResults   = [[NSMutableArray alloc] initWithArray:self.searchResults];
        for(NSUInteger j=0;j<[self.searchResults count];j++){
            for(NSUInteger k=0;k<[get_the_delegate.searchDatabaseHiddenShared count];k++){
                int first_id                = [[[self.searchResults objectAtIndex:j] valueForKey:@"id"] intValue];
                int second_id               = [[[get_the_delegate.searchDatabaseHiddenShared objectAtIndex:k] valueForKey:@"horse_id"] intValue];
                //
                // Si la cellule qui est sur le point d'être affichée (filtrage) est déjà dans la liste des Alertes :
                //
                if(first_id == second_id){
                    [new_searchResults removeObjectIdenticalTo:[self.searchResults objectAtIndex:j]];
                }
            }
        }
        self.searchResults                  = new_searchResults;
    }
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller         willShowSearchResultsTableView:(UITableView *)tableView
{
    
     tableView.backgroundColor              = [UIColor colorWithRed:55.0/255 green:50.0/255 blue:43.0/255 alpha:1];

}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
    CGRect statusBarFrame =  [[UIApplication sharedApplication] statusBarFrame];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *subview in self.view.subviews)
                subview.transform = CGAffineTransformMakeTranslation(0, -statusBarFrame.size.height);
        }];
    }
    
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
    [searchDisplayController setActive:YES animated:NO];
    [searchDisplayController.searchBar becomeFirstResponder];
    searchDisplayController.searchBar.hidden                = NO;
    
    /////////
    ///////// RECUPERATION DE LA DERNIERE RECHERCHE EN MEMOIRE
    /////////
    NSString *lastSearchTerm                                = [local_user_memory stringForKey:@"ZoneTurf_user_searchTerm"];
    if(lastSearchTerm != nil){
        searchDisplayController.searchBar.text              = lastSearchTerm;
        ////////// DECLENCHE > shouldReloadTableForSearchString
        if(self.view.tag == 997){
            [searchDisplayController.searchBar resignFirstResponder];
            [searchViewController.view setTag:1000];
        }
    }
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [searchDisplayController setActive:NO animated:NO];
        [searchDisplayController.searchBar resignFirstResponder];
        searchDisplayController.searchBar.hidden                = YES;
    }
    
        /* SEARCH SPECIAL CASE = réactive la Loupe du MesAlertesViewController car elle crée un CRASH (double clic car déallocation puis réallocation) */
        if(self.view.tag == 998){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Please_Enable_RightButtonItem" object:nil];
        }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    NSLog(@"---- Recherche terminée");
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self displayLoadingActivityPopup:self.searchDisplayController.searchResultsTableView isforView:nil];
    
    ///////
    /////// Enregistrement en mémoire de la recherche
    ///////
    [local_user_memory removeObjectForKey:@"ZoneTurf_user_searchTerm"];
    [local_user_memory setObject:[searchDisplayController.searchBar text] forKey:@"ZoneTurf_user_searchTerm"];
    
    ///////
    /////// Requete JSON ASYNCHRONE au click du bouton "Rechercher"
    ///////
    NSString *finalSearchString                             = [[searchDisplayController.searchBar text] stringByReplacingOccurrencesOfString:@" " withString: @"+"];
    NSString *local_uri_json                                = [NSString stringWithFormat:@"http://www.daworld.co/json_search.php?r=%@",finalSearchString];
    [self sendJsonRequest_ASync:local_uri_json];
    
    ///////
    /////// Requete JSON SYNCHRONE au click du bouton "Rechercher"
    ///////
    /*
    NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_search.php?r=%@",[searchDisplayController.searchBar text]];
    [self sendJsonRequest_Sync:local_uri_json isForTableView:searchDisplayController.searchResultsTableView param1:[searchDisplayController.searchBar text]];
     */
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

    NSLog(@"---- CANCEL BUTTON CLicked");

}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSLog(@"---- Nombre de résultats = %i",[searchResults count]);
    return [searchResults count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchResultViewCell *cell          = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCellIdentifier"];
    
    if (cell == nil){
        cell                            = [[SearchResultViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultCellIdentifier"];
    }
    
    /////////////
    ///////////// TEXTE
    /////////////
    cell.lblCheval.text                 = [NSString stringWithFormat:@"%@ %@%@ (%@)",[[searchResults valueForKey:@"name"] objectAtIndex:indexPath.row],[[searchResults valueForKey:@"sex"] objectAtIndex:indexPath.row],[[searchResults valueForKey:@"age"] objectAtIndex:indexPath.row],[[searchResults valueForKey:@"origine"] objectAtIndex:indexPath.row]];

    /////////////
    ///////////// PICTO
    /////////////
    NSString *urlImage                  = [NSString stringWithFormat:@"http://www.zone-turf.fr/media%@",[[searchResults valueForKey:@"casaque"] objectAtIndex:indexPath.row]];
    AppDelegate *appDelegate            = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [UIImageView setDefaultEngine:appDelegate.imageCacheEngine];
    [cell.imgChevalView setImageFromURL:[NSURL URLWithString:urlImage] placeHolderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    /////////////
    ///////////// STYLE
    /////////////
    [cell setBackgroundColor:[UIColor colorWithRed:55.0/255 green:50.0/255 blue:43.0/255 alpha:1]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [cell setTintColor:[UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1]];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1];
    }
    UIView *selectionColor              = [[UIView alloc] init];
    selectionColor.backgroundColor      = [UIColor colorWithRed:119.0/255 green:165.0/255 blue:45.0f/255.0f alpha:1];
    cell.selectedBackgroundView         = selectionColor;
    cell.selectionStyle                 = UITableViewCellSelectionStyleDefault;
    
    /* SEARCH SPECIAL CASE */
    if(self.view.tag == 998){
        
        UIButton *addButton                 = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addButton.hidden                    = NO;
        addButton.tintColor                 = [UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1];
        [addButton setFrame:CGRectMake(285.0, 5.0, 30.0, 30.0)];
        [addButton setBackgroundColor:[UIColor clearColor]];
        [addButton addTarget:self.parentViewController.navigationController action:@selector(PlusButtonPressed:) forControlEvents:UIControlEventTouchDown];
        [addButton setTintColor:[UIColor colorWithRed:101.0/255 green:89.0/255 blue:73.0/255 alpha:1]];
        [addButton setTag:indexPath.row];
        cell.accessoryView = addButton;
        cell.accessoryType                  = UITableViewCellAccessoryNone;
        
    }
    /* SEARCH NORMAL CASE */
    else{
        
        cell.accessoryType                  = UITableViewCellAccessoryDetailButton;
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /* SEARCH SPECIAL CASE */
    if(self.view.tag == 998){
        
        ///////
        /////// Requete JSON
        ///////
        NSString *local_uri_json                = [NSString stringWithFormat:@"http://www.daworld.co/json_mesalertes_detail_action.php?device_id=%@&source=iphone&alert_id=4&action=add&horse_id=%d&horse_name=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"PushDeviceID"], [[[searchResults valueForKey:@"id"] objectAtIndex:indexPath.row] intValue], [[[searchResults valueForKey:@"name"] objectAtIndex:indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [self sendJsonRequest_ASyncForAlert:local_uri_json horseName:[[[searchResults valueForKey:@"name"] objectAtIndex:indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
    }
    /* SEARCH NORMAL CASE */
    else{
        
        ///////
        /////// AppDelegate + NavigationController Instance
        ///////
        [get_the_delegate.revealController showViewController:get_the_delegate.revealController.frontViewController];
        UINavigationController *thenav          = (UINavigationController *)get_the_delegate.revealController.frontViewController;
        
        ///////
        /////// FicheCheval Instance
        ///////
        ficheChevalViewController               = [[FicheChevalViewController alloc] init];
        ficheChevalViewController.horseId       = [[[searchResults valueForKey:@"id"] objectAtIndex:indexPath.row] intValue];
        ficheChevalViewController.pageTitle     = @"Fiche cheval";
        ficheChevalViewController.pageType      = 3; //searchCase
        [thenav pushViewController:ficheChevalViewController animated:YES];
        
    }
    ///////
    /////// SearchDisplayController Hide
    ///////
    [searchDisplayController setActive:NO animated:NO];
    
    /* FACON ACTIONSHEET :
     UIActionSheet *asheet = [[UIActionSheet alloc] init];
     [asheet showInView:self.view];
     [asheet setFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
     [asheet addSubview:ficheChevalViewController.view];
     */
    
}

-(void)PlusButtonPressed:(id)sender
{
    
    UIButton *the_sender                    = (UIButton*)sender;
    UITableViewCell *need_the_cell          = [searchDisplayController.searchResultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:the_sender.tag inSection:0]];
    NSIndexPath *need_the_cell_path         = [searchDisplayController.searchResultsTableView indexPathForCell:need_the_cell];
    [self tableView:searchDisplayController.searchResultsTableView didSelectRowAtIndexPath:need_the_cell_path];
    
}

#pragma mark - NSURLConnection Delegate Methods

- (void)sendJsonRequest_ASyncForAlert:(NSString *)JsonURI horseName:(NSString *)theHorseName
{
    
    NSURL *url;
    url = [NSURL URLWithString:JsonURI];
    
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
            
            //////////
            ////////// AJOUT DYNAMIQUE DE LA CELLULE (Array) :
            //////////
            /*
            NSDictionary *dynamicCellDict = @{
                                          @"active" : @"oui",
                                          @"alert_id" : [NSNumber numberWithInt:4],
                                          @"id" : [NSNumber numberWithInt:[[[Json objectForKey:@"params"] objectForKey:@"value"] intValue]],
                                          @"nale" : theHorseName,
            };
            NSMutableArray *dynamicCellArray = [dynamicCellDict copy];
            */
            
            //////////
            ////////// ON DIT AU CONTROLLEUR MesAlertesViewController DE RELOADER SA TABLEVIEW
            //////////
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Please_Reload_MesAlertesViewController_TableView" object:nil];
            
        }
        @catch (NSException *exception) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte Partants" message:@"Exception lors d'action sur les alertes" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    });

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"---- Taille de la searchDatabase = %i ----",[self.searchDatabase count]);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    NSLog(@"[SearchViewController] 2/5 = didReceiveResponse | Données reçues [Connexion JSON asynchrone non terminée] : %d éléments",data.length);
        
    //////////
    ////////// STOCKAGE POUR LE MOTEUR DE RECHERCHE (pré-liste)
    //////////
    NSMutableArray *retourJson                                  = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] valueForKey:@"horse"];
    NSMutableArray *local_JSON_SearchResultsArrayForCheck       = [[NSMutableArray alloc] init];
    // ON ELIMINE LES FUTURS DOUBLONS DU JSON PAR UN PRE-CHECK
    if(retourJson != nil){
        NSEnumerator *retourJsonEnumerator = [retourJson objectEnumerator];
        id retourJsonObject;
        while (retourJsonObject = [retourJsonEnumerator nextObject]) {
            ///////
            /////// 1 SEUL OBJET RETOURNE
            ///////
            if([retourJsonObject isKindOfClass:[NSString class]]){
                if(![self.searchDatabase containsObject:retourJson]){
                    [local_JSON_SearchResultsArrayForCheck addObject:retourJson];
                    break;
                }
            }
            ///////
            /////// PLUSIEURS OBJETS RETOURNES
            ///////
            else{
                if(![self.searchDatabase containsObject:retourJsonObject]){
                    [local_JSON_SearchResultsArrayForCheck addObject:retourJsonObject];
                }
            }
        }
    }
    NSArray *local_JSON_SearchResultsArray                      = [local_JSON_SearchResultsArrayForCheck copy];
    NSMutableArray *new_SearchDatabaseArray                     = [[self.searchDatabase arrayByAddingObjectsFromArray:local_JSON_SearchResultsArray] mutableCopy];
    self.searchDatabase                                         = new_SearchDatabaseArray;
    
    NSLog(@"[SearchViewController] 3/5 = didReceiveData | La searchDatabase a bien été mise à jour | Taille = %i",[self.searchDatabase count]);
    
    //////////
    ////////// STOCKAGE/MISE A JOUR DANS LA MEMOIRE LOCALE
    //////////
    [local_user_memory removeObjectForKey:@"ZoneTurf_user_searchDatabase"];
    [local_user_memory setObject:self.searchDatabase forKey:@"ZoneTurf_user_searchDatabase"];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
    
    searchDisplayController.searchBar.text                  = @"";
    [local_user_memory removeObjectForKey:@"ZoneTurf_user_searchTerm"];
    
    /////////// RELOAD LA SEARCH-RESULTS-TABLEVIEW
    [self filterContentForSearchText:[searchDisplayController.searchBar text]
                               scope:[
                                      [searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[searchDisplayController.searchBar selectedScopeButtonIndex]
                                      ]
     ];
    [searchDisplayController.searchResultsTableView reloadData];
    searchDisplayController.searchResultsTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    NSLog(@"[SearchViewController] 3/5 = didFailWithError | ERREUR à la fin [Connexion JSON asynchrone terminée] : %@",error);

    [liveJsonErrorAlert show];
    
    [searchDisplayController setActive:NO animated:NO];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
    
    NSLog(@"[SearchViewController] 4/5 = connectionDidFinishLoading | Données reçues [Connexion JSON Asynchrone terminée]");
    
    /////////// RELOAD LA SEARCH-RESULTS-TABLEVIEW
    [self filterContentForSearchText:[searchDisplayController.searchBar text]
                               scope:[
                                      [searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[searchDisplayController.searchBar selectedScopeButtonIndex]
                                      ]
     ];
    [searchDisplayController.searchResultsTableView reloadData];
    searchDisplayController.searchResultsTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    NSLog(@"[SearchViewController] 5/5 = connectionDidFinishLoading | La tableView du searchDisplayController a été reloadée avec pour texte = %@",[searchDisplayController.searchBar text]);

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
            NSLog(@"Server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
            return nil; // don't cache this
        }
    }
    
    return cachedResponse;
    
}

@end
