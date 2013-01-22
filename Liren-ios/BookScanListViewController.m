//
//  BookScanListViewController.m
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "BookScanListViewController.h"

#define DOUBAN_ISBN_URL @"http://api.douban.com/v2/book/isbn/"
#define TAG_VIEW_START_HINT 1001

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
    
    self.trackedViewName=[NSString stringWithFormat:@"%s", class_getName(self.class)];
    
    if(self.bookList==nil){
        NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.bookList = tmpArray;   
        [tmpArray release];
    }
    
    [self initUI];
    
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
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.sendScanedBooksViewController setBookList:tmpArray];
    [tmpArray release];
    [self setDataExchangeDelegate:self.sendScanedBooksViewController];
    
    if(self.queue==nil){
        NSOperationQueue *q=[[NSOperationQueue alloc] init];
        self.queue=q;
        [q release];
    }
    [self.queue setMaxConcurrentOperationCount:10];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showStartHintView];
}

#pragma mark - UI method
- (void) initUI{
    [self initNavigationBar];
    [self.view setBackgroundColor:[AppConstant getColorViewBackground]];
}

- (void) initNavigationBar{
    if(self.doneBarButton == nil){
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setFrame:CGRectMake(0.0f, 0.0f, 48.0f, 30.0f)];
        [sendButton addTarget:self action:@selector(sendScanedBooks) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setImage:[UIImage imageNamed:@"submit-buttom_03.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
        self.doneBarButton = barButton;
        [barButton release];
    }
    
    if(self.bookList.count>0){
        self.navigationItem.rightBarButtonItem = self.doneBarButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)showStartHintView{
    if(self.bookList.count==0){
        if([self.view viewWithTag:TAG_VIEW_START_HINT] != nil) return;
        
        UIImageView *hintView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan-placeholder_03.png"]];
        [hintView setTag: TAG_VIEW_START_HINT];
        [hintView setFrame:CGRectMake(48, 245, 188, 124)];
        [self.view addSubview:hintView];
        [hintView release];
        [self.tableView setAlpha:0.0f];
    }
}

-(void)removeStartHintView{
    if([self.view viewWithTag:TAG_VIEW_START_HINT] != nil){
        [[self.view viewWithTag:TAG_VIEW_START_HINT] removeFromSuperview];
        [self.tableView setAlpha:1.0f];
    }
}

- (IBAction) scanButtonPressed:(id)sender{
    [self presentModalViewController:self.scanViewController animated:YES];
}

- (void) sendScanedBooks
{
    [self sendScanedBooksRequest];
}

-(void)sendScanedBooksRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *newDonationUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/donations/new", SERVER_ADDRESS]];
    NSLog(@"Started to send book request: %@ ",newDonationUrl);
    
    NSString *deviceID=[MacAddressUtil macaddress];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:newDonationUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self requestBody]];
    [request addValue:deviceID forHTTPHeaderField:@"device_id"];
    [request addValue:@"application/vnd.liren-donation-submit-response+json; charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/vnd.liren-donation-submit-request+json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"v1" forHTTPHeaderField:@"Version"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getSendScanedBooksCallback:error withData:data];
        });
    }];
}

-(NSData *)requestBody
{
    NSMutableArray *booksArray = [[NSMutableArray alloc]initWithCapacity:self.bookList.count];
    for (Book *book in self.bookList) {
        NSDictionary *bookDictionary = [NSDictionary dictionaryWithObjectsAndKeys:book.bookSN,@"ISBN",book.bookName,@"title", nil];
        [booksArray addObject:bookDictionary];
    }
    NSError *writeError = nil;
    NSDictionary* requestDictionary = [NSDictionary dictionaryWithObject:booksArray forKey:@"books"];
    [booksArray release];
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&writeError];
    return requestData;
}

-(void)getSendScanedBooksCallback:(NSError *)error withData:(NSData *)data
{
    if(data==nil || error!=nil){
        //got network error
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"连接网络失败了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
        NSLog(@"Get data from server");
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if([json valueForKey:@"msg"]==nil){
            NSString *donationID = [json valueForKey:@"donation_id"];
            NSLog(@"New Donation:%@", donationID);
            if(donationID != nil){
                [self sendScanedBooksSuccess];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"发送不成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            
        }
        [self.tableView reloadData];
    } 
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void) sendScanedBooksSuccess
{
    if (self.dataExchangeDelegate) {
        [self.dataExchangeDelegate putExchangedData:self.bookList];
        [self.navigationController pushViewController:self.sendScanedBooksViewController animated:YES];
        [self.bookList removeAllObjects];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Book List management
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

- (void) deleteBook:(int) index{
    [self.bookList removeObjectAtIndex:index];
    [self.tableView reloadData];
}

#pragma mark - TableView implementation
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
    
    cell.contentView.backgroundColor=[AppConstant getColorTableCellBackground];
    cell.textLabel.text = [[self.bookList objectAtIndex:row]bookName];
    cell.textLabel.textColor=[AppConstant getColorTableCellTitleText];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle==UITableViewCellEditingStyleDelete){
        [self deleteBook:indexPath.row];
        if(self.bookList.count==0){
            self.navigationItem.rightBarButtonItem=nil;
            [self showStartHintView];
        }
    }
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = cell.contentView.backgroundColor;
}

#pragma mark - Get book detail
- (void) getBookDetail:(Book *) book{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURL *bookUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOUBAN_ISBN_URL,book.bookSN]];
    NSLog(@"Started to get book details: %@ ",bookUrl);
    
    NSURLRequest *request=[NSURLRequest requestWithURL:bookUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getBookDetailCallback:error withData:data withBook:book];
        });
    }];
}


-(void)getBookDetailCallback:(NSError *)error withData:(NSData *)data withBook:(Book *)book{
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
            self.navigationItem.rightBarButtonItem=self.doneBarButton;
            [self removeStartHintView];
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

#pragma mark - system method
-(void)dealloc{
    [_bookList release];
    [_queue release];
    [_doneBarButton release];
    [super dealloc];
}

@end
