//
//  SendScanedBooksViewController.m
//  Liren-ios
//
//  Created by wenhao on 12/20/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "SendScanedBooksViewController.h"

@interface SendScanedBooksViewController ()

@end

@implementation SendScanedBooksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationBar];
}

-(void)initUI{
    [self.view setBackgroundColor:[AppConstant getColorViewBackground]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self showSendStatusView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI method

- (void) initNavigationBar{
    self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem=finishButton;
    [finishButton release];
}

-(void)showSendStatusView{
    UIImageView *statusView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thank-you-banner_03.png"]];
    [statusView setFrame:CGRectMake(8, 10, 304, 110)];
    [self.view addSubview:statusView];
    [statusView release];
}

- (void) finish{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    cell.textLabel.text = [[self.bookList objectAtIndex:row] bookName];
    cell.textLabel.textColor=[AppConstant getColorTableCellTitleText];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = cell.contentView.backgroundColor;
}

#pragma mark - DataExchange delete method
-(void)putExchangedData:(NSObject *)dataObject{
    NSMutableArray *books=(NSMutableArray *)dataObject;
    if(books!=nil && books.count>0){
        [self.bookList removeAllObjects];
        [self.bookList addObjectsFromArray:books];
    }
}

#pragma mark - system method
-(void)dealloc{
    [_bookList release];
    [super dealloc];
}
@end
