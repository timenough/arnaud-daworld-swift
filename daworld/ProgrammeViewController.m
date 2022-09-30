
#import "ProgrammeViewController.h"
#import "ProgrammeViewCell.h"
#import "RaceViewController.h"
#import "AppDelegate.h"
#include "DotInUIImageView.h"


@interface ProgrammeViewController ()

@end

@implementation ProgrammeViewController

@synthesize reunionDate,
    reunionSelected,
    isScrolling;

- (void)viewDidLoad
{
    
    self.pageTitle = @"Programme";
    self.pageType  = 1;
    self.reunionDate = (self.reunionDate != nil)? self.reunionDate : @"";
    currentControllerTableViewContentArray = nil;
    
    [super viewDidLoad];
    
    /* Gestion de la tableView courante */
    CGRect tableFrame                                       = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    currentControllerTableView                              = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    currentControllerTableView.scrollEnabled                = YES;
    currentControllerTableView.showsVerticalScrollIndicator = YES;
    currentControllerTableView.userInteractionEnabled       = YES;
    currentControllerTableView.separatorColor               = [UIColor clearColor];
    //currentControllerTableView.backgroundColor              = [UIColor DaWorldMainColor];
    // currentControllerTableView.sectionHeaderHeight = 0.0f;
    currentControllerTableView.delegate                     = self;
    currentControllerTableView.dataSource                   = self;
    currentControllerTableView.autoresizesSubviews          = YES;
    currentControllerTableView.sectionFooterHeight          = 0.0f;
    currentControllerTableView.autoresizingMask             = ( UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth );
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        currentControllerTableView.separatorInset       = UIEdgeInsetsZero;
    }
    [self.view addSubview:currentControllerTableView];
    
    // PRECHARGEMENT de la Bannière pub
    //_banner is an instance variable with default lifetime qualifier, which means it is __strong:
    //the banner will be retained by the controller until it is released.
    [self loadAdsBanner:self.currentControllerTableView isforView:nil withBackgroundColor:[UIColor blackColor] atPositionX:0 atPositionY:0];
    
    /* Appel du FLUX en mode Asynchrone (non bloquant) */
    self.liveJsonDataContainer              = [NSMutableData data];
    self.liveJsonNeedsUpdate                = 0;
    
    // Requete JSON ASYNCRHONE pour la TABLEVIEW
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
    
    currentControllerTableView.separatorColor               = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int raceTabSelected             = 0;
    
    NSMutableArray *elementsKeys    = [[[currentControllerTableViewContentArray objectAtIndex:indexPath.section] objectForKey:@"courses"] valueForKey:@"course"];
    
    id theArray                     = [elementsKeys objectAtIndex:indexPath.row];
    
    if([[theArray objectForKey:@"hasrapport"] isEqual:@"true"])
        raceTabSelected     = 2;
    
    
    RaceViewController *raceViewController  = [[RaceViewController alloc] init];
    raceViewController.raceInfoTabStatus    = [[NSArray alloc ] initWithObjects:@"true", [theArray objectForKey:@"hasprono"],[theArray objectForKey:@"hasrapport"], nil];
    raceViewController.raceId               = [[theArray objectForKey:@"id"] intValue];
    raceViewController.raceTabIndexSelected = raceTabSelected;
    raceViewController.raceContexte         = [theArray objectForKey:@"contexte"];
    raceViewController.pageTitle            = [theArray objectForKey:@"namecomplet"];
    raceViewController.raceArrivee          = [theArray objectForKey:@"finishresult"];
    raceViewController.pageType             = 2;
    
    [self.navigationController pushViewController:raceViewController animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    id theArray             = [currentControllerTableViewContentArray objectAtIndex:section];
    
    UIImageView *view       = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    view.backgroundColor    = [UIColor colorWithRed:23.0/255 green:21.0/255 blue:17.0/255 alpha:1];
    
    UILabel *label          = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, tableView.frame.size.width, 20)];
    label.textColor         = [UIColor whiteColor];
    label.text              = [NSString stringWithFormat:@"%@ - %@ - %@",[theArray objectForKey:@"number"], [theArray objectForKey:@"hippodrome"],[theArray objectForKey:@"timestart"]];
    
    label.font              = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    label.backgroundColor   = [UIColor clearColor];
    [view addSubview:label];
    return view;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSMutableArray *elementsKeys    = [[[currentControllerTableViewContentArray objectAtIndex:section] objectForKey:@"courses"] objectForKey:@"course"];
    
    return ([elementsKeys isKindOfClass:[NSDictionary class]])? 1 : [elementsKeys count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [currentControllerTableViewContentArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProgrammeViewCell *cell         = [tableView dequeueReusableCellWithIdentifier:@"programmeCourseCellIdentifier"];
    NSString *courseInfoDispo       = @"Partants";
    NSMutableArray *elementsKeys    = [[[currentControllerTableViewContentArray objectAtIndex:indexPath.section] objectForKey:@"courses"] objectForKey:@"course"];
    
    id theArray;
    int dotcol;
    
    if([elementsKeys isKindOfClass:[NSDictionary class]])
        theArray = elementsKeys;
    else
        theArray = [elementsKeys objectAtIndex:indexPath.row];
    
    if (cell == nil){
        cell = [[ProgrammeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"programmeCourseCellIdentifier"];
    }
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    cell.lblCourse.text             = [NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %@ partants - %@",[theArray objectForKey:@"number"], [theArray objectForKey:@"name"],[theArray objectForKey:@"allocation"],[theArray objectForKey:@"timestart"],[theArray objectForKey:@"nbpartants"],[theArray objectForKey:@"distance"]];
    
    if([[theArray objectForKey:@"quinte"] isEqual:@"1"]){
        cell.imgQuinteView.image    = [UIImage imageNamed:@"logo_quinte.png"];
    }else{
        cell.imgQuinteView.image    = nil;
    }
    
    if([[theArray objectForKey:@"hasprono"] isEqual:@"true"])
        courseInfoDispo = [courseInfoDispo stringByAppendingFormat:@" / Pronostics"];
    
    if([[theArray objectForKey:@"hasrapport"] isEqual:@"true"])
        courseInfoDispo = [courseInfoDispo stringByAppendingFormat:@" / Rapports"];
    
    cell.lblCourseInfosDispo.text   = courseInfoDispo;
    
                if([[theArray objectForKey:@"status"] isEqualToString:@"icon_reunion_green.png"]){
                    dotcol = 1;
                }
                else if([[theArray objectForKey:@"status"] isEqualToString:@"icon_reunion_red.png"]){
                    dotcol = 2;
                }
                else{
                    dotcol = 0;
                }
                [DotInUIImageView colorizeDot:cell.imgCourseView dotOpacity:1.0 dotSize:7.4f dotColor:dotcol strokeSize:.6f];
                //cell.imgCourseView.image        = [UIImage imageNamed:[theArray objectForKey:@"status"]];
    
    // AU CLICK DE LA CELL
    UIView *selectionColor              = [[UIView alloc] init];
    selectionColor.backgroundColor      = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1];
    cell.selectedBackgroundView         = selectionColor;
    cell.selectionStyle                 = UITableViewCellSelectionStyleDefault;
    
    // OUTPUT
    return cell;
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSLog(@"[ProgrammeViewController] 4/5 = connectionDidFinishLoading | Données reçues > Connexion JSON Asynchrone terminée : %d éléments",self.liveJsonDataContainer.length);
    self.view.userInteractionEnabled                = YES;
    self.currentControllerTableViewContentArray     = [[NSMutableArray alloc] initWithCapacity:20];
    self.liveJsonNeedsUpdate                        = 1;
    
    [self updateTableViewAfterJson:@"ProgrammeViewController" withNode:@"reunion"];
    
    if(self.isScrolling){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:reunionSelected-1];
        [currentControllerTableView scrollToRowAtIndexPath:indexPath
                                       atScrollPosition:UITableViewScrollPositionTop
                                               animated:YES];
        self.isScrolling = NO;
    }
    
    [activityIndicator stopAnimating];
    [activityIndicatorContainer removeFromSuperview];
    
    [self stopTableViewRefresh];
    
}

-(void)triggerJson
{
    
    NSString *local_uri_json = [NSString stringWithFormat:@"http://www.daworld.co/json_reunions.php?d=%@",(self.reunionDate)];
    [self sendJsonRequest_ASync:local_uri_json];
    
}

@end
