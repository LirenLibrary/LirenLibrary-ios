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
    self.trackedViewName=[NSString stringWithFormat:@"%s", class_getName(self.class)];
    
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
    
    if(self.sendScanedBooksViewController==nil){
        SendScanedBooksViewController *svc=[[SendScanedBooksViewController alloc] initWithNibName:@"SendScanedBooksViewController" bundle:nil];
        self.sendScanedBooksViewController=svc;
        [svc release];
    }
    
    if(self.queue==nil){
        NSOperationQueue *q=[[NSOperationQueue alloc] init];
        self.queue=q;
        [q release];
    }
    [self.queue setMaxConcurrentOperationCount:10];
}

#pragma mark - UI method

- (void) initNavigationBar{
    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc]initWithTitle:@"扫描条码" style:UIBarButtonItemStylePlain target:self action:@selector(startScanBook)];
    self.navigationItem.leftBarButtonItem=scanButton;
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc]initWithTitle:@"发送书单" style:UIBarButtonItemStylePlain target:self action:@selector(sendScanedBooks)];
    self.navigationItem.rightBarButtonItem=sendButton;
    [scanButton release];
}

- (void) startScanBook{
    [self presentModalViewController:self.scanViewController animated:YES];
}

- (void) sendScanedBooks{
    [self presentModalViewController:self.sendScanedBooksViewController animated:YES];
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
        [self getBookDetail:book];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"你已经扫描过这本书了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.bookList count];
}

- (void) deleteBook:(int) index{
    [self.bookList removeObjectAtIndex:index];
    [self.tableView reloadData];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        [self deleteBook:indexPath.row];
    }
}

- (void) getBookDetail:(Book *) book{
    NSURL *bookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOUBAN_ISBN_URL,book.bookSN]];
    NSLog(@"Started to get book details: %@ ",bookUrl);
    
    NSURLRequest *request=[NSURLRequest requestWithURL:bookUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(data==nil || error!=nil){
                //got network error
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"连接网络失败了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }else{
                NSLog(@"Get data from douban");
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                if([json valueForKey:@"msg"]==nil){
                    book.bookName = [json valueForKey:@"title"];
                    [self.bookList addObject:book];
                    NSLog(@"Find Book:%@", book.bookName);
                }else{
                    book.bookName = @"没找到";
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"没有找到这本书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    [alert release];
                    
                    NSLog(@"Find Book:%@", book.bookName);
                }
                [self.tableView reloadData];
            }
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
