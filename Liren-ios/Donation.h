//
//  Donation.h
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface Donation : NSObject

@property(nonatomic, retain) NSString *donationID;
@property(nonatomic, retain) NSDate *donationTime;
@property(nonatomic, retain) NSString *donationStatus;
@property(nonatomic, retain) NSNumber *bookCount;
@property(nonatomic, retain) NSString *postAddress;
@property(nonatomic, retain) NSString *postReceiver;
@property(nonatomic, retain) NSString *postCode;
@property(nonatomic, retain) NSString *postReceiverMobile;
@property(nonatomic, retain) NSString *postSpecification;
@property(nonatomic, retain) NSMutableArray *books;

-(id) initWithJsonString:(NSData *)json;

@end
