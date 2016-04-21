
//
//  HbDetailModel.m
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "HbDetailModel.h"

@implementation HbDetailModel

- (instancetype)initWithHbDetailDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.hbName = @"名字名字名字的红包";
        self.cost = @"88";
        self.price = @"100";
        self.stock = 9999;
        self.startTime = @"2015.6.1";
        self.endTime = @"2015.8.8";
        self.address = @"西湖西湖西湖西湖西湖西湖西湖西湖西湖西湖西湖西湖";
        self.phoneNum = @"10086";
        self.describe = @"全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用全场通用";
        self.rules = @[@"规则一规则一规则一规则一规则一规则一规则一规则一规则一规则一规则一规则一",
                       @"规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二规则二",
                       @"规则三规则三规则三规则三规则三规则三规则三规则三规则三规则三规则三规则三",
                       @"规则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈则哈哈哈哈哈"];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
        self.stores = [[NSArray alloc] initWithArray:mutableArray];
    }
    return self;
}
@end
