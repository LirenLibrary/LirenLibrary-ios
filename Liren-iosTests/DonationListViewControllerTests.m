//
//  DonationListViewControllerTests.m
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "DonationListViewControllerTests.h"
#import "GAI.h"
#import "GAITrackedViewController.h"

@implementation DonationListViewControllerTests

- (void)setUp{
    if(self.controller==nil){
        DonationListViewController *nlvc=[[DonationListViewController alloc] init];
        self.controller=nlvc;
        [nlvc release];
    }
    [self.controller viewDidLoad];
}

-(void)testShouldExtendGAIControllerWhenCreated{
    NSString *name=[NSString stringWithFormat:@"%s", class_getName(self.controller.class)];
    STAssertNotNil(self.controller.trackedViewName, @"tracked view name can't be nil");
    STAssertTrue(self.controller.trackedViewName.length>0, @"tracked view name can't be blank");
    STAssertEqualObjects(self.controller.trackedViewName, name, @"tracked view name shoule be same with the class name");
}

-(void)testShouldInitAnEmptyDonationListWhenCreated{
    STAssertNotNil(self.controller.donationList, @"DonationList can't be nil");
    STAssertTrue(self.controller.donationList.count==0, @"DonationList's count should be zero");
}

-(void)testShouldGetDonationListWhenValidReturn{
    NSString *response=@"[{\"donation_id\":\"87535\", \"donation_time\":1356549010, \"donation_status\":\"approved\", \"donation_book_count\":4}, {\"donation_id\":\"87536\", \"donation_time\":1356721810, \"donation_status\":\"rejected\", \"donation_book_count\":3}, {\"donation_id\":\"87537\", \"donation_time\":1356808210, \"donation_status\":\"waiting\", \"donation_book_count\":4}, {\"donation_id\":\"87538\", \"donation_time\":1356981010, \"donation_status\":\"received\", \"donation_book_count\":7}]";
    
    NSData *data=[response dataUsingEncoding:NSUTF8StringEncoding];
    [self.controller loadDonationListByDeviceCallback:data withError:nil];
    STAssertTrue(self.controller.donationList.count==4, @"donation list could should be 4");
    
}

-(void)tearDown{
    [_controller release];
}

@end
