//
//  YTCityZoneModel.m
//  YT_customer
//
//  Created by chun.chen on 15/11/18.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTCityZoneModel.h"

@implementation YTZone
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"zongId"}];
}
@end

@implementation YTCityZoneModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"zone",
                                                       }];
}
@end
