//
//  Donation.m
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "Donation.h"

@implementation Donation

-(void)dealloc{
    [_donationID release];
    [_donationStatus release];
    [_donationTime release];
    [_bookCount release];
    [super dealloc];
}

@end
