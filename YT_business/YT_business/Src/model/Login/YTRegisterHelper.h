//
//  YTRegisterHelper.h
//  YT_business
//
//  Created by yandi on 15/6/23.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTRegisterHelper : YTBaseModel
@property (nonatomic,assign) double lon;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) long zoneId;
@property (nonatomic,copy) NSString *tel;
@property (nonatomic,assign) int custFee;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *saleUserId;
@property (nonatomic,copy) NSString *catId;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *district;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *upAddress;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *openDays;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *checkCode;
@property (nonatomic,assign) BOOL parkingSpace;
@property (nonatomic,strong) NSData *masterImg;
@property (nonatomic,strong) NSData *licenseImg;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,assign) BOOL showStretchOption;
@property (nonatomic,strong) NSMutableArray *hjImgArr;
@property (nonatomic,copy) NSString *legalPerson; /**< 对公账号*/
@property (nonatomic,copy) NSString *imgIdCardFront; /**< 身份证正面*/
@property (nonatomic,copy) NSString *imgIdCardBack; /**< 身份证反面*/
@property (nonatomic,copy) NSString *imgShopFront; /**< 门店正面图*/
@property (nonatomic,copy) NSString *imgShopInside; /**< 门店内景*/
@property (nonatomic,copy) NSString *imgDoorNo; /**< 门牌号*/
@property (nonatomic,copy) NSString *imgLicense; /**< 营业执照*/

+ (YTRegisterHelper *)registerHelper;
- (NSString *)cityZone;
- (void)cleanRegisterData;
- (BOOL)checkValidateWithStepIndex:(int)index;
@end
