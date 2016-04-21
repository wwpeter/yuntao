//
//  SingleHbModel.m
//  YT_business
//
//  Created by 郑海清 on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "SingleHbModel.h"

@implementation SingleHbModel



- (instancetype)initWithSingleHbDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.hbTitle = @"我勒个去";
        self.hbDetail = @"这里是描述";
        self.hbNum = [[NSNumber alloc]initWithInt:10];
        self.hbPrice = [[NSNumber alloc]initWithInt:12];
        self.hbValue = [[NSNumber alloc]initWithInt:10000];
        self.hbRemain  =[[NSNumber alloc]initWithInt:9];

        self.wantRefundNum = 0;
    }
    return self;
}


@end
