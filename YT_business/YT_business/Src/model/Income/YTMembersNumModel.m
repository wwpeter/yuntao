//
//  YTMembersNumModel.m
//  YT_business
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTMembersNumModel.h"

@implementation YTMembersNum

@end

@implementation YTMembersNumModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"members":@"data"};
}
@end
