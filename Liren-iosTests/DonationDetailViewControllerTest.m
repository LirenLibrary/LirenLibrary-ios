//
//  DonationDetailViewControllerTest.m
//  Liren-ios
//
//  Created by zhangyi on 1/8/13.
//  Copyright (c) 2013 com.thoughtworks.liren. All rights reserved.
//

#import "DonationDetailViewControllerTest.h"

@implementation DonationDetailViewControllerTest

-(void) testQueryDonationRequest{
    DonationDetailViewController *controller = [[DonationDetailViewController alloc]initWithNibName:@"DonationDetailViewController" bundle:nil];
    
    NSString *response=@"{ \"donation_id\" : \"837462\", \"donation_status\" : \"ready\", \"post_address\" : \"Tianfu software park E1\", \"post_receiver\" : \"Three Lee\", \"post_code\" : \"610000\", \"post_receiver_mobile\" : \"13900000000\", \"books\":[ { \"ISBN\" : \"100000001\", \"status\" : \"approved\" }, { \"ISBN\" : \"100000002\", \"status\" : \"rejected\" }, { \"ISBN\" : \"100000003\", \"status\" : \"received\" } ] }";
    
    NSData *data=[response dataUsingEncoding:NSUTF8StringEncoding];
    
    [controller queryDonationRequestCallback:data];
    STAssertNotNil(controller.donation, @"donation from servier should not be nil");
    STAssertEqualObjects(controller.donation.donationID, @"837462", @"donation id should be expected value");
    STAssertNotNil(controller.donation.books, @"the book list should not be nil");
    STAssertTrue(controller.donation.books.count == 3, @"the size of book list should be 3");
}

@end
