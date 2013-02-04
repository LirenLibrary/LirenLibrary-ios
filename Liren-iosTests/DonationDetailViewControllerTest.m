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
    
    NSString *response=@"{\"books\" : [ {\"status\" : \"APPROVED\",\"title\" : \"设计模式解析\",\"ISBN\" : \"9787115150950\"}, {\"status\" : \"APPROVED\",\"title\" : \"软件调试的艺术\",\"ISBN\" : \"9787115213969\"}, {\"status\" : \"APPROVED\",\"title\" : \"面向模式的软件架构 卷4：分布式计算的模式语言\",\"ISBN\" : \"9787115227737\"}, {\"status\" : \"APPROVED\",\"title\" : \"重构\",\"ISBN\" : \"9787115239143\"}, {\"status\" : \"REJECTED\",\"title\" : \"Java设计模式\",\"ISBN\" : \"9787121178269\"} ],\"donation_id\" : \"56\",\"donation_status\" : \"APPROVED\",\"donation_time\" : 1358831004,\"donation_item_count\" : 5,\"post_specification\" : \"\"}";

    NSData *data=[response dataUsingEncoding:NSUTF8StringEncoding];
    
    [controller queryDonationRequestCallback:data];

}

@end
