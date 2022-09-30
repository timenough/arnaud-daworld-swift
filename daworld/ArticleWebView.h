
#import <UIKit/UIKit.h>

@interface ArticleWebView : UIWebView
{
    
    NSString* htmlText;
    NSDictionary *mItems;
    
}

@property (nonatomic,retain) NSString* htmlText;
@property (nonatomic,retain) NSDictionary *mItems;

- (void)loadHTML;

@end
