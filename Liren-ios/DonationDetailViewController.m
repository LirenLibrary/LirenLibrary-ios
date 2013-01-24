//
//  DonationDetailViewController.m
//  Liren-ios
//
//  Created by zhangyi on 1/8/13.
//  Copyright (c) 2013 com.thoughtworks.liren. All rights reserved.
//

#import "DonationDetailViewController.h"

#define TAG_VIEW_CELL_CHILD_START   1001
#define TAG_VIEW_CELL_CHILD_BOOK_TITLE  TAG_VIEW_CELL_CHILD_START+1
#define TAG_VIEW_CELL_CHILD_STRIKE_LINE TAG_VIEW_CELL_CHILD_START+2

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
    self.trackedViewName=[NSString stringWithFormat:@"%s", class_getName(self.class)];
    [self initUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self queryDonationRequest];
    });
}

-(void)viewDidDisappear:(BOOL)animated{
    self.donationStatusImage.image = nil;
    [self.donation.books removeAllObjects];
    [self.bookListTable reloadData];
    [self.postSpecificationView setText:@""];
    [self.donationIDLabel setText:@""];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [super viewDidDisappear:animated];
}

#pragma mark - util method
- (void) initUI{
    [self.view setBackgroundColor:[AppConstant getColorViewBackground]];
}
-(void) queryDonationRequest{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
    NSString *url = [NSString stringWithFormat:@"%@/donations/%@", SERVER_ADDRESS, self.donation.donationID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:7.0f];
    
    NSString *deviceID=[MacAddressUtil macaddress];
    [request addValue:deviceID forHTTPHeaderField:@"device_id"];
    [request addValue:@"application/vnd.liren-donation+json; charset=UTF-8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"application/vnd.liren-donation+json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"v1" forHTTPHeaderField:@"Version"];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [self queryDonationRequestCallback:responseData];
}

-(void)updateDonationStatusUI{
    if([DONATION_STATUS_NEW isEqualToString:self.donation.donationStatus]){
        self.donationStatusImage.image = [UIImage imageNamed:@"in-progress-banner_03.png"];
        [self.donationStatusImage setFrame:CGRectMake(8, self.donationStatusImage.frame.origin.y, 304, 111)];
    }
    if([DONATION_STATUS_APPROVED isEqualToString:self.donation.donationStatus]){
        self.donationStatusImage.image = [UIImage imageNamed:@"complete-banner_03.png"];
        [self.donationStatusImage setFrame:CGRectMake(9, self.donationStatusImage.frame.origin.y, 302, 219)];
        
        self.postSpecificationView.text = self.donation.postSpecification;
        self.donationIDLabel.text = self.donation.donationID;
    }
    if([DONATION_STATUS_REJECTED isEqualToString:self.donation.donationStatus]){
        self.donationStatusImage.image = [UIImage imageNamed:@"sorry-banner_03.png"];
        [self.donationStatusImage setFrame:CGRectMake(8, self.donationStatusImage.frame.origin.y, 304, 111)];
    }
    if([DONATION_STATUS_RECEIVED isEqualToString:self.donation.donationStatus]){
        self.donationStatusImage.image = [UIImage imageNamed:@"thanks_03.png"];
        [self.donationStatusImage setFrame:CGRectMake(9, self.donationStatusImage.frame.origin.y, 302, 96)];
    }
    
    float y = self.donationStatusImage.frame.origin.y+self.donationStatusImage.frame.size.height;
    
    [self.bookListTable setFrame:CGRectMake(0, y, 320, self.view.frame.size.height - y)];
    
    [self.bookListTable reloadData];
}

#pragma mark - network callback method
-(void) queryDonationRequestCallback:(NSData *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(data==nil){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"联网失败";
            hud.margin = 10.f;
            hud.yOffset = 80.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1];
        }else{
            Donation *donation = [[Donation alloc]initWithJsonString:data];
            self.donation = donation;
            [donation release];
            
            [self updateDonationStatusUI];
        }
    });
}

#pragma mark - TableView implementation
-(void)buildTableCell:(UITableViewCell *)cell withBook:(Book *)book{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *bookName=[[UILabel alloc] initWithFrame:CGRectMake(18, 8, 300, 30)];
    [bookName setTag:TAG_VIEW_CELL_CHILD_BOOK_TITLE];
    [bookName setText:book.bookName];
    [bookName setBackgroundColor:[UIColor clearColor]];
    [bookName setTextColor:[AppConstant getColorTableCellTitleText]];
    [bookName setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [cell addSubview:bookName];
    
    if([DONATION_STATUS_REJECTED isEqualToString:book.bookStatus]){
        CGSize size = [bookName.text sizeWithFont:[UIFont systemFontOfSize:16.0f]];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0 , bookName.frame.size.height / 2, size.width, 1)];
        line.backgroundColor = [UIColor redColor];
        [bookName addSubview:line];
        [bookName setTextColor:[UIColor redColor]];
    }
    
    [bookName release];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(self.donation.books.count == 0) return nil;
    if([DONATION_STATUS_NEW isEqualToString:self.donation.donationStatus]){
        return @"捐赠书目";
    }
    if([DONATION_STATUS_APPROVED isEqualToString:self.donation.donationStatus]){
        return @"捐赠书目(红色书目请勿寄送)";
    }
    if([DONATION_STATUS_RECEIVED isEqualToString:self.donation.donationStatus]){
        return @"捐赠书目";
    }
    if([DONATION_STATUS_REJECTED isEqualToString:self.donation.donationStatus]){
        return @"已拒绝书目";
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.donation.books count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bookIdentifier = @"DonationIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookIdentifier];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookIdentifier] autorelease];
    }
    
    for(UIView *view in cell.subviews){
        if(view.tag > TAG_VIEW_CELL_CHILD_START){
            [view removeFromSuperview];
        }
    }
    
    Book *book=[self.donation.books objectAtIndex:indexPath.row];
    [self buildTableCell:cell withBook:book];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = cell.contentView.backgroundColor;
}

-(void) dealloc{
    [_donation release];
    [_donationStatusImage release];
    [_bookListTable release];
    [_postSpecificationView release];
    [_donationIDLabel release];
    [super dealloc];
}

@end
