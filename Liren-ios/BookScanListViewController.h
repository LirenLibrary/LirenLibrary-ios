//
//  BookScanListViewController.h
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "DataExchangeDelegate.h"
#import "ScanViewController.h"
#import "GAI.h"
#import "GAITrackedViewController.h"

@interface BookScanListViewController : GAITrackedViewController <UITableViewDelegate,UITableViewDataSource, DataExchangeDelegate>
@property (nonatomic,retain) NSMutableArray *bookList;
@property(nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic, retain) ScanViewController *scanViewController;

- (void) addBook:(Book *) book;
- (void) getBookDetail:(Book *) book;
- (void) initNavigationBar;
@end
