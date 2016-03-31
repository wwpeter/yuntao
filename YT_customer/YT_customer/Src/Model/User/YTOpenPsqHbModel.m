//
//  YTOpenPsqHbModel.m
//  YT_customer
//
//  Created by chun.chen on 15/12/11.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTOpenPsqHbModel.h"

@implementation YTOpenPsqHb

@end

@implementation YTOpenPsqHbModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"openPsqHb"}];
}
@end
