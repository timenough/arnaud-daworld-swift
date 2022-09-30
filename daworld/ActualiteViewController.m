
#import "ActualiteViewController.h"
#import "ArticleViewController.h"
#import "ActualiteViewCell.h"
#import "AppDelegate.h"
#import "CategorySegmentedControl.h"
#import "UIImageView+MKNetworkKitAdditions.h"


@interface ActualiteViewController ()

@end

@implementation ActualiteViewController

@synthesize actualiteSegmentedControl,
    actualiteFilter,
    actualiteTabNameSelected,
    articleViewController;


- (void)viewDidLoad
{
    
    self.pageTitle = @"Actualités";
    self.pageType  = 1;
    
    [super viewDidLoad];
    
    float startPositionY    = 0;
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(sysVer >= 7.0f)
        startPositionY = 63.0f;
    
    /* Gestion du segmentedcontrol */
     actualiteSegmentedControl = [[CategorySegmentedControl alloc] initWithFrame:CGRectMake(0, startPositionY, self.view.frame.size.width, 30.0f)];
    [actualiteSegmentedControl insertSegmentWithTitle:@"A la une" atIndex:0 animated:TRUE];
    [actualiteSegmentedControl insertSegmentWithTitle:@"Quinte" atIndex:1 animated:TRUE];
    [actualiteSegmentedControl insertSegmentWithTitle:@"Top chances" atIndex:2 animated:TRUE];
    actualiteSegmentedControl.selectedSegmentIndex = actualiteFilter;
    //actualiteSegmentedControl.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    [actualiteSegmentedControl addTarget:self action:@selector(actualiteFilter:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:actualiteSegmentedControl];
    actualiteSegmentedControl.selectedSegmentIndex = self.actualiteFilter;
    self.actualiteTabNameSelected = [actualiteSegmentedControl titleForSegmentAtIndex:actualiteFilter];
    
    /* Ligne Graphique */
    UIView *lineView   = [[UIView alloc] initWithFrame:CGRectMake(0, 30.0f+startPositionY, self.view.frame.size.width, 3.0f)];
    lineView.backgroundColor = [UIColor colorWithRed:23.0/255 green:21.0/255 blue:17.0/255 alpha:1];
    [self.view addSubview:lineView];
    
    /* Gestion de la tableView courante */
    CGRect tableFrame   = CGRectMake(0, 33.0f+startPositionY, self.view.frame.size.width, self.view.frame.size.height-33.0f-startPositionY);
    currentControllerTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    currentControllerTableView.scrollEnabled = YES;
    currentControllerTableView.showsVerticalScrollIndicator = YES;
    currentControllerTableView.userInteractionEnabled = YES;
    currentControllerTableView.separatorColor = [UIColor clearColor];
    currentControllerTableView.delegate = self;
    currentControllerTableView.dataSource = self;
    currentControllerTableView.autoresizesSubviews = YES;
    currentControllerTableView.sectionFooterHeight = 0.0f;
    currentControllerTableView.autoresizingMask = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    // programmeTableView.sectionHeaderHeight = 0.0f;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        currentControllerTableView.separatorInset       = UIEdgeInsetsZero;
    }
    [self.view addSubview:currentControllerTableView];
    
    // PRECHARGEMENT de la Bannière pub
    //_banner is an instance variable with default lifetime qualifier, which means it is __strong:
    //the banner will be retained by the controller until it is released.
    [self loadAdsBanner:self.currentControllerTableView isforView:nil withBackgroundColor:[UIColor blackColor] atPositionX:0 atPositionY:startPositionY];
    
        /* Appel du FLUX en mode synchrone (bloquant tant que toutes les données n'ont pas été chargé) */
        //self.liveJsonDataContainer    = [NSMutableData data];
        //[self sendJsonRSync];
    
    /* Appel du FLUX en mode Asynchrone (non bloquant) */
    self.liveJsonDataContainer      = [NSMutableData data];
    self.liveJsonNeedsUpdate        = 0;
    
    // Affichage du overlay d'attente
    
    // Requete JSON
    [self triggerJson];
    
    // Scroll to Refresh de la TableView (CUSTOM)
    [refreshTableView setBackgroundColor:[UIColor whiteColor]];
    refreshTableViewAnim.color                          = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
    refreshTableViewText.textColor                      = [UIColor colorWithRed:31.0/255 green:28.0/255 blue:24.0/255 alpha:1];
    [refreshTableView addTarget:self action:@selector(triggerJson) forControlEvents:UIControlEventValueChanged];
    [currentControllerTableView addSubview:refreshTableView];
    [currentControllerTableView sendSubviewToBack:refreshTableView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    currentControllerTableView.separatorColor           = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    articleViewController = [[ArticleViewController alloc] init];
    articleViewController.mItemIndex = indexPath.row;
    articleViewController.pageTitle  = self.actualiteTabNameSelected;
    articleViewController.mItems = [currentControllerTableViewContentArray objectAtIndex:indexPath.row];
    articleViewController.mAllItems = currentControllerTableViewContentArray;
    [self.navigationController pushViewController:articleViewController animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.currentControllerTableViewContentArray count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ActualiteViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:@"ActualiteCellIdentifier"];
    NSDictionary *myArray = [self.currentControllerTableViewContentArray objectAtIndex:indexPath.row];
    if (cell == nil){
        cell = [[ActualiteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActualiteCellIdentifier"];
        
    }

    cell.lblTitle.text        = [myArray objectForKey:@"title"];
    cell.lblDescription.text  = [myArray objectForKey:@"summary"];
    NSString *urlImage        = [myArray objectForKey:@"thumbnail"];
    
    AppDelegate *appDelegate  = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [UIImageView setDefaultEngine:appDelegate.imageCacheEngine];
    [cell.imgPictureView setImageFromURL:[NSURL URLWithString:urlImage] placeHolderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    // AU CLICK DE LA CELL
    UIView *selectionColor              = [[UIView alloc] init];
    selectionColor.backgroundColor      = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    cell.selectedBackgroundView         = selectionColor;
    cell.selectionStyle                 = UITableViewCellSelectionStyleDefault;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80.0f;
    
}

#pragma mark - Actions

-(void) actualiteFilter:(id)sender
{
    
    actualiteSegmentedControl           = (CategorySegmentedControl *)sender;
    self.actualiteFilter                = actualiteSegmentedControl.selectedSegmentIndex;
    
    // On lance la Requete Json Asynchrone
    NSString *local_uri_json            = [NSString stringWithFormat:@"http://www.daworld.co/json_newslist.php?t=%d",self.actualiteFilter];
    [self sendJsonRequest_ASync:local_uri_json];
    
    self.actualiteTabNameSelected = [actualiteSegmentedControl titleForSegmentAtIndex:self.actualiteFilter];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"2/2 | Données reçues [Connexion JSON Asynchrone terminée] : %d éléments",self.liveJsonDataContainer.length);
    
    self.view.userInteractionEnabled = YES;
    
    self.currentControllerTableViewContentArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.liveJsonNeedsUpdate = 1;
    
    [self updateTableViewAfterJson:@"ActualiteViewController" withNode:@"news"];
    
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
    
    [self stopTableViewRefresh];
    
}

-(void)triggerJson
{
    
    NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_newslist.php?t=%d",self.actualiteFilter];
    [self sendJsonRequest_ASync:local_uri_json];
    
}

@end
