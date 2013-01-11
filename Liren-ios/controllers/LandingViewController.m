//
//  LandingViewController.m
//  Liren-ios
//
//  Created by XY on 12/25/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "LandingViewController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        [backButton release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view from its nib.

    if(self.bookScanViewController == nil){
        BookScanListViewController *svc = [[BookScanListViewController alloc] initWithNibName:@"BookScanListViewController" bundle:nil];
        self.bookScanViewController = svc;
        [svc release];
    }
    
    if(self.donationListViewController==nil){
        DonationListViewController *dlvc=[[DonationListViewController alloc] initWithNibName:@"DonationListViewController" bundle:nil];
        self.donationListViewController=dlvc;
        [dlvc release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - util method
-(void)initUI{
    [self.view setBackgroundColor:[AppConstant getColorViewBackground]];
}

#pragma mark - UI method
- (IBAction) donateButtonPressed:(id)sender{
    [self.navigationController pushViewController:self.bookScanViewController animated:YES];
}

-(IBAction)historyButtonPressed:(id)sender{
    [self.navigationController pushViewController:self.donationListViewController animated:YES];
}

-(void)dealloc{
    [_bookScanViewController release];
    [_donationListViewController release];
    [super dealloc];
}

@end
