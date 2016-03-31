//
//  YTAuthResultModel.m
//  YT_customer
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTAuthResultModel.h"

@implementation YTAuthResultPayOrder
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"orderId",
                                                       }];
}
@end
@implementation YTAuthResultExtras

@end
@implementation YTAuthResultSet

@end

@implementation YTAuthResultModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"authResultSet",
                                                       }];
}
@end
