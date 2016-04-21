//
//  OrderListModel.m
//  YT_business
//
//  Created by 郑海清 on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "OrderListModel.h"

@implementation OrderListModel



- (instancetype)initWithOrderListDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    if (self = [super init]) {
        self.shopName = @"酒坊禁酒公司";
        for (int i = 0; i < 3; i ++) {
            SingleHbModel *single = [[SingleHbModel alloc]initWithSingleHbDictionary:@{@"title":@"我勒个去",@"detail":@"这里是描述",@"unitPrice":@"12",@"quantity":@"12"}];
            [arr addObject:single];
        }
        
        self.hbList = arr;
        self.totalPrice = [[NSNumber alloc]initWithInt:1000];
        self.orderStatus = [[NSNumber alloc]initWithInt:1];
        self.hbNum = [[NSNumber alloc]initWithInt:100];
        self.dealDate = [NSDate date];
        self.creatDate = [NSDate date];
        self.closeDate = [NSDate date];
        self.applyRefundDate = [NSDate date];
        self.refundDate = [NSDate date];
        self.orderId = @1231231;
        self.payOrderId = @2378237918237;
        self.shopId = @123123;
    }
    return self;
}
@end
