
#import "FrontViewController.h"
#import "PKRevealController.h"
#import "MenuViewController.h"
#import "SearchViewController.h"
#import "FicheChevalViewController.h"

@implementation FrontViewController

@synthesize get_the_delegate,
    bannerView,
    activityIndicatorContainer,
    activityIndicator,
    currentControllerTableView,
    currentControllerTableViewContentArray,
    currentControllerTopBar,
    currentControllerTopBarTitle,
    refreshTableView,
    refreshTableViewText,
    refreshTableViewAnim,
    liveTimer,
    liveJsonDataContainer,
    liveJsonError,
    liveJsonErrorAlert,
    liveJsonNeedsUpdate,
    pageTitle,
    conn,
    pageType,
    searchViewController,
    local_user_memory;

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    //////
    ////// ON DEFINI LE DELEGATE (Objet partagé) POUR LES CHILDS
    //////
    get_the_delegate                                    = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //////
    ////// ON EXECUTE LE viewDidLoad du parent
    //////
    [super viewDidLoad];
    
    //////
    ////// ON PERSONALISE
    //////
    self.view.backgroundColor = [UIColor clearColor];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.barTintColor = [UIColor DaWorldMainColor];
        currentControllerTableView.separatorInset       = UIEdgeInsetsZero;
    }
    else{
        if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar_old_ios.png"] forBarMetrics:UIBarMetricsDefault];
        }
        else {
            NSString *barBgPath = [[NSBundle mainBundle] pathForResource:@"navigationBar_old_ios.png" ofType:@"png"];
            [self.navigationController.navigationBar.layer setContents:(id)[UIImage imageWithContentsOfFile: barBgPath].CGImage];
            self.navigationController.navigationBar.alpha = 1.0;
        }
        self.navigationController.navigationBar.tintColor = [UIColor DaWorldMainColor];
    }
    
    if(self.pageType == 1){
        
        //////
        ////// ON DEFINI LE TITRE AFFICHE AU CENTRE
        //////
        //self.navigationController.navigationBar.topItem.titleView.alpha = 0.8f;
        self.navigationController.navigationBar.topItem.title = self.pageTitle;
        
        //////
        ////// ON DEFINI LE STYLE DU TITRE
        //////
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIColor whiteColor],
                                                                    UITextAttributeTextColor,
                                                                    [UIFont fontWithName:@"ArialBlack" size:16.0],
                                                                    UITextAttributeFont,
                                                                    nil
                                                              ]
        ];
        
        //////
        ////// ON INITIALISE LES IMAGES DES BOUTONS
        //////
        UIImage *revealMenuImagePortrait = [UIImage imageNamed:@"button_menu_icon.png"];
        UIImage *revealMenuImageLandscape = [UIImage imageNamed:@"button_menu_icon@2x.png"];
        UIImage *revealZoomImagePortrait = [UIImage imageNamed:@"button_zoom_icon.png"];
        UIImage *revealZoomImageLandscape = [UIImage imageNamed:@"button_zoom_icon@2x.png"];
        
        //////
        ////// ON INITIALISE LE BOUTON GAUCHE
        //////
        if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealMenuImagePortrait landscapeImagePhone:revealMenuImageLandscape style:UIBarButtonItemStylePlain target:self action:@selector(showMenuView:)];
        }
        
        //////
        ////// ON INITIALISE LE BOUTON DROIT
        //////
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealZoomImagePortrait landscapeImagePhone:revealZoomImageLandscape style:UIBarButtonItemStylePlain target:self action:@selector(showSearchView:)];
       
        
        //////
        ////// ON PERSONALISE LE BOUTON GAUCHE
        //////
        if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
        {
            UIButton *leftbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftbuttoninstance setBackgroundImage:revealMenuImageLandscape forState:UIControlStateNormal];
            [leftbuttoninstance addTarget:self action:@selector(showMenuView:) forControlEvents:UIControlEventTouchUpInside];
            leftbuttoninstance.frame = CGRectMake(5.0, 0.0, 24.0, 24.0);
            
            UIBarButtonItem *MyleftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftbuttoninstance];
            self.navigationItem.leftBarButtonItem = MyleftBarButtonItem;
        }
        
        //////
        ////// ON PERSONALISE LE BOUTON DROIT
        //////
        UIButton *rightbuttoninstance = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightbuttoninstance setBackgroundImage:revealZoomImageLandscape forState:UIControlStateNormal];
        [rightbuttoninstance addTarget:self action:@selector(showSearchView:) forControlEvents:UIControlEventTouchUpInside];
        rightbuttoninstance.frame = CGRectMake(5.0, 0.0, 24.0, 24.0);
        rightbuttoninstance.tag     = 997;
        UIBarButtonItem *MyrightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbuttoninstance];
        self.navigationItem.rightBarButtonItem = MyrightBarButtonItem;
        
    }
    
    //////
    ////// Si Erreur Réseau (alerte) :
    //////
    liveJsonErrorAlert = [[UIAlertView alloc]
             initWithTitle:@"Alerte réseau" message:@"Vous devez avoir accès à internet pour utiliser l'application ZoneTurf" delegate:nil
             cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    //////
    ////// Le RefreshControl (titre + indicator + initialisation) :
    //////
    refreshTableView                                    = [[UIRefreshControl alloc] init];
    [[UIRefreshControl appearance] setTintColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.0f]];
    refreshTableViewAnim                                = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                                           UIActivityIndicatorViewStyleGray];
    CGRect rect;
    rect                                                = refreshTableView.bounds;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        refreshTableViewAnim.center                         = CGPointMake(30,refreshTableView.bounds.size.height/2.0);
        rect.origin.x                                       = 46;
    }
    else{
        refreshTableViewAnim.center                         = CGPointMake(30,23);
        rect.origin.x                                       = 46;
        rect.origin.y                                       = -7;
        
    }
    [refreshTableView addSubview:refreshTableViewAnim];
    refreshTableViewText                                = [[UILabel alloc] initWithFrame:rect];
    refreshTableViewText.font                           = [UIFont fontWithName:@"Helvetica" size:12.0f];
    refreshTableViewText.font                           = [UIFont boldSystemFontOfSize:12.0f];
    refreshTableViewText.backgroundColor                = [UIColor clearColor];
    refreshTableViewText.text                           = @"Mise à jour";
    [refreshTableView addSubview:refreshTableViewText];
    [refreshTableViewAnim startAnimating];
    
}

