//
//  SingleHbModel.m
//  YT_business
//
//  Created by 郑海清 on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "SingleHbModel.h"
#import "HbDetailModel.h"

@implementation SingleHbModel



- (instancetype)initWithSingleHbDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.hbId = dictionary[@"hongbaoId"];
        self.hbTitle = dictionary[@"name"];
        self.hbDetail = dictionary[@"title"];
        self.hbNum = dictionary[@"num"];
        self.hbPrice = dictionary[@"price"];
        self.hbValue = dictionary[@"cost"];
        self.imageUrl = dictionary[@"img"];
        self.hbRemain  = dictionary[@"remainNum"];
        self.shopName = dictionary[@"shop"][@"name"];
        self.wantRefundNum = 0;
        self.hbDetailModel = [[HbDetailModel alloc]initWithHbDetailDictionary:dictionary];
    }
    return self;
}


@end
