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
        self.bookSN = [book objectForKey:@"ISBN"];
        self.bookName = [book objectForKey:@"title"];
        self.bookStatus = [book objectForKey:@"status"];
    }
    return self;
}

@end
