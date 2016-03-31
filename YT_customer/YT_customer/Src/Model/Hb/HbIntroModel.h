//
//  HbIntroModel.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HbIntroModelStatus) {
    // 未使用
    HbIntroModelStatusUnuse = 1,
    // 已使用
    HbIntroModelStatusUsed = 2,
    // 已过期
    HbIntroModelStatusExpired = 3,
    // 已关闭
    HbIntroModelStatusClosed = 4,
    // 已转赠
    HbIntroModelStatusDonated = 5
};
@interface HbIntroModel : NSObject

@property (strong, nonatomic) NSNumber *hbId;
@property (strong, nonatomic) NSNumber *hongbaoId;
@property (strong, nonatomic) NSString *imageUrl;
// 名称
@property (strong, nonatomic) NSString *hbName;
// 店铺名称
@property (strong, nonatomic) NSString *shopName;
// 描述
@property (strong, nonatomic) NSString *describe;
// 红包价格
@property (strong, nonatomic) NSString *price;
// 价值
@property (strong, nonatomic) NSString *cost;

// 用户使用失效时间
@property (strong, nonatomic) NSDate *userUseEndDate;
@property (strong, nonatomic) NSString *userUseEndDateStr;

// 红包状态
@property (assign, nonatomic) HbIntroModelStatus hbStatus;
@property (strong, nonatomic) NSString *hbStatusImageName;
// 剩余
@property (assign, nonatomic) NSInteger thanNum;

// 是否选择
@property (assign, nonatomic) BOOL  didSelect;

@property (assign, nonatomic) BOOL isUserHB;


- (instancetype)initWithHbIntroDictionary:(NSDictionary *)dictionary;
@end
