//
//  ShopDetailModel.h
//  YT_customer
//
//  Created by chun.chen on 15/11/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubtractFullModel;
@class SubtractFullRule;
@class SubtractFullDes;

@interface ShopDetailModel : NSObject
@property(strong, nonatomic) NSNumber* shopId;           //商店ID
@property(strong, nonatomic) NSString* backImgUrl;       //背景图片
@property(strong, nonatomic) NSString* shopName;         //商铺名称
@property(strong, nonatomic) NSNumber* shopStyle;        //商铺状态
@property(strong, nonatomic) NSNumber* level;            //等级
@property(strong, nonatomic) NSNumber* equalPrice;       //人均消费
@property(strong, nonatomic) NSString* shopAddress;      //商铺地址
@property(strong, nonatomic) NSString* shopPhone;        //联系电话
@property(strong, nonatomic) NSString* startDate;        //开始时间
@property(strong, nonatomic) NSString* endDate;          //结束时间
@property(strong, nonatomic) NSString* shopHongbaoRule;  //红包规则
@property(strong, nonatomic) NSNumber* parking;

@property(assign, nonatomic) double longitude;  // 经度
@property(assign, nonatomic) double latitude;   // 纬度

@property(strong, nonatomic) NSArray* hjImages;            //图片列表
@property(strong, nonatomic) NSMutableArray* hbList;       //红包列表
@property(strong, nonatomic) NSArray* receiveableHongbao;  //红包列表
@property(strong, nonatomic) NSArray* userHongbaos;        //用户红包列表

@property(assign, nonatomic) BOOL subtractInTime;
@property(strong, nonatomic) NSString* curFullSubtract;        // 满减时间
@property(strong, nonatomic) NSString* fullSubRuleDesStr;      // 满减时间
@property(strong, nonatomic) SubtractFullRule* nowSubtract;    // 当前优惠
@property(strong, nonatomic) SubtractFullDes* fullSubRuleDes;  // 当前优惠
@property(assign, nonatomic) NSInteger subtractFull;           //满
@property(assign, nonatomic) NSInteger subtractCur;            //减
@property(assign, nonatomic) NSInteger subtractMax;            // 最高
@property(strong, nonatomic) NSString* fullSubtract;           // 满减规则
@property(strong, nonatomic) NSArray* fullSubtracts;           // 满减
@property(strong, nonatomic) NSArray* fullAllRules;  // 所有满减规则
@property(strong, nonatomic) NSArray* fullInDateRules;  // 所有满减规则
@property(assign, nonatomic) BOOL conflictVer;   // 版本对比

@property(assign, nonatomic) BOOL isDiscount;
@property(assign, nonatomic) BOOL isPromotion;
@property(assign, nonatomic) BOOL isHongbao;
@property(assign, nonatomic) NSInteger discount;  //商铺折扣
@property(assign, nonatomic) NSInteger status;
@property(assign, nonatomic) NSInteger promotionType;

@property(strong, nonatomic) NSAttributedString* nameAttributed;
@property(strong, nonatomic) NSAttributedString* subtractAttributed;
@property(strong, nonatomic) NSAttributedString* subtractTimeAttributed;

- (instancetype)initWithShopDetailDictionary:(NSDictionary*)dictionary;
- (void)validateFullSubtractTime;
@end
