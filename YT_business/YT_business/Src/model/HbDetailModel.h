//
//  HbDetailModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HbDetailModel : NSObject

@property (strong, nonatomic) NSNumber *hbId;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *hbName;        // 名称
@property (strong, nonatomic) NSString *cost;          // 价格
@property (strong, nonatomic) NSString *price;         // 价值
@property (assign, nonatomic) NSInteger stock;         // 库存
@property (strong, nonatomic) NSString *startTime;     // 开始时间
@property (strong, nonatomic) NSString *endTime;       // 失效时间
@property (strong, nonatomic) NSString *describe;      // 描述
@property (strong, nonatomic) NSString *address;       // 地址
@property (strong, nonatomic) NSString *phoneNum;      // 商户电话

@property (strong, nonatomic) NSArray *rules;           // 规则
@property (strong, nonatomic) NSArray *stores;          // 优先投放商家

@property (assign, nonatomic) NSInteger amount;         // 红包数量
@property (assign, nonatomic) NSInteger hbStatus;       // 红包状态

- (instancetype)initWithHbDetailDictionary:(NSDictionary *)dictionary;

@end
