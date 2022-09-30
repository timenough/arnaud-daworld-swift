
#import <UIKit/UIKit.h>
#import "FrontViewController.h"
#import "ArticleWebView.h"

@interface APActivityProvider : UIActivityItemProvider
    <UIActivityItemSource>
{
    
    NSString *customMailMessage;
    NSString *customTwitterMessage;
    NSString *customFacebookMessage;
    NSString *customSMSMessage;

}

@property (strong, nonatomic) NSString* customMailMessage;
@property (strong, nonatomic) NSString* customTwitterMessage;
@property (strong, nonatomic) NSString* customFacebookMessage;
@property (strong, nonatomic) NSString* customSMSMessage;

@end

@interface ArticleViewController : FrontViewController
    <UIScrollViewDelegate, UIWebViewDelegate, UIGestureRecognizerDelegate>
{
    
    NSDictionary *mItems;
    NSMutableArray *mAllItems;
    UIScrollView *scrollView;
    NSMutableArray *webViewArray;
    UIBarButtonItem *nextButton;
    UIBarButtonItem *prevButton;
    UIActivityViewController *socialSheet;
    NSArray *itemsArrayToShare;
    NSArray *itemsArrayToExclude;
    APActivityProvider *messagesSelonLeTypeDePartage;
    int mItemIndex;
	int prevIndex;
	int currIndex;
	int nextIndex;
    
}

@property (nonatomic, retain) NSDictionary* mItems;
@property (nonatomic, retain) NSMutableArray *mAllItems;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableArray *webViewArray;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
@property (nonatomic, strong) UIBarButtonItem *prevButton;
@property (nonatomic, strong) UIActivityViewController *socialSheet;
@property (nonatomic, strong) NSArray *itemsArrayToShare;
@property (nonatomic, strong) NSArray *itemsArrayToExclude;
@property (nonatomic, strong) APActivityProvider *messagesSelonLeTypeDePartage;
@property (nonatomic) int mItemIndex;
@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

- (void)enableArrows:(int)currentPage;
- (IBAction)dismissView:(id) sender;
- (void)sharePage:(NSDictionary*)itms;

@end
