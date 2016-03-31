//
//  YTResultHbDetailModel.m
//  YT_customer
//
//  Created by chun.chen on 15/9/29.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTResultHbDetailModel.h"

@implementation YTResultHbDetail

@end

@implementation YTResultHbDetailModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"hbDetail",
                                                       }];
}
@end
