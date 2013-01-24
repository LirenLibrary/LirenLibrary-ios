//
//  AppDelegate.h
//  Liren-ios
//
//  Created by xuehai on 11/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookScanListViewController.h"
#import "LandingViewController.h"
#import "GAI.h"
#import "MacAddressUtil.h"
#import "DonationListViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) LandingViewController *landingViewController;
@property(nonatomic, retain) NSMutableDictionary *globalUserData;
@property(nonatomic, retain) NSOperationQueue *queue;
@property(nonatomic, retain) DonationListViewController *donationListViewController;

-(void)saveGlobalUserData;
-(NSData *)postDeviceSubmit:(NSURL *)submitDeviceUrl withHeaderField:(NSString *)deviceId withPostData:(NSData *)postData;
-(void)handleRemotePush:(NSDictionary *)launchOptions;

@end
