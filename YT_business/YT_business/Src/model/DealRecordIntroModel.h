//
//  DealRecordIntroModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealRecordIntroModel : NSObject

@property (strong, nonatomic) NSNumber *dealId;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *dealName;        // 名称
@property (strong, nonatomic) NSString *orderCode;       // 订单号
@property (strong, nonatomic) NSString *dealTime;       // 订单号
@property (strong, nonatomic) NSString *price;           // 支付金额

@property (assign, nonatomic) NSInteger payType;         // 红包状态

@property (strong, nonatomic) NSString  *payStr;

- (instancetype)initWithDealRecordIntroDictionary:(NSDictionary *)dictionary;
@end
