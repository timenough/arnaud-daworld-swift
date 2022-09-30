
#import "FrontViewController.h"
#import "CategorySegmentedControl.h"

@class CategorySegmentedControl;

@interface RaceViewController : FrontViewController
    <UIWebViewDelegate>
{
    
    CategorySegmentedControl *raceSegmentedControl;
    UIWebView* mWebView;
    NSString* htmlText;
    NSArray *raceInfoTabStatus;
    NSDictionary *racePartantsArray;
    NSMutableArray *raceRapportsArray;
    NSMutableArray *racePronosArray;
    UIButton *right_rightbuttoninstance;
    NSString *raceContexte;
    NSString *raceArrivee;
    UIButton * backButton;
    NSString *raceTabNameSelected;
    int raceTabIndexSelected;
    int raceInfoTab;
    int raceId;
    int pushAlertID;
    
}

@property (nonatomic,retain) NSString* htmlText;
@property (nonatomic, retain) IBOutlet UIWebView* mWebView;
@property (strong, nonatomic) CategorySegmentedControl *raceSegmentedControl;
@property (strong, nonatomic) NSArray *raceInfoTabStatus;
@property (strong, nonatomic) NSDictionary *racePartantsArray;
@property (strong, nonatomic) NSMutableArray *raceRapportsArray;
@property (strong, nonatomic) NSMutableArray *racePronosArray;
@property (strong, nonatomic) UIButton *right_rightbuttoninstance;
@property (strong, nonatomic) NSString *raceContexte;
@property (strong, nonatomic) NSString *raceArrivee;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NSString *raceTabNameSelected;
@property (nonatomic) int raceTabIndexSelected;
@property (nonatomic) int raceInfoTab;
@property (nonatomic) int raceId;
@property (nonatomic) int pushAlertID;

- (void) switchActiveAlert:(id) sender;
- (IBAction) dismissView:(id) sender;
- (void)loadHTML:(NSString *)templateHTML;
- (void)changeTab:(id)sender;

@end
