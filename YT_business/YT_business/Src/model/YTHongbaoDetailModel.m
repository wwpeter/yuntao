//
//  YTHongbaoDetailModel.m
//  YT_business
//
//  Created by chun.chen on 15/7/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTHongbaoDetailModel.h"
#import "YTTradeModel.h"

@implementation YTHongbaoDetailModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"hongbao":@"data"};
}
@end
