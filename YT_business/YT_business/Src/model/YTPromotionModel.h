//
//  YTPromotionModel.h
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTPromotionHongbao <NSObject>
@end

@interface YTPromotionHongbao : YTBaseModel
@property (nonatomic,assign) int num;
@property (nonatomic,assign) int yin;
@property (nonatomic,assign) int cost;
@property (nonatomic,assign) int ling;
@property (nonatomic,assign) int price;
@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int remainNum;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int totalPrice;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) int userConsume;
@property (nonatomic,copy) NSString *hongbaoId;
@property (nonatomic,copy) NSString *buyerShopId;
@property (nonatomic,copy) NSString *shopOrderId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,copy) NSString *promotionHongbaoId;
@property (nonatomic,assign) NSTimeInterval sellerShopEndTime;
@property (nonatomic,assign) NSTimeInterval sellerShopStartTime;
@property (nonatomic,strong) YTShop *shop;

- (NSMutableAttributedString *)remainNumStr;
- (NSMutableAttributedString *)releaseNumStr;
@end

@interface YTPromotionHongbaoSet : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTPromotionHongbao> *records;
@end

@interface YTPromotionModel : YTBaseModel
@property (nonatomic,strong) YTPromotionHongbaoSet *promotionHongbaoSet;
@end
