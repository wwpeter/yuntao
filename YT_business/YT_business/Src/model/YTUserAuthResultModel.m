//
//  YTUserAuthResultModel.m
//  YT_business
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTUserAuthResultModel.h"

@implementation YTUserAuthResultPayOrder
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"orderId":@"id"};
}
@end
@implementation YTUserAuthResultExtras

@end
@implementation YTUserAuthResultSet

@end

@implementation YTUserAuthResultModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"authResultSet":@"data"};
}
@end
