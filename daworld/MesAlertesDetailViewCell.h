
#import "MesAlertesViewController.h"
#import <UIKit/UIKit.h>

@interface MesAlertesDetailViewCell : UITableViewCell
{
    
    UILabel *lblTitle;
    UILabel *lblDescription;
    UISwitch *switchActiveButton;
    UIButton *deleteButton;
    NSString *actionUrlParams;
    NSString *alertIDUrlParams;
    NSString *pushAlertIDUrlParams;
    NSString *type;
    
    NSIndexPath *indexPathCell;
    MesAlertesViewController *mesAlertesViewController;
    
}

@property (strong, nonatomic) UILabel *lblTitle;
@property (strong, nonatomic) UILabel *lblDescription;
@property (strong, nonatomic) UISwitch *switchActiveButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) NSString *pushAlertIDUrlParams;
@property (strong, nonatomic) NSString *actionUrlParams;
@property (strong, nonatomic) NSString *alertIDUrlParams;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) MesAlertesViewController *mesAlertesViewController;
@property (strong, nonatomic) NSIndexPath *indexPathCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSString*)typeAlert;
- (void) switchActiveAlert:(id) sender;

@end
