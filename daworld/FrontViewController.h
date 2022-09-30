
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FrontViewController : UIViewController
    <NSURLConnectionDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
{
    
    AppDelegate* get_the_delegate;
    UIView *bannerView;
    
    UIView *activityIndicatorContainer;
    UIActivityIndicatorView *activityIndicator;
    
    UITableView *currentControllerTableView;
    NSMutableArray *currentControllerTableViewContentArray;
    UIView *currentControllerTopBar;
    UILabel *currentControllerTopBarTitle;
    UIRefreshControl *refreshTableView;
    UILabel *refreshTableViewText;
    UIActivityIndicatorView *refreshTableViewAnim;
    
    NSURLConnection *conn;
    NSTimer *liveTimer;
    NSMutableData *liveJsonDataContainer;
    NSError *liveJsonError;
    UIAlertView *liveJsonErrorAlert;
    int liveJsonNeedsUpdate;
    
    NSString *pageTitle;
    int pageType;

    UIViewController *searchViewController;
    
    NSUserDefaults *local_user_memory;
    
}

@property (strong, nonatomic) AppDelegate* get_the_delegate;
@property (strong, nonatomic) UIView *bannerView;

@property (strong, nonatomic) UIView *activityIndicatorContainer;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UITableView *currentControllerTableView;
@property (strong, nonatomic) NSMutableArray *currentControllerTableViewContentArray;
@property (strong, nonatomic) UIView *currentControllerTopBar;
@property (strong, nonatomic) UILabel *currentControllerTopBarTitle;
@property (strong, nonatomic) UIRefreshControl *refreshTableView;
@property (strong, nonatomic) UILabel *refreshTableViewText;
@property (strong, nonatomic) UIActivityIndicatorView *refreshTableViewAnim;

@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSTimer *liveTimer;
@property (strong, nonatomic) NSMutableData *liveJsonDataContainer;
@property (strong, nonatomic) NSError *liveJsonError;
@property (strong, nonatomic) UIAlertView *liveJsonErrorAlert;
@property (nonatomic) int liveJsonNeedsUpdate;

@property (strong, nonatomic) NSString *pageTitle;
@property (nonatomic) int pageType;

@property (strong,nonatomic) UIViewController *searchViewController;

@property (strong,nonatomic) NSUserDefaults *local_user_memory;

- (void)sendJsonRequest_ASync:(NSString *)JsonURI;
- (void)sendJsonRequest_Sync:(NSString *)JsonURI isForTableView:(UITableView *)targetTableView param1:(NSString *)searchString;
- (void)updateTableViewAfterJson:(NSString *)PossibleAdsPlace withNode:(NSString *)nodeJson;
- (void)updateContentArrayAfterJson:(NSString *)nodeJson;
- (void)displayLoadingActivityPopup:(UITableView *)targetTableView isforView:(UIView *)theView;
- (void)loadAdsBanner:(UITableView *)targetTableView isforView:(UIView *)theview withBackgroundColor:(UIColor *)BgColor atPositionX:(float)x atPositionY:(float)y;
- (void)displayAdsBanner:(NSString *)thePlace;
- (void)showMenuView:(id)sender;
- (void)showSearchView:(id)sender;
- (void)dismissView:(id)sender;
- (void)stopTableViewRefresh;
- (void)triggerJson;

@end
