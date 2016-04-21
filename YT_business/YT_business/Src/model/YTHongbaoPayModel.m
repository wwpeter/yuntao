//
//  YTHongbaoPayModel.m
//  YT_business
//
//  Created by chun.chen on 15/7/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTHongbaoPayModel.h"

@implementation YTHongbaoPayShopOrder
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"shopOrderId":@"id"};
}
@end

@implementation YTHongbaoPaySet

@end

@implementation YTHongbaoPayModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"hongbaoPay":@"data"};
}
@end
