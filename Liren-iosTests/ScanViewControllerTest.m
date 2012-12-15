//
//  ScanViewControllerTest.m
//  Liren-ios
//
//  Created by Kewei & Yi 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "ScanViewControllerTest.h"
#import "ScanViewController.h"
#import "DataExchangeDelegate.h"
#import "ZXResult.h"

@implementation ScanViewControllerTest


- (void)testPutExchangedData {
    id delegateMock = [OCMockObject mockForProtocol:@protocol(DataExchangeDelegate)];
    [[delegateMock expect] putExchangedData:@"999999"];
    
    ScanViewController *controller = [[ScanViewController alloc] init];
    [controller setDataExchangeDelegate:delegateMock];
    
    id resultStub = [OCMockObject mockForClass:[ZXResult class]];
    [[[resultStub stub] andReturn:@"999999"] text];
    
    ZXCapture *capture = [[ZXCapture alloc] init];
    
    [(id<ZXCaptureDelegate>)controller captureResult:capture result:resultStub];
    
    [delegateMock verify];    
}

@end
