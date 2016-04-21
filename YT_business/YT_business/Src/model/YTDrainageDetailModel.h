//
//  YTDrainageDetailModel.h
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//


#import "YTLoginModel.h"
#import "YTTradeModel.h"

@protocol YTCommonShop <NSObject>
@end

@interface YTCommonShop : YTShop
@property (nonatomic,assign) int yin;
@property (nonatomic,assign) int tou;
@property (nonatomic,assign) int ling;

@property (nonatomic,copy) NSString *saleman;
@property (nonatomic,copy) NSString *byteImg;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *checkCode;
@property (nonatomic,copy) NSString *byteHjImg;
@property (nonatomic,copy) NSString *byteLicenseImg;
@end

@protocol YTCommonHongBao <NSObject>
@end
@interface YTCommonHongBao : YTHongBao
@property (nonatomic,assign) int num;
@property (nonatomic,assign) int tou;
@property (nonatomic,assign) int yin;
@property (nonatomic,assign) int ling;
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lon;
@property (nonatomic,assign) int price;
@property (nonatomic,assign) int delStatus;
@property (nonatomic,assign) int remainNum;
@property (nonatomic,assign) int wantRefundNum;
@property (nonatomic,copy) NSString *ruleId;
@property (nonatomic,assign) int createType;
@property (nonatomic,assign) float distance;
@property (nonatomic,assign) int hongbaoCode;
@property (nonatomic,copy) NSString *ruleDesc;
@property (nonatomic,copy) NSString *shopName;
@property (nonatomic,copy) NSString *creatorId;
@property (nonatomic,copy) NSString *saleUserId;
@property (nonatomic,copy) NSString *areaUserId;
@property (nonatomic,copy) NSString *cityUserId;
@property (nonatomic,copy) NSString *createName;
@property (nonatomic,copy) NSString *offComment;
@property (nonatomic,copy) NSString *userHongbao;
@property (nonatomic,copy) NSString *auditComment;
@property (nonatomic,assign) NSTimeInterval endTime;
@property (nonatomic,copy) NSString *provinceUserId;
@property (nonatomic,copy) NSString *sallerShopUserId;
@property (nonatomic,copy) NSString *buyerShopId;
@property (nonatomic,assign) NSTimeInterval startTime;
@property (nonatomic,copy) NSString *myScanUseHongbaoUrl;

@end

@interface YTDrainageDetail : YTBaseModel
@property (nonatomic,assign) int yinCount;
@property (nonatomic,assign) int touCount;
@property (nonatomic,assign) int lingCount;
@property (nonatomic,strong) YTCommonHongBao *hongbao;
@property (nonatomic,strong) NSArray<YTCommonShop> *shops;
@property (nonatomic,strong) NSArray<YTCommonShop> *recommendShop;
@end

@interface YTDrainageDetailModel : YTBaseModel
@property (nonatomic,strong) YTDrainageDetail *drainageDetail;
@end
