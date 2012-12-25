//
//  AppDelegate.m
//  Liren-ios
//
//  Created by xuehai on 11/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "AppDelegate.h"
#import "MacAddressUtil.h"

#define EXT_APPID_GOOGLE_ANALYSIS @"UA-37024844-1"
#define KEY_USER_STATE  @"LirenLib-User-State"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_landingViewController release];
    [_globalUserData release];
    [super dealloc];
}

- (void)initLandingViewController
{
    if(self.landingViewController == nil) {
        LandingViewController *lvc = [[LandingViewController alloc] initWithNibName:@"LandingViewController" bundle:nil];
        self.landingViewController = lvc;
        [lvc release];
    }
}

- (void)initUINavigationController
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.landingViewController];
    [self.window setRootViewController:nav];
    [nav autorelease];
}

- (void) initGoogleAnalysis{
    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = 60*10;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].defaultTracker=[[GAI sharedInstance] trackerWithTrackingId:EXT_APPID_GOOGLE_ANALYSIS];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    
    [self restoreGlobalUserData];
    [self initLandingViewController];
    [self initUINavigationController];
    [self initGoogleAnalysis];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *devToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    devToken = [devToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@",deviceToken);
    
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
    
    //save user's state
    [self saveGlobalUserData];
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

#pragma mark - util method
-(void)saveGlobalUserData{
    [[NSUserDefaults standardUserDefaults] setObject:self.globalUserData forKey:KEY_USER_STATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)restoreGlobalUserData{
    NSMutableDictionary *tmpDic=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_USER_STATE];
	if(tmpDic!=nil){
		self.globalUserData=tmpDic;
	}
    if(self.globalUserData==nil){
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        self.globalUserData=dic;
        [dic release];
    }
}

@end
