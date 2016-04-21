//
//  DrainageIntroModel.m
//  YT_business
//
//  Created by chun.chen on 15/6/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "DrainageIntroModel.h"

@implementation DrainageIntroModel

- (instancetype)initWithDrainageIntroDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.hbId = @1;
        self.cost = @"88";

        self.throwsNum = 1111;
        self.pullNum = 1000;
        self.leadNum = 999;
        self.hbStatus = 0;
        self.costStr = [NSString stringWithFormat:@"￥%@",self.cost];
        self.statusStr = @"申请下架中";
    }
    return self;
}
@end
