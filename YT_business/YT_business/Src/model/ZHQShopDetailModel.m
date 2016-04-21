//
//  ZHQShopDeatilModel.m
//  YT_business
//
//  Created by 郑海清 on 15/6/12.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "ZHQShopDetailModel.h"

@implementation ZHQShopDetailModel

-(instancetype)initWithShopDetailDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.shopName = @"有一个名字";
        self.shopStyle = @1;
        self.level = @1;
        self.equalPrice = @19999;
        self.shopAddress = @"在山的那边海的那边";
        self.shopPhone = @13778905689;
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
        self.parkMsg = @"停路中间就OK啦";
        self.hbList = [[NSMutableArray alloc]init];
        for (int i = 0; i < 3; i ++) {
            SingleHbModel *single = [[SingleHbModel alloc]initWithSingleHbDictionary:@{@"title":@"我勒个去",@"detail":@"这里是描述",@"unitPrice":@"12",@"quantity":@"12"}];
            [self.hbList addObject:single];
        }
    }
    return self;
}




@end
