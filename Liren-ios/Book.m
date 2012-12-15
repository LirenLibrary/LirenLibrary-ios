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
    [super dealloc];
}

@end
