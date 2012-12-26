//
//  BookScanListViewControllerTests.m
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "BookScanListViewControllerTests.h"

@implementation BookScanListViewControllerTests

- (void)setUp
{
    [super setUp];
    
    if (self.bookScanListViewController==nil) {
        BookScanListViewController *tmpBookScanListView = [[BookScanListViewController alloc]initWithNibName:@"BookScanListViewController" bundle:nil];
        self.bookScanListViewController = tmpBookScanListView;
        [tmpBookScanListView release];
        [self.bookScanListViewController viewDidLoad];
    }
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void) testShouldAddBookToList{
    Book *book = [self buildBookObject:@"9787111352211" bookname:nil];
    [self.bookScanListViewController addBook:book];
    [book release];
    
}

- (void) testShouldNotAddSameBookWithSameSNToList{
    Book *book = [self buildBookObject:@"9787111352211" bookname:nil];
    [self.bookScanListViewController addBook:book];
    [book release];
    Book *book2 = [self buildBookObject:@"9787111352211" bookname:nil];
    [self.bookScanListViewController addBook:book2];
    [book release];
    STFail(@"a failed test");
}


- (void) testShouldDownloadFoundBookNameFromDouban{
    Book *book = [self buildBookObject:@"9787564129651" bookname:nil];
    [self.bookScanListViewController getBookDetail:book];
    //STAssertNotNil(book.bookName, @"Did not find the book Name");
    [book release];
}

- (void) testShouldInitEmptyBookListWhenViewControllerCreated{
    STAssertNotNil(self.bookScanListViewController.bookList, @"Havent init Book List Array");
    STAssertEquals([self.bookScanListViewController.bookList count],(NSUInteger)0,@"Book List must be init as empty Array List");
}

- (Book *) buildBookObject:(NSString *) sn bookname:(NSString *) bookname{
    Book *book = [[Book alloc]init];
    [book setBookName:bookname];
    [book setBookSN:sn];
    return book;
}

@end
