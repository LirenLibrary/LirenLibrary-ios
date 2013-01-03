//
//  DonationListViewController.h
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.

//  The controller to list all the donation request generated by the device

#import <UIKit/UIKit.h>
#import "Donation.h"
#import "EGORefreshTableHeaderView.h"
#import "MacAddressUtil.h"
#import "AppConstant.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITrackedViewController.h"
#import <objc/runtime.h>

@interface DonationListViewController : GAITrackedViewController <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>{
    BOOL LOADING_DONATION_LIST;
}

@property(nonatomic, retain) NSMutableArray *donationList;
@property(nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) NSOperationQueue *queue;

-(void)initUI;
-(void)initDonationList;
-(void)loadDonationListByDevice;
-(void)loadDonationListByDeviceCallback:(NSData *)data withError:(NSError *)error;

@end
