
#import <UIKit/UIKit.h>
#import "FrontViewController.h"

@interface MenuViewController : FrontViewController
    <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, UISearchBarDelegate>
{
    
    NSMutableArray *menuElementsArray;
    NSMutableArray *menuElementsArrayPersistant;
    NSArray *menuSectionTableViewArray;
    NSMutableArray *menuSectionStatus;
    NSArray *menuSectionArray;
    UIView *overlay;
    NSMutableData *requestData;
    int cellSubSection;
    int json_need_update;
    IBOutlet UITableView *menuTableView;
    
    NSError *json_error;
    NSTimer *timer;
    
    IBOutlet UISearchBar *searchBar2;
    
}

@property (strong, nonatomic) NSMutableArray *menuElementsArray;
@property (strong, nonatomic) NSMutableArray *menuElementsArrayPersistant;
@property (strong, nonatomic) NSArray *menuSectionTableViewArray;
@property (strong, nonatomic) NSMutableArray *menuSectionStatus;
@property (strong, nonatomic) NSArray *menuSectionArray;
@property (strong, nonatomic) UIView *overlay;
@property (strong, nonatomic) NSMutableData *requestData;
@property (nonatomic) int cellSubSection;
@property (nonatomic) int json_need_update;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSError *json_error;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar2;

- (void)changeMenuElementsArray;
- (void)sendJsonRAsync;
- (void)sendLoadAfterJson;

@end
