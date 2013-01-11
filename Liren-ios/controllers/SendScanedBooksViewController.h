//
//  SendScanedBooksViewController.h
//  Liren-ios
//
//  Created by wenhao on 12/20/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "DataExchangeDelegate.h"
#import "GAI.h"
#import "GAITrackedViewController.h"
#import "AppConstant.h"

@interface SendScanedBooksViewController : GAITrackedViewController <UITableViewDelegate,UITableViewDataSource, DataExchangeDelegate>

@property (nonatomic,retain) NSMutableArray *bookList;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@end
