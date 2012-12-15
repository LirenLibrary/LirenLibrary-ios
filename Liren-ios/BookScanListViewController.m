//
//  BookScanListViewController.m
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "BookScanListViewController.h"

#define DOUBAN_ISBN_URL @"http://api.douban.com/v2/book/isbn/"

@interface BookScanListViewController ()

@end

@implementation BookScanListViewController

@synthesize tableView=_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"立人捐书";
    [self initNavigationBar];
    
    if(self.bookList==nil){
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.bookList = tmpArray;   
        [tmpArray release];
    }
    
    if(self.scanViewController==nil){
        ScanViewController *svc=[[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
        self.scanViewController=svc;
        [svc release];
    }
    [self.scanViewController setDataExchangeDelegate:self];
    
    if(self.queue==nil){
        NSOperationQueue *q=[[NSOperationQueue alloc] init];
        self.queue=q;
        [q release];
    }
    [self.queue setMaxConcurrentOperationCount:10];
    
//    Book *b=[[Book alloc] init];
//    [b setBookSN:@"9787111352211"];
//    [self addBook:b];
//    [b release];
}

#pragma mark - UI method

- (void) initNavigationBar{
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithTitle:@"扫描" style:UIBarButtonItemStylePlain target:self action:@selector(startScanBook)];
    self.navigationItem.leftBarButtonItem=scanButton;
    [scanButton release];
}

- (void) startScanBook{
    [self presentModalViewController:self.scanViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBook:(Book *)book{
    Boolean find = false;
    for (Book *tmp in self.bookList) {
        if([[tmp bookSN] isEqualToString:[book bookSN]]){
            find = true;
            break;
        }
    }
    if(!find){
        [self.bookList addObject:book];
        [self getBookDetail:book];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.bookList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bookIdentifier = @"BookIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookIdentifier];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookIdentifier] autorelease];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[self.bookList objectAtIndex:row]bookName];
    return cell;
}

- (void) getBookDetail:(Book *) book{
    NSURL *bookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOUBAN_ISBN_URL,book.bookSN]];
    NSLog(@"Started to get book details: %@ ",bookUrl);
    
    NSURLRequest *request=[NSURLRequest requestWithURL:bookUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Get data from douban");
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if([json valueForKey:@"msg"]==nil){
                book.bookName = [json valueForKey:@"title"];
                NSLog(@"Find Book:%@", book.bookName);
            }else{
                book.bookName = @"没找到";
                NSLog(@"Find Book:%@", book.bookName);
            }
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - DataExchange delete method
-(void)putExchangedData:(NSObject *)dataObject{
    //add the isbn scanned to the book list
    NSString *isbnNumber=(NSString *)dataObject;
    if(isbnNumber!=nil && isbnNumber.length>0){
        Book *newBook=[[Book alloc] init];
        [newBook setBookSN:isbnNumber];
        [self addBook:newBook];
        [newBook release];
    }
}

-(void)dealloc{
    [_bookList release];
    [_queue release];
    [super dealloc];
}

@end
