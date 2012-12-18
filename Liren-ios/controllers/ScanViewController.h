//
//  ScanViewController.h
//  Liren-ios
//
//  Created by Kewei & Yi on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCapture.h"
#import "ZXDecodeHints.h"
#import "ZXResult.h"
#import "ZXCaptureDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "DataExchangeDelegate.h"
#import "GAITrackedViewController.h"

@interface ScanViewController : UIViewController
@property(nonatomic, retain) NSString *lastBarCode;
@property(nonatomic, retain) ZXCapture *capture;
@property(nonatomic, assign) NSObject<DataExchangeDelegate> *dataExchangeDelegate;

- (IBAction) cancelButtonPressed:(id)sender;

@end
