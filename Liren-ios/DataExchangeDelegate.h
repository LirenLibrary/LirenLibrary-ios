//
//  DataExchangeDelegate.h
//  Liren-ios
//
//  Created by xuehai on 12/12/12.
//  Copyright (c) 2012 com.thoughtworks.liren. All rights reserved.
//
//  The delegate for the data exchange between view controllers
//

#import <Foundation/Foundation.h>

@protocol DataExchangeDelegate <NSObject>

-(void)putExchangedData:(NSObject *)dataObject;

@end
