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
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationBar];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showSendStatusView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI method

- (void) initNavigationBar{
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem=finishButton;
    [finishButton release];
}

-(void)showSendStatusView{
    UIImageView *statusView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thank-you-banner_03.png"]];
    [statusView setFrame:CGRectMake(8, 10, 304, 110)];
    [self.view addSubview:statusView];
    [statusView release];
}

@end
