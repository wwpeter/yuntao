//
//  YTNoticeModel.m
//  YT_customer
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTNoticeModel.h"

@implementation YTNotice

+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id" : @"noticeId",
    }];
}
@end

@implementation YTNoticeSet

@end

@implementation YTNoticeModel
+ (JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"data" : @"noticeSet",
    }];
}
@end
