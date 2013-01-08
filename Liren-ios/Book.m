//
//  Book.m
//  Liren-ios
//
//  Created by Yan on 12/10/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//

#import "Book.h"

@implementation Book

-(void)dealloc{
    [_bookSN release];
    [_bookName release];
    [_bookStatus release];
    [super dealloc];
}

-(id)initWithDictionary:(NSDictionary*)book{
    self = [super init];
    if (self != nil) {
        self.bookSN = [book objectForKey:@"book_isbn"];
        self.bookName = [book objectForKey:@"book_name"];
        self.bookStatus = [book objectForKey:@"book_status"];
    }
    return self;
}

@end
