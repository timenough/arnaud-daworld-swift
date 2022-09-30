
#import "FrontViewController.h"

@interface FicheChevalViewController : FrontViewController
    <UIWebViewDelegate>
{
    
    UIWebView* mWebView;
    NSString* htmlText;
    NSDictionary *horsesArray;
    UIButton *backButton;
    UIButton *right_rightbuttoninstance;
   
    int horseId;
    int pushAlertID;
}

@property (nonatomic,retain) NSString* htmlText;
@property (nonatomic, retain) IBOutlet UIWebView* mWebView;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *right_rightbuttoninstance;
@property (strong, nonatomic) NSDictionary *horsesArray;
@property (nonatomic) int horseId;
@property (nonatomic) int pushAlertID;

- (void) loadHTML;
- (void) switchActiveAlert:(id) sender;

@end