#pragma mark - Actions

- (void)showSearchView:(id)sender
{
    
    CGRect searchViewContainer;
    searchViewController                                = [[SearchViewController alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        searchViewContainer = searchViewController.view.frame;
        searchViewContainer.size.height -=20;
        searchViewController.view.frame                 = searchViewContainer;
    }
    
    ///////////
    /////////// Déclenchement depuis la SearchBar du MenuViewController
    ///////////
    if([sender isKindOfClass:[MenuViewController class]]){
        [self.parentViewController.view addSubview:searchViewController.view];
        [self.parentViewController.view bringSubviewToFront:searchViewController.view];
    }
    ///////////
    /////////// Déclenchement depuis un bouton
    ///////////
    else if([sender isKindOfClass:[UIBarButtonItem class]] || [sender isKindOfClass:[UIButton class]]){
        UIButton *readButtonTag             = (UIButton *)sender;
        [searchViewController.view setTag:readButtonTag.tag];
        [self.parentViewController.view addSubview:searchViewController.view];
        [self.parentViewController.view bringSubviewToFront:searchViewController.view];
        /////////
        ///////// Retour Fiche Cheval
        /////////
        if(readButtonTag.tag == 997){
            [self performSelector:@selector(dismissView:) withObject:self afterDelay:0.9];
        }
        /////////
        ///////// Bouton Plus des Alertes
        /////////
        else{
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
    }
    ///////////
    /////////// Déclenchement depuis la Loupe
    ///////////
    else{
        [self.parentViewController.parentViewController.view addSubview:searchViewController.view];
        [self.parentViewController.parentViewController.view bringSubviewToFront:searchViewController.view];
        
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    
}

- (void)showMenuView:(id)sender
{
    
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
    
}

#pragma mark - JSON Actions

-(void)triggerJson
{
    
}

-(void)sendJsonRequest_Sync:(NSString *)JsonURI isForTableView:(UITableView *)targetTableView param1:(NSString *)paramString
{
    
    NSError *local_error                = self.liveJsonError;
    self.liveJsonDataContainer          = [NSMutableData data];
    NSString *urlString                 = JsonURI;
    NSMutableURLRequest * urlRequest    = [
                                           NSMutableURLRequest
                                           requestWithURL:[
                                                           NSURL URLWithString:urlString]
                                           ];
    //urlRequest.timeoutInterval        = 20.0;
    NSURLResponse * response            = nil;
    NSData * donnees_synchrones         = [NSURLConnection sendSynchronousRequest:urlRequest
                                                                returningResponse:&response
                                                                            error:&local_error];
    
    [self.liveJsonDataContainer appendData:donnees_synchrones];
    NSLog(@"[FrontViewController] 1/2 = sendJsonRequest_Sync | Flux jSON en Synchrone : taille du tableau JSON = %d éléments.",donnees_synchrones.length);
    
    //////////////////////////////////
    ///////// CAS SIMPLE PAR DEFAUT
    //////////////////////////////////
    if(targetTableView==currentControllerTableView){
        [self updateTableViewAfterJson:nil withNode:nil];
    }
    /////////////////////////////////////////////
    ///////// CAS DU MOTEUR DE RECHERCHE : RESULTATS
    /////////////////////////////////////////////
    else if(targetTableView==self.searchDisplayController.searchResultsTableView){
    }
    ///////////////////////
    ///////// CAS Tiers
    ///////////////////////
    else{
    }
    
}

- (void)sendJsonRequest_ASync:(NSString *)JsonURI
{
    
    if(conn!=nil)
        [conn cancel];
    
    [self displayLoadingActivityPopup:nil isforView:nil];
    
    NSMutableURLRequest *urlRequest     = [
                                           NSURLRequest
                                           requestWithURL:[
                                                           NSURL URLWithString:JsonURI]
                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                           timeoutInterval:20.0
                                           ];
    
    conn                                = [
                                           [NSURLConnection alloc]
                                           initWithRequest:urlRequest
                                           delegate:self
                                           ];
    
    if (conn) {
        NSLog(@"[FrontViewController] 1/5 = sendJsonRequest_ASync | Connexion au flux jSON en Asynchrone réussie...");
    }
    else {
        NSLog(@"[FrontViewController] 1/5 = sendJsonRequest_ASync | ERREUR : impossible de se connecter pour récuper le flux jSON en Asynchrone.");
    }
    
    // et là Hop on pass aux méthode de gestion du NSURLConnection disponibles
    // - didReceiveResponse
    // - didReceiveData
    // - didFailWithError
    // - connectionDidFinishLoading
}

- (void)updateTableViewAfterJson:(NSString *)PossibleAdsPlace withNode:(NSString *)nodeJson
{
    
    [self updateContentArrayAfterJson:nodeJson];
    
    // RELOAD de la Table View du contrôlleur
    [currentControllerTableView reloadData];
    
    // AFFICHAGE de la Bannière pub
    [self displayAdsBanner:PossibleAdsPlace];
    
}

- (void)updateContentArrayAfterJson:(NSString *)nodeJson
{
    
    NSError *local_error                = self.liveJsonError;
    NSMutableArray *local_JSONElementsKeys;
    NSMutableArray *local_JSONElementsArray;
    
    if (local_error == nil)
    {
        // Parse data here
        NSData *local_JSONData          = self.liveJsonDataContainer;
        NSLog(@"[FrontViewController] 5/5 = updateContentArrayAfterJson | Total to Treat : %d elements.",local_JSONData.length);
        
        // If not nil
        if(local_JSONData!=nil){
            id local_JSONObjects        = [NSJSONSerialization JSONObjectWithData:local_JSONData options:NSJSONReadingMutableContainers error:&local_error];
            
            if(self.liveJsonNeedsUpdate == 1){
                [self.currentControllerTableViewContentArray removeAllObjects];
            }
            
            // On rempli le tableau local avec toutes les datas du JSON
            local_JSONElementsKeys      = [local_JSONObjects objectForKey:nodeJson];
           
            local_JSONElementsArray     = [[NSMutableArray alloc] initWithCapacity:[local_JSONElementsKeys count]];
            for (NSDictionary *item in local_JSONElementsKeys){
                [local_JSONElementsArray addObject:item];
                
            }
            
            self.currentControllerTableViewContentArray = local_JSONElementsKeys;
            
            local_JSONElementsArray     = nil;
            local_JSONElementsKeys      = nil;
        }
    }
}

- (void)displayLoadingActivityPopup:(UITableView *)targetTableView isforView:(UIView *)theView{
    if(activityIndicatorContainer == nil){
        self.activityIndicatorContainer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.activityIndicatorContainer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = self.activityIndicatorContainer.center;
        [self.activityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    
        [self.activityIndicatorContainer addSubview:self.activityIndicator];
    }
    
    [activityIndicator startAnimating];
    
    if(theView!=nil){
        [theView addSubview:self.activityIndicatorContainer];
    }
    else{
        if(targetTableView!=nil){
            [targetTableView addSubview:self.activityIndicatorContainer];
        }
        else{
            [currentControllerTableView addSubview:self.activityIndicatorContainer];
        }
    }
    
}

-(void)loadAdsBanner:(UITableView *)targetTableView isforView:(UIView *)theView withBackgroundColor:(UIColor *)BgColor atPositionX:(float)x atPositionY:(float)y
{
    
}

-(void)displayAdsBanner:(NSString *)AdsPlace
{
    
}

-(void) dismissView:(id) sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)stopTableViewRefresh
{
    
    [self.refreshTableView endRefreshing];
    
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
    
    if((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        // LANDSCAPE
        currentControllerTopBarTitle.frame = CGRectMake(0, 2, self.navigationController.navigationBar.frame.size.width, 30);
    }
    else
    {
        // PORTRAIT
        currentControllerTopBarTitle.frame = CGRectMake(28, 7, self.navigationController.navigationBar.frame.size.width-56, 30);
    }
    return YES;
    
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
    NSLog(@"[FrontViewController] 2/5 = didReceiveResponse | Réponse reçue [Connexion JSON asynchrone non terminée]");
    
    [self.liveJsonDataContainer setLength:0];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [self.liveJsonDataContainer appendData:data];
    
    NSLog(@"[FrontViewController] 3/5 = didReceiveData | Données reçues [Connexion JSON asynchrone non terminée] : %d éléments",self.liveJsonDataContainer.length);

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
    
    [self stopTableViewRefresh];
    
    NSLog(@"[FrontViewController] 3/5 = didFailWithError | ERREUR à la fin [Connexion JSON asynchrone terminée] : %d éléments %@",self.liveJsonDataContainer.length, error);
    
    [liveJsonErrorAlert show];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"[FrontViewController] 4/5 = connectionDidFinishLoading | Données reçues.");

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
            NSLog(@"server does not provide expiration information and we are using NSURLRequestUseProtocolCachePolicy");
            return nil; // don't cache this
        }
    }
    return cachedResponse;
    
}

@end
