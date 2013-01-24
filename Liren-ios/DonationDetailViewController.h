//
//  DonationDetailViewController.h
//  Liren-ios
//
//  Created by zhangyi on 1/8/13.
//  Copyright (c) 2013 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Donation.h"
#import "AppConstant.h"
#import "MacAddressUtil.h"
#import "MBProgressHUD.h"
#import "GAI.h"
#import "GAITrackedViewController.h"
#import <objc/runtime.h>

@interface DonationDetailViewController : GAITrackedViewController <UITableViewDataSource>

@property (nonatomic, retain) Donation *donation;
@property (nonatomic, retain) IBOutlet UIImageView *donationStatusImage;
@property (nonatomic, retain) IBOutlet UITableView *bookListTable;
@property (nonatomic, retain) IBOutlet UITextView *postSpecificationView;
@property (nonatomic, retain) IBOutlet UILabel *donationIDLabel;

-(void) queryDonationRequestCallback:(NSData *)data;
- (void) initUI;
-(void) queryDonationRequest;
-(void)updateDonationStatusUI;
-(void)buildTableCell:(UITableViewCell *)cell withBook:(Book *)book;

@end
