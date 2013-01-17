//
//  AppDelegateTests.m
//  Liren-ios
//
//  Created by zhangyi on 12/31/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "AppDelegateTests.h"

#define SUBMIT_DEVICE_URL @"http://10.17.7.2:9091/device/new"

@implementation AppDelegateTests

-(void)testPostDeviceSubmit {
    NSDictionary *dataDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"device_token",@"token_id", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *submitDeviceUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@", SUBMIT_DEVICE_URL]];
    
    AppDelegate *appDelegate = [[AppDelegate alloc]init];

    NSData *data = [appDelegate postDeviceSubmit:submitDeviceUrl withHeaderField:@"device_id" withPostData:postData];
//    STAssertNotNil(data, @"response is not nil");
}

@end
