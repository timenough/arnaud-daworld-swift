
#import "FrontViewController.h"
#import "ArticleViewController.h"
#import "CategorySegmentedControl.h"

@class CategorySegmentedControl;

@interface ActualiteViewController : FrontViewController
    <UITableViewDataSource, UITableViewDelegate>
{

    CategorySegmentedControl *actualiteSegmentedControl;
    ArticleViewController *articleViewController;
    int actualiteFilter;
    NSString *actualiteTabNameSelected;
    
}

@property (strong, nonatomic) CategorySegmentedControl *actualiteSegmentedControl;
@property (strong, nonatomic) ArticleViewController *articleViewController;
@property (strong, nonatomic) NSString *actualiteTabNameSelected;
@property (nonatomic) int actualiteFilter;

- (void) actualiteFilter:(id)sender;

@end
