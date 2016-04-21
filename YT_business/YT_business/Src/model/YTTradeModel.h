//
//  YTTradeModel.h
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTLoginModel.h"

@protocol YTHongBao <NSObject>
@end

@class YTUsrHongBao;
@interface YTHongBao : YTBaseModel
@property (nonatomic,assign) int cost;
@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *indexId;
@property (nonatomic,copy) NSString *sourceId;
@property (nonatomic,copy) NSString *hongbaoId;
@property (nonatomic,strong) YTUsrHongBao *hongbao;
@property (nonatomic,strong) YTShop *shop;
@property (nonatomic,copy) NSString *shopHongbaoId;
@property (nonatomic,copy) NSString *buyerShopUserId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,assign) NSTimeInterval userUseEndTime;
@property (nonatomic,assign) NSTimeInterval userUseStartTime;
@property (nonatomic,assign) NSTimeInterval sellerShopUseEndTime;
@property (nonatomic,assign) NSTimeInterval sellerShopUseStartTime;
@end

@protocol YTUsrHongBao <NSObject>
@end
@interface YTUsrHongBao : YTBaseModel
@property (nonatomic,assign) int num;
@property (nonatomic,assign) int tou;
@property (nonatomic,assign) int yin;
@property (nonatomic,assign) int cost;
@property (nonatomic,assign) int ling;
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lon;
@property (nonatomic,assign) int price;
@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) YTShop *shop;
@property (nonatomic,assign) int delStatus;
@property (nonatomic,assign) int remainNum;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *ruleId;
@property (nonatomic,assign) int createType;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *indexId;
@property (nonatomic,assign) float distance;
@property (nonatomic,copy) NSString *hongbao;
@property (nonatomic,assign) int hongbaoCode;
@property (nonatomic,copy) NSString *ruleDesc;
@property (nonatomic,copy) NSString *shopName;
@property (nonatomic,copy) NSString *sourceId;
@property (nonatomic,copy) NSString *creatorId;
@property (nonatomic,copy) NSString *hongbaoId;
@property (nonatomic,copy) NSString *saleUserId;
@property (nonatomic,copy) NSString *areaUserId;
@property (nonatomic,copy) NSString *cityUserId;
@property (nonatomic,copy) NSString *createName;
@property (nonatomic,copy) NSString *offComment;
@property (nonatomic,copy) NSString *userHongbao;
@property (nonatomic,copy) NSString *auditComment;
@property (nonatomic,copy) NSString *shopHongbaoId;
@property (nonatomic,assign) NSTimeInterval endTime;
@property (nonatomic,copy) NSString *provinceUserId;
@property (nonatomic,copy) NSString *buyerShopUserId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,copy) NSString *sellerShopUserId;
@property (nonatomic,assign) NSTimeInterval startTime;
@property (nonatomic,copy) NSString *myScanUseHongbaoUrl;
@property (nonatomic,assign) NSTimeInterval userUseEndTime;
@property (nonatomic,assign) NSTimeInterval userUseStartTime;
@property (nonatomic,assign) NSTimeInterval sellerShopUseEndTime;
@property (nonatomic,assign) NSTimeInterval sellerShopUseStartTime;

@property (nonatomic,strong) NSNumber *buyNum;

- (NSMutableAttributedString *)costAttributeStr;

@end


@interface YTCommonUser : YTBaseModel
@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *shop;
@property (nonatomic,assign) int delStatus;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *zoneId;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *inviteUserId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@end

@protocol YTTrade <NSObject>

@end

@interface YTTrade : YTBaseModel
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int payType;
@property (nonatomic,assign) int payChannel;
@property (nonatomic,copy) NSString *shop;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *shopId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) int isRefund;
@property (nonatomic,assign) int totalPrice;
@property (nonatomic,assign) int originPrice;
@property (nonatomic,assign) int inCome;
@property (nonatomic,assign) int shopCashbackAmount;
@property (nonatomic,assign) int shouxvfei;
@property (nonatomic, assign) int subsidyAmount;
@property (nonatomic,assign) CGFloat promotion;
@property (nonatomic,copy) NSString *tradeId;
@property (nonatomic,copy) NSString *trademessage;
@property (nonatomic,assign) int receiveStatus;
@property (nonatomic,copy) NSString *toOuterId;
@property (nonatomic,copy) NSString *shopUserId;
@property (nonatomic,strong) YTCommonUser *user;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,strong) NSArray<YTHongBao> *userHongbaos;

- (CGFloat )promotionTotalPrice;
@end

@interface YTTradeSet : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTTrade> *records;
@end

@interface YTTradeModel : YTBaseModel
@property (nonatomic,strong) YTTradeSet *tradeSet;
@end
