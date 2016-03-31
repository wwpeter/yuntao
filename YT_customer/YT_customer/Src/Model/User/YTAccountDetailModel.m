//
//  YTAccountDetailModel.m
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTAccountDetailModel.h"
@implementation YTAccountDetail
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"accountId"}];
}
@end
@implementation YTAccountDetailSet

@end

@implementation YTAccountDetailModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"accountDetailSet"}];
}
@end
