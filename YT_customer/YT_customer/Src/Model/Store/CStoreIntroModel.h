//
//  CStoreIntroModel.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CStoreIntroModel : NSObject

@property(strong, nonatomic) NSNumber* storeId;
@property(strong, nonatomic) NSString* imageUrl;
@property(strong, nonatomic) NSString* storeName;        // 名称
@property(strong, nonatomic) NSString* cost;             // 价格
@property(strong, nonatomic) NSString* address;          // 地址
@property(strong, nonatomic) NSString* sort;             // 类型
@property(strong, nonatomic) NSString* curFullSubtract;  // 满减时间
@property(assign, nonatomic) NSInteger subtractFull;     //满
@property(assign, nonatomic) NSInteger subtractCur;      //减
@property(assign, nonatomic) NSInteger subtractMax;      // 最高
@property(strong, nonatomic) NSString* fullSubtract;     // 满减规则
@property(strong, nonatomic) NSArray* fullSubtracts;
@property(assign, nonatomic) BOOL conflictVer;   // 版本对比

@property(assign, nonatomic) NSInteger distance;  // 距离
@property(assign, nonatomic) NSInteger rank;      // 级别
@property(assign, nonatomic) NSInteger discount;  // 折扣
@property(assign, nonatomic)
    NSInteger promotionType;  // 促销类型 0：无，1：折扣；2：满减

@property(assign, nonatomic) CGFloat longitude;  // 经度
@property(assign, nonatomic) CGFloat latitude;   // 纬度

@property(assign, nonatomic) BOOL didSelect;  // 是否选择
@property(assign, nonatomic) BOOL isHongbao;  // 是否选择
@property(assign, nonatomic) BOOL isDiscount;
@property(assign, nonatomic) BOOL isPromotion;
@property(assign, nonatomic) NSInteger selectAtIndex;  // 被选择位置

@property(strong, nonatomic) NSString* costStr;
@property(strong, nonatomic) NSString* distanceStr;
@property(strong, nonatomic) NSAttributedString* nameAttributed;
@property(strong, nonatomic) NSAttributedString* discountAttributed;

- (instancetype)initWithStoreIntroDictionary:(NSDictionary*)dictionary;

@end
