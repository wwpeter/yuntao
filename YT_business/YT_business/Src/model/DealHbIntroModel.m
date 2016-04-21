
//
//  DealHbIntroModel.m
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "DealHbIntroModel.h"

@implementation DealHbIntroModel

- (instancetype)initWithDealHbIntroDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.hbId = @1000;
        self.hbName = @"名字名字名字的红包";
        self.describe = @"描述描述描述描述描述描述描述描述描述描述描述描述";
        self.cost = @"5";
        self.price = @"100";
        self.thanNum = 990;
        self.pastTimeStr = @"3天后过期";
    }
    return self;
}
@end
