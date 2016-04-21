//
//  YTLoginModel.h
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@class YTCategory;
@class YTUpdateShopInfo;

#define usrDataKey  @"com.ytbussiness.UsrData"

@protocol YTShop <NSObject>
@end

@interface YTShop : YTBaseModel
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lon;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,assign) BOOL isGroup;
@property (nonatomic,assign) BOOL isHongbao;
@property (nonatomic,assign) BOOL isDiscount;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) float custFee;
@property (nonatomic,assign) CGFloat distance;
@property (nonatomic,assign) int cost;
@property (nonatomic,assign) int discount;
@property (nonatomic,assign) int promotion;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *qrcode;
@property (nonatomic,copy) NSString *shopHtmlUrl;
@property (nonatomic,copy) NSString *shopId;
@property (nonatomic,copy) NSString *catId;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *zoneId;
@property (nonatomic,copy) NSString *provinceString;
@property (nonatomic,copy) NSString *cityIdString;
@property (nonatomic,copy) NSString *areaIdString;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *openDays;
@property (nonatomic,assign) int defaultOnSale;
@property (nonatomic,copy) NSString *delStatus;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *saleUserId;
@property (nonatomic,copy) NSString *proxyUserId;
@property (nonatomic,copy) NSString *auditComment;
@property (nonatomic,assign)  int parkingSpace;
@property (nonatomic,copy) NSString *shopHongbaoRule;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,copy) NSString *receiveableHongbao;
@property (nonatomic,copy) NSString *fullSubtract;
@property (nonatomic,copy) NSString *curFullSubtract;
@property (nonatomic,assign) int promotionType;
@property (nonatomic,assign) BOOL didSelect;
- (NSAttributedString *)nameAttributeStr;
- (NSString *)userLocationDistance;
@end

@protocol YTImage <NSObject>
@end
@interface YTImage : YTBaseModel
@property (nonatomic,copy) NSString *imageId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,copy) NSString *insertUserId;
@property (nonatomic,copy) NSString *img;
@end


@protocol YTUsr <NSObject>
@end

@interface YTUsr : YTBaseModel
@property (nonatomic,strong) YTShop *shop;
@property (nonatomic,strong) NSArray<YTImage>*hjImg;
@property (nonatomic,strong) YTCategory*shopCategory;
/**
 *  5: 营业员   3: 商户
 */
@property (nonatomic,assign) int type;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *usrId;
@property (nonatomic,copy) NSString *payPwd;
@property (nonatomic,assign) int delStatus;
@property (nonatomic,copy) NSString *zoneId;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *inviteUserId;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,assign) NSTimeInterval createdAt;

+ (YTUsr *)usr;
- (void)doLoginOut;
- (void)updateUserShop:(YTUpdateShopInfo *)shopInfo;
@end

@interface YTLoginModel : YTBaseModel
@property (nonatomic,strong) YTUsr *usr;
@end
