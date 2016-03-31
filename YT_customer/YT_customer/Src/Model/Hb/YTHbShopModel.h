//
//  YTHbShopModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/28.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"
@protocol YTHbShopModel
@end

@interface YTHbShopModel : YTBaseModel
@property (nonatomic,strong) NSNumber *shopId;
@property (nonatomic,assign) CGFloat lat;
@property (nonatomic,assign) CGFloat lon;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,assign) BOOL isGroup;
@property (nonatomic,assign) BOOL isHongbao;
@property (nonatomic,assign) BOOL isDiscount;
@property (nonatomic,assign) BOOL conflictVer;   // 版本对比
@property (nonatomic,assign) NSInteger promotionType;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *catId;
@property (nonatomic,copy) NSString *catName;
@property (nonatomic,assign) CGFloat custFee;
@property (nonatomic,assign) CGFloat distance;
@property (nonatomic,assign) NSInteger cost;
@property (nonatomic,assign) NSInteger discount;
@property (nonatomic,assign) NSInteger promotion;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *qrcode;
@property (nonatomic,copy) NSString *shopHtmlUrl;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *zoneId;
@property (nonatomic,copy) NSString *provinceString;
@property (nonatomic,copy) NSString *cityIdString;
@property (nonatomic,copy) NSString *areaIdString;
@property (nonatomic,copy) NSString *zoneText;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *openDays;
@property (nonatomic,assign) NSInteger defaultOnSale;
@property (nonatomic,copy) NSString *delStatus;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *saleUserId;
@property (nonatomic,copy) NSString *proxyUserId;
@property (nonatomic,copy) NSString *auditComment;
@property (nonatomic,assign)  NSInteger parkingSpace;
@property (nonatomic,copy) NSString *shopHongbaoRule;
@property (nonatomic,copy) NSString *fullSubtract;    /**< 满减*/
@property (nonatomic,copy) NSString *curFullSubtract; /**< 当前满减*/
@property (nonatomic,assign) NSInteger subtractFull;     //满
@property (nonatomic,assign) NSInteger subtractCur;      //减
@property (nonatomic,assign) NSInteger subtractMax;      // 最高
@property (nonatomic,assign) BOOL isSubtract;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;

- (NSAttributedString *)nameAttributeStr;
- (NSAttributedString *)discountAttributed;
- (NSString *)userLocationDistance;
@end
