//
//  YTActivityModel.m
//  YT_customer
//
//  Created by chun.chen on 15/9/29.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTActivityModel.h"

@implementation YTActivity
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"activityId",
                                                       }];
}
@end

@implementation YTActivityModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"activites",
                                                       }];
}
@end
