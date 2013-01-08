//
//  Donation.m
//  Liren-ios
//
//  Created by xuehai on 12/26/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "Donation.h"

@implementation Donation

-(void)dealloc{
    [_donationID release];
    [_donationStatus release];
    [_donationTime release];
    [_bookCount release];
    [_postAddress release];
    [_postCode release];
    [_postReceiver release];
    [_postReceiverMobile release];
    [_books release];
    [super dealloc];
}

-(id) init{
    self = [super init];
    if(self != nil){
        if (self.books == nil) {
            NSMutableArray *tempBooks = [[NSMutableArray alloc]initWithCapacity:0];
            self.books = tempBooks;
            [tempBooks release];
        }
    }
    return self;
}

-(id) initWithJsonString:(NSData *)json {
    self  = [self init];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingAllowFragments error:nil];
    if(jsonData!=nil){
        self.donationID = [jsonData objectForKey:@"donation_id"];
        self.donationStatus = [jsonData objectForKey:@"donation_status"];
        self.postAddress = [jsonData objectForKey:@"post_address"];
        self.postReceiver = [jsonData objectForKey:@"post_receiver"];
        self.postCode = [jsonData objectForKey:@"post_code"];
        self.postReceiverMobile = [jsonData objectForKey:@"post_receiver_mobile"];
        
        NSArray *bookArray = [jsonData objectForKey:@"books"];
        for (NSDictionary *book in bookArray) {
            Book *theBook = [[Book alloc]initWithDictionary:book];
            [self.books addObject:theBook];
            [theBook release];
        }
    }
    
    return self;
}

@end
