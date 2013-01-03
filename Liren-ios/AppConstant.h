//
//  AppConstant.h
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConstant : NSObject

extern const NSString *SERVER_ADDRESS;

extern const NSString *DONATION_STATUS_NEW;
extern const NSString *DONATION_STATUS_APPROVED;
extern const NSString *DONATION_STATUS_REJECTED;
extern const NSString *DONATION_STATUS_RECEIVED;

+(UIColor *)getColorViewBackground;
+(UIColor *)getColorTableCellTitleText;
+(UIColor *)getColorTableCellBackground;
+(UIColor *)getColorDonationStatusNew;
+(UIColor *)getColorDonationStatusApproved;
+(UIColor *)getColorDonationStatusRejected;
+(UIColor *)getColorDonationStatusReceived;

@end
