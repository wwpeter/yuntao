//
//  YTBuyHongbaoIndexModel.m
//  YT_business
//
//  Created by chun.chen on 15/8/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBuyHongbaoIndexModel.h"

@implementation YTBuyHongbaoIndeDetail

@end

@implementation YTBuyHongbaoIndexModel
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"indexDetail" : @"data" };
}
@end
