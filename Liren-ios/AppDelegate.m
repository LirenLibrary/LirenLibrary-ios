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
#define KEY_NOTIFICATION_STATUS @"notification_status"
#define SERVICE_SUFFIX_SUBMIT_DEVICE @"/devices/register"

@implementation AppDelegate

- (void)dealloc
{
    [_queue release];
    [_window release];
    [_landingViewController release];
    [_globalUserData release];
    [_donationListViewController release];
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
    
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-back.png"] forBarMetrics:UIBarMetricsDefault];
    
    nav.navigationBar.tintColor = [UIColor colorWithRed:194.0f/255.0f green:90.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    
    [self.window setRootViewController:nav];
    [nav autorelease];
}

- (void) initGoogleAnalysis{
    [GAI sharedInstance].debug = NO;
    [GAI sharedInstance].dispatchInterval = 60*10;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].defaultTracker=[[GAI sharedInstance] trackerWithTrackingId:EXT_APPID_GOOGLE_ANALYSIS];
}

-(void)handleRemotePush:(NSDictionary *)launchOptions{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary *remoteNotif = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotif) {
        if(self.donationListViewController == nil){
            DonationListViewController *dlvc=[[DonationListViewController alloc] initWithNibName:@"DonationListViewController" bundle:nil];
            self.donationListViewController = dlvc;
            [dlvc release];
        }
        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:self.donationListViewController animated:YES];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    [self restoreGlobalUserData];
    [self initLandingViewController];
    [self initUINavigationController];
    [self initGoogleAnalysis];
    
    if (nil == [self.globalUserData objectForKey:KEY_NOTIFICATION_STATUS]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    }
    
    [self handleRemotePush:launchOptions];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSString *)formatDeviceToken:(NSData *)deviceToken {
    NSString *token=[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", token);
    return token;
}

- (NSData *)postDeviceSubmit:(NSURL *)submitDeviceUrl withHeaderField:(NSString *)deviceId withPostData:(NSData *)postData {
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:submitDeviceUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];
    [request setHTTPMethod:@"POST"];
    [request addValue:deviceId forHTTPHeaderField:@"device_id"];
    [request setHTTPBody:postData];
    
    [request addValue:@"application/vnd.liren-device-register-request+json; charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/vnd.liren-device-register-request+json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"v1" forHTTPHeaderField:@"Version"];
    
    NSHTTPURLResponse *response=nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if(response.statusCode>=200 && response.statusCode<300) return data;
    else return nil;
}

- (void)deviceInfoSubmittedCallback:(NSURL *)submitDeviceUrl postData:(NSData *)postData {
    NSData *data;
    NSString *macAddress = [MacAddressUtil macaddress];
    data = [self postDeviceSubmit:submitDeviceUrl withHeaderField:macAddress withPostData:postData];
    if(data!=nil){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.globalUserData setValue:[NSNumber numberWithBool:YES] forKey:KEY_NOTIFICATION_STATUS];
            [self saveGlobalUserData];
        });
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [self formatDeviceToken:deviceToken];
    NSDictionary *dataDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:token, @"device_token", nil];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:NSJSONWritingPrettyPrinted error:&error];
    [dataDictionary release];
    
    if ([postData length] > 0 && error == nil) {
        NSURL *submitDeviceUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_SUFFIX_SUBMIT_DEVICE]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self deviceInfoSubmittedCallback:submitDeviceUrl postData:postData];
        });
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
