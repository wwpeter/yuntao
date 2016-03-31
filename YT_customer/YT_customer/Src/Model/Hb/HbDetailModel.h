//
//  HbDetailModel.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HbIntroModel.h"

@interface HbDetailModel : NSObject

@property (strong, nonatomic) NSNumber *hbId;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *qrCode;        // 二维码连接
@property (strong, nonatomic) NSString *hbName;        // 名称
@property (strong, nonatomic) NSString *cost;          // 价格
@property (strong, nonatomic) NSString *price;         // 价值
@property (strong, nonatomic) NSString *startTime;     // 开始时间
@property (strong, nonatomic) NSString *endTime;       // 失效时间
@property (strong, nonatomic) NSString *userStartTime; // 用户开始时间
@property (strong, nonatomic) NSString *userEndTime;   // 用户失效时间
@property (strong, nonatomic) NSString *describe;      // 描述
@property (strong, nonatomic) NSString *address;       // 地址
@property (strong, nonatomic) NSString *phoneNum;      // 商户电话
@property (strong, nonatomic) NSString *serialNumber;  // 序列号
@property (strong, nonatomic) NSString *shopName;       // 店铺名称
@property (strong, nonatomic) NSString *ruleDesc;       // 店铺规则

@property (strong, nonatomic) NSArray *rules;           // 规则
@property (strong, nonatomic) NSArray *stores;          // 优先投放商家

@property (assign, nonatomic) NSInteger stock;          // 库存
@property (assign, nonatomic) NSInteger amount;         // 红包数量
@property (assign, nonatomic) double longitude;          // 经度
@property (assign, nonatomic) double latitude;           // 纬度

@property (strong, nonatomic) NSString *moveState;      // 转让说明

// 红包状态
@property (assign, nonatomic) HbIntroModelStatus hbStatus;
@property (strong, nonatomic) NSString *hbStatusImageName;

- (instancetype)initWithHbDetailDictionary:(NSDictionary *)dictionary;

@end
