//
//  YTPsqptHbListModel.m
//  YT_customer
//
//  Created by chun.chen on 15/12/11.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTPsqptHbListModel.h"

@implementation YTPsqptHb
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"pId"}];
}
@end

@implementation YTPsqptHbSet

@end

@implementation YTPsqptHbListModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"psqptHbSet"}];
}
@end
