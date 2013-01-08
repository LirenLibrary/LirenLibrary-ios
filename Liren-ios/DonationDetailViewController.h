//
//  DonationDetailViewController.h
//  Liren-ios
//
//  Created by zhangyi on 1/8/13.
//  Copyright (c) 2013 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Donation.h"

@interface DonationDetailViewController : UIViewController

@property (nonatomic, retain) Donation *donation;

-(void) queryDonationRequestCallback:(NSData *)data;

@end
