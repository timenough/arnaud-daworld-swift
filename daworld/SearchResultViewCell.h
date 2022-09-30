
#import <UIKit/UIKit.h>

@interface SearchResultViewCell : UITableViewCell
{
    UILabel *lblCheval;
    UILabel *lblChevalInfosDispo;
    UIImageView *imgChevalView;
}

@property (strong, nonatomic) UILabel *lblCheval;
@property (strong, nonatomic) UILabel *lblChevalInfosDispo;
@property (strong, nonatomic) UIImageView *imgChevalView;

@end
