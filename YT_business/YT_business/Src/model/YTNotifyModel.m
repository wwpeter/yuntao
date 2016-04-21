//
//  YTNotifyModel.m
//  YT_business
//
//  Created by chun.chen on 15/7/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTNotifyModel.h"

@implementation YTNotifyMessage
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"notifyId":@"id",
             @"notifyMessage":@"message"};
}
@end
@implementation YTNotifySet

@end
@implementation YTNotifyModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"notifySet":@"data"};
}
@end
