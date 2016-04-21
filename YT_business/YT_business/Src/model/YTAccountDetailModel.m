//
//  YTAccountDetailModel.m
//  YT_business
//
//  Created by chun.chen on 15/7/24.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTAccountDetailModel.h"

@implementation YTAccountDetail
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"accountId" : @"id" };
}
@end
@implementation YTAccountDetailSet

@end
@implementation YTAccountDetailModel
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"accountDetailSet" : @"data" };
}
@end
