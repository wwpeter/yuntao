//
//  YTOrderModel.m
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTOrderModel.h"

@implementation YTOrder
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"orderId":@"id"};
}
@end

@implementation YTOrderSet

@end

@implementation YTOrderModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"orderSet":@"data"};
}
@end
