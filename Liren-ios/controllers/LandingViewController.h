//
//  LandingViewController.h
//  Liren-ios
//
//  Created by XY on 12/25/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "GAITrackedViewController.h"
#import "BookScanListViewController.h"

@interface LandingViewController : GAITrackedViewController

@property(nonatomic, retain)  BookScanListViewController *bookScanViewController;

//@property(nonatomic, retain) SendScanedBooksViewController *sendScanedBooksViewController;

@end
