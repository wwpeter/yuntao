//
//  YTAccountModel.m
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTAccountModel.h"

@implementation YTAccount

@end

@implementation YTAccountModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"account"}];
}
@end
