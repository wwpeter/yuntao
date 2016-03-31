//
//  ZHQMeUserInfoModel.m
//  YT_customer
//
//  Created by 郑海清 on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "ZHQMeUserInfoModel.h"

@implementation ZHQMeUserInfoModel


-(instancetype)initWithZHQMeUserInfoModelDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.userId = @0;
        self.userIconUrl = [NSURL URLWithString:@""];
        self.userNick = @"";
        self.userPhone = @0;
        self.isLogin = YES;
        self.password = @"";
    }
    return self;
}


@end
