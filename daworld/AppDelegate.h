
#import <UIKit/UIKit.h>
#import "configuration.h"
#import "MKNetworkEngine.h"

@class PKRevealController;

@interface AppDelegate : UIResponder
    <UIApplicationDelegate>
{
    
    MKNetworkEngine* imageCacheEngine;
    NSDictionary* appConfigDict;
    UIWindow *window;
    
}

@property (nonatomic, strong, readwrite) PKRevealController *revealController;
@property (nonatomic, strong) MKNetworkEngine *imageCacheEngine;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary* appConfigDict;
@property (copy,readwrite) NSMutableArray *searchDatabaseHiddenShared;

@end

@implementation UIColor (Extensions)

+ (UIColor *)DaWorldMainColor {
    return [UIColor colorWithRed:210.0f/255 green:55.0f/255 blue:68.0f/255.0f alpha:1.0f];
}

@end
