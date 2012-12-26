//
//  Donation.h
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Donation : NSObject

@property(nonatomic, retain) NSString *donationID;
@property(nonatomic, retain) NSDate *donationTime;
@property(nonatomic, retain) NSString *donationStatus;
@property(nonatomic, retain) NSNumber *bookCount;

@end
