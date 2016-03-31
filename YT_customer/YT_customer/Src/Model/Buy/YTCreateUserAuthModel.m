//
//  YTCreateUserAuthModel.m
//  YT_customer
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTCreateUserAuthModel.h"
@implementation YTCreateUserAuthSet

@end

@implementation YTCreateUserAuthModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"userAuthSet",
                                                       }];
}
@end
