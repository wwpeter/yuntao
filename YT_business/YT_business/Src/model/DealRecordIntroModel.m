//
//  DealRecordIntroModel.m
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "DealRecordIntroModel.h"

@implementation DealRecordIntroModel

- (instancetype)initWithDealRecordIntroDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.dealId = @1;
        self.dealName = @"张三";
        self.orderCode = @"12312412";
        self.dealTime = @"2015-12-12 12:12";
        self.price = @"1089";
        self.payStr = @"当面付款";
    }
    return self;
}
@end
