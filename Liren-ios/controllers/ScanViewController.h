//
//  ScanViewController.h
//  Liren-ios
//
//  Created by mobile_cd_mini on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXCapture.h"
#import "ZXDecodeHints.h"
#import "ZXResult.h"
#import "ZXCaptureDelegate.h"
#import <QuartzCore/QuartzCore.h>


@interface ScanViewController : UIViewController
@property(nonatomic, retain) NSString *lastBarCode;
@property(nonatomic, retain) ZXCapture *capture;

@end
