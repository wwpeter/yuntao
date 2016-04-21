//
//  YTTradeRefundModel.m
//  YT_business
//
//  Created by chun.chen on 15/7/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTTradeRefundModel.h"

@implementation YTTradeRefundModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"trade":@"data"};
}
@end
