//
//  AppConstant.m
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "AppConstant.h"

@implementation AppConstant

const NSString *SERVER_ADDRESS=@"http://42.121.57.157:8080/lirenlibrary/api";

const NSString *DONATION_STATUS_NEW=@"NEW";
const NSString *DONATION_STATUS_APPROVED=@"APPROVED";
const NSString *DONATION_STATUS_REJECTED=@"REJECTED";
const NSString *DONATION_STATUS_RECEIVED=@"NOTIFIED";

#pragma mark - color constant
+(UIColor *)getColorViewBackground{
    return [UIColor colorWithRed:243.0f/255.0f green:238.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
}
+(UIColor *)getColorTableCellTitleText{
    return [UIColor colorWithRed:67.0f/255.0f green:64.0f/255.0f blue:49.0f/255.0f alpha:1.0f];
}
+(UIColor *)getColorTableCellBackground{
    return [UIColor colorWithRed:247.0f/255.0f green:244.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
}
+(UIColor *)getColorDonationStatusNew{
    return [UIColor colorWithRed:184.0f/255.0f green:165.0f/255.0f blue:79.0f/255.0f alpha:1.0f];
}
+(UIColor *)getColorDonationStatusApproved{
    return [UIColor colorWithRed:162.0f/255.0f green:208.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
}
+(UIColor *)getColorDonationStatusRejected{
    return [UIColor colorWithRed:204.0f/255.0f green:60.0f/255.0f blue:53.0f/255.0f alpha:1.0f];
}
+(UIColor *)getColorDonationStatusReceived{
    return [UIColor colorWithRed:131.0f/255.0f green:131.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
}

@end
