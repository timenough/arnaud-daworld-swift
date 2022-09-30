
#import "FrontViewController.h"
#import "FicheChevalViewController.h"
#import "RaceViewController.h"
#import "MenuSelect.h"

@interface MesAlertesViewController : FrontViewController
    <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldAffectTableViewDelegate>
{
    
    UIView *headerView;
    MenuSelect *menuSelect;
    UIButton *addButton;
    
    NSMutableArray* feed_type_Array;
    int feed_type_selected;
    NSString *alertType;
    NSArray *alertViewBoxArray;
    
    FicheChevalViewController *ficheChevalViewController;
    RaceViewController *raceViewController;
    
}

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) MenuSelect *menuSelect;
@property (nonatomic, retain) UIButton *addButton;

@property (nonatomic, retain) NSMutableArray *feed_type_Array;
@property (nonatomic) int feed_type_selected;
@property (nonatomic, retain) NSString *alertType;
@property (nonatomic, retain) NSArray *alertViewBoxArray;

@property (nonatomic, retain) FicheChevalViewController *ficheChevalViewController;
@property (nonatomic, retain) RaceViewController *raceViewController;

- (void)consequenceOnTableView:(int)selectedValue;
- (void)triggerJson_for_Notifications;
- (void)triggerJson_for_Alertes:(NSString *)alert_Type;
- (void)triggerJson_for_Alertes_Partants_only;

@end
