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
    Book *book = [self buildBookObject:@"SN" bookname:nil];
    [self.bookScanListViewController addBook:book];
    [book release];
    STAssertEquals([self.bookScanListViewController.bookList count],(NSUInteger)1,@"The Book list size must be 1 after added one book");
    STAssertTrue([self.bookScanListViewController.bookList containsObject:book], @"The book added must be the same as the book we added");
}

- (void) testShouldNotAddSameBookWithSameSNToList{
    Book *book = [self buildBookObject:@"SN" bookname:nil];
    [self.bookScanListViewController addBook:book];
    [book release];
    Book *book2 = [self buildBookObject:@"SN" bookname:nil];
    [self.bookScanListViewController addBook:book2];
    [book release];
    STAssertEquals([self.bookScanListViewController.bookList count],(NSUInteger)1,@"The Book list size must be 1 after added same SN book");
    STAssertTrue([self.bookScanListViewController.bookList containsObject:book], @"The book added must be the same as the book we first added");
}

- (void) testShouldDownloadFindBookNameFromDouban{
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
