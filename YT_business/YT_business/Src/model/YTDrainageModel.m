//
//  YTDrainageModel.m
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTDrainageModel.h"

@implementation YTDrainage
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"drainageId":@"id"};
}
@end

@implementation YTDrainageSet

@end

@implementation YTDrainageModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"drainageSet":@"data"};
}
@end
