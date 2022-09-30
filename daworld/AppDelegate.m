
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PKRevealController.h"
#import "ProgrammeViewController.h"
#import "FrontViewController.h"
#import "MenuViewController.h"

@implementation AppDelegate

@synthesize revealController,
    window,
    imageCacheEngine,
    appConfigDict,
    searchDatabaseHiddenShared;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] setObject:@"c7ae1bb085c506735d54fb83bb954837629f6823dc77a39aa4beedf2fa5692a4" forKey:@"PushDeviceID"];
    
    //Ajout des notifications push
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //Recuperation du fichier de configuration
    NSString *plistFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"configuration.plist"];
	self.appConfigDict=[NSDictionary dictionaryWithContentsOfFile:plistFile];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Step 1: Create your controllers.
    ProgrammeViewController *rootViewController = [[ProgrammeViewController alloc] init];
    UINavigationController *frontViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    UIViewController *menuViewController        = [[MenuViewController alloc] init];
    
    // Step 2: Configure an options dictionary for the PKRevealController if necessary - in most cases the default behaviour should suffice. See PKRevealController.h for more option keys.
    
     NSDictionary *options = @{
     PKRevealControllerAllowsOverdrawKey : [NSNumber numberWithBool:YES],
     PKRevealControllerDisablesFrontViewInteractionKey : [NSNumber numberWithBool:YES]
     };
    
    
    
    // Instantiate your PKRevealController.
    self.revealController = [PKRevealController revealControllerWithFrontViewController:frontViewController
                                                                     leftViewController:menuViewController
                                                                                options:options];
    
    // Set it as your root view controller.
    self.window.rootViewController = self.revealController;
    
    // Cache sur les images et chargement asynchrone
    imageCacheEngine = [[MKNetworkEngine alloc] initWithHostName:@"www.zone-turf.fr"];
    [imageCacheEngine useCache];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor colorWithRed:35.0/255 green:32.0/255 blue:28.0/255 alpha:1];//[UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:dToken forKey:@"PushDeviceID"];
    
    NSLog(@"STR%@",dToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // SI APPLICATION ACTIVE !!!!
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification récue"
                                                            message:[NSString stringWithFormat:@"Cette application vient de recevoir cette notification :\n%@",
                                                                     [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }else{// APPLICATION EN BACKGROUND MAIS INACTIVE
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
