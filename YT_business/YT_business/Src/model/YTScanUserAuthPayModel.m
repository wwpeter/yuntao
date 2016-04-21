//
//  YTScanUserAuthPayModel.m
//  YT_business
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTScanUserAuthPayModel.h"

@implementation YTScanUserAuthPaySet

@end

@implementation YTScanUserAuthPayModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"userAuthPaySet":@"data"};
}
@end
