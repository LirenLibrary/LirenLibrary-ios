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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, retain) BookScanListViewController *bookScanListViewController;
@property(nonatomic, retain) LandingViewController *landingViewController;
@property(nonatomic, retain) NSMutableDictionary *globalUserData;

-(void)saveGlobalUserData;

@end
