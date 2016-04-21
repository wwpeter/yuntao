//
//  YTQueryShopModel.m
//  YT_business
//
//  Created by chun.chen on 15/6/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTQueryShopModel.h"

@implementation YTQueryShopSet


@end

@implementation YTQueryShopModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"shopSet":@"data"};
}
@end
