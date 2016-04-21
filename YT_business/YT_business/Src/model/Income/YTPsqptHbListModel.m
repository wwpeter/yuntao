//
//  YTPsqptHbListModel.m
//  YT_business
//
//  Created by chun.chen on 15/12/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTPsqptHbListModel.h"

@implementation YTPsqptHb
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"pId":@"id"};
}
@end

@implementation YTPsqptHbSet

@end

@implementation YTPsqptHbListModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"psqptHbSet":@"data"};
}
@end
