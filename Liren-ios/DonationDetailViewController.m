//
//  DonationDetailViewController.m
//  Liren-ios
//
//  Created by zhangyi on 1/8/13.
//  Copyright (c) 2013 com.thoughtworks.liren. All rights reserved.
//

#import "DonationDetailViewController.h"

@interface DonationDetailViewController ()

@end

@implementation DonationDetailViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - network callback method
-(void) queryDonationRequestCallback:(NSData *)data{
    self.donation = [[Donation alloc]initWithJsonString:data];
    
}

-(void) dealloc{
    [_donation release];
    [super dealloc];
}

@end
