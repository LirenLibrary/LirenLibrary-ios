//
//  DonationListViewController.m
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "DonationListViewController.h"
#import "MacAddressUtil.h"
#import "AppConstant.h"
#import "MBProgressHUD.h"

#define SERVICE_SUFFIX_LOAD_DONATION_LIST  @"/donation-by-device"

@interface DonationListViewController ()

@end

@implementation DonationListViewController

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
    [self initDonationList];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadDonationListByDevice];
    [super viewWillAppear:animated];
}

#pragma mark - util method
-(void)initDonationList{
    if(self.donationList==nil){
        NSMutableArray *array=[[NSMutableArray alloc] init];
        self.donationList=array;
        [array release];
    }
}

-(void)loadDonationListByDevice{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *deviceID=[MacAddressUtil macaddress];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_ADDRESS, SERVICE_SUFFIX_LOAD_DONATION_LIST]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0f];
    [request addValue:deviceID forHTTPHeaderField:@"device_id"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadDonationListByDeviceCallback:data withError:error];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    }];
}

-(void)loadDonationListByDeviceCallback:(NSData *)data withError:(NSError *)error{
    NSArray *list = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if(list==nil || list.count==0) return;
    
    [self.donationList removeAllObjects];
    
    for(NSDictionary *item in list){
        Donation *donation=[[Donation alloc] init];
        donation.donationID=[item objectForKey:@"donation_id"];
        donation.donationStatus=[item objectForKey:@"donation_status"];
        NSNumber *donationTimestamp=[item objectForKey:@"donation_time"];
        donation.donationTime = [NSDate dateWithTimeIntervalSince1970:donationTimestamp.longValue];
        donation.bookCount=[item objectForKey:@"donation_book_count"];
        [self.donationList addObject:donation];
        [donation release];
    }
}

-(void)dealloc{
    [_donationList release];
    [super dealloc];
}

@end
