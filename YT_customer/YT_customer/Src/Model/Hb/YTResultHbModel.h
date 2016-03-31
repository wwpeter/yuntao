//
//  YTResultHbModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/28.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTHbShopModel.h"

@protocol YTResultHongbao
@end

@interface YTResultHongbao : YTBaseModel
@property (nonatomic,strong) NSNumber *hongbaoId;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,assign) NSInteger yin;
@property (nonatomic,assign) NSInteger cost;
@property (nonatomic,assign) NSInteger ling;
@property (nonatomic,assign) NSInteger tou;
@property (nonatomic,assign) NSInteger price;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) CGFloat lon;
@property (nonatomic,assign) CGFloat lat;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger remainNum;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ruleDesc;
@property (nonatomic,assign) NSInteger totalPrice;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) NSInteger userConsume;
@property (nonatomic,copy) NSString *buyerShopId;
@property (nonatomic,copy) NSString *shopOrderId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,assign) NSTimeInterval startTime;
@property (nonatomic,assign) NSTimeInterval endTime;
@property (nonatomic,copy) NSString *promotionHongbaoId;
@property (nonatomic,assign) NSTimeInterval sellerShopEndTime;
@property (nonatomic,assign) NSTimeInterval sellerShopStartTime;
@property (nonatomic,strong) YTHbShopModel *shop;
- (NSString *)userLocationDistance;
@end

@interface YTResultHbSet : YTBaseModel
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) NSArray<YTResultHongbao> *records;
@end

@interface YTResultHbModel : YTBaseModel
@property (nonatomic,strong) YTResultHbSet *resultHbSet;
@end
