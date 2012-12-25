//
//  LandingViewController.m
//  Liren-ios
//
//  Created by XY on 12/25/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "LandingViewController.h"
#import "BookScanListViewController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

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
    
    
    self.title = @"立人捐书";
    
    if(self.bookScanViewController == nil){
        BookScanListViewController *svc = [[BookScanListViewController alloc] initWithNibName:@"BookScanListViewController" bundle:nil];
        self.bookScanViewController = svc;
        [svc release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI method
- (IBAction) donateButtonPressed:(id)sender{
    [self.navigationController pushViewController:self.bookScanViewController animated:YES];
}

@end
