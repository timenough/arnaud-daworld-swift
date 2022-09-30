
#import "ArticleWebView.h"
#import "NSString+HTML.h"

@implementation ArticleWebView

@synthesize htmlText,
    mItems;

- (id)initWithFrame:(CGRect)frame
{
    
    self                        = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
    }
    return self;
    
}

-(void)loadHTML
{
    
    NSError *error;
    
	self.htmlText=[NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ArticleTemplate.html"] encoding:NSUTF8StringEncoding error:&error];
    
	self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_TITLE_" withString:[mItems objectForKey:@"title"]];
    self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_DATE_" withString:[mItems objectForKey:@"date"]];
    self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_CHAPO_" withString:[[mItems objectForKey:@"chapo"] stringByDecodingHTMLEntities]];
    self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_CONTENT_" withString:[[mItems objectForKey:@"content"] stringByDecodingHTMLEntities]];
    
    if(![[mItems objectForKey:@"picture"] isEqualToString:@""]){
        
        /*NSString *pictureBloc = @"<div class=\"picture\"><img src=\"_PICTURE_\" /><span>_LEGEND_ (_COPYRIGHT_)</span></div>";
         
         pictureBloc = [pictureBloc stringByReplacingOccurrencesOfString:@"_PICTURE_" withString:[mItems objectForKey:@"picture"]];
         pictureBloc = [pictureBloc stringByReplacingOccurrencesOfString:@"_COPYRIGHT_" withString:[mItems objectForKey:@"copyright"]];
         pictureBloc = [pictureBloc stringByReplacingOccurrencesOfString:@"_LEGEND_" withString:[mItems objectForKey:@"legend"]];*/
        
        NSString *pictureBloc = @"<div class=\"picture\"></div>";
        
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_PICTURE_BLOC_" withString:pictureBloc];
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_PICTURE_" withString:[mItems objectForKey:@"picture"]];
    }else{
        self.htmlText = [self.htmlText stringByReplacingOccurrencesOfString:@"_PICTURE_" withString:@""];
    }
    
	NSString *path =[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@""];
	NSURL* contentBaseURL=[NSURL fileURLWithPath:path ];
    [self loadHTMLString:self.htmlText baseURL:contentBaseURL];
    
}

@end
