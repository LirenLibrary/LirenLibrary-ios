//
//  BookScanListViewController.h
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface BookScanListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) NSMutableArray *bookList;
@property(nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic,retain) IBOutlet UITableView *tableView;

- (void) addBook:(Book *) book;
- (void) getBookDetail:(Book *) book;
@end
