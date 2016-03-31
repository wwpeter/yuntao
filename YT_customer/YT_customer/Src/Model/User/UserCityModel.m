//
//  UserCityModel.m
//  YT_customer
//
//  Created by chun.chen on 15/6/22.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "UserCityModel.h"

@implementation UserCityModel

- (instancetype)init
{
    if (self = [super init]) {
        self.province = @"浙江省";
        self.city = @"杭州市";
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
    }
    return self;
}

@end
