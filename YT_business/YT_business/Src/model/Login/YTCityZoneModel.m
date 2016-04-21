//
//  YTCityZoneModel.m
//  YT_business
//
//  Created by chun.chen on 15/11/17.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTCityZoneModel.h"


@implementation YTZone
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"zongId":@"id"};
}

@end

@implementation YTCityZoneModel


- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"zone":@"data"};
}
@end
