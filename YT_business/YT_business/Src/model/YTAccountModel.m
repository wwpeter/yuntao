//
//  YTAccountModel.m
//  YT_business
//
//  Created by chun.chen on 15/7/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTAccountModel.h"

@implementation YTAccount

@end

@implementation YTAccountModel

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"account":@"data"};
}
@end
