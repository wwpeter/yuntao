//
//  YTRegisterHelper.m
//  YT_business
//
//  Created by yandi on 15/6/23.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTRegisterHelper.h"

@implementation YTRegisterHelper
static YTRegisterHelper *helper;
+ (YTRegisterHelper *)registerHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YTRegisterHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        _showStretchOption = YES;
        _openDays = @"周一,周二,周三,周四,周五,周六,周日";
        _startTime = @"9:00";
        _endTime = @"20:00";
    }
    return self;
}
- (NSString *)province
{
    if (_province.length == 0) {
        return @"浙江省";
    }
    return _province;
}
- (NSString *)city
{
    if (_city.length == 0) {
        return @"杭州市";
    }
    return _city;
}
- (NSString *)district
{
    if (_district.length == 0) {
        return @"西湖区";
    }
    return _district;
}
- (NSString *)address
{
    if (_address.length == 0) {
        return @"";
    }
    return _address;
}
- (long)zoneId
{
    if (_zoneId == 0) {
        return 1303;
    }
    return _zoneId;
}
- (NSString *)categoryName {
    if (_categoryName.length == 0) {
        return @"请选择分类";
    }
    return _categoryName;
}
- (NSString *)legalPerson
{
    if (_legalPerson.length == 0) {
        return @"";
    }
    return _legalPerson;
}
- (NSString *)imgIdCardFront
{
    if (_imgIdCardFront.length == 0) {
        return @"";
    }
    return _imgIdCardFront;
}
- (NSString *)imgIdCardBack
{
    if (_imgIdCardBack.length == 0) {
        return @"";
    }
    return _imgIdCardBack;
}
- (NSString *)imgShopFront
{
    if (_imgShopFront.length == 0) {
        return @"";
    }
    return _imgShopFront;
}
- (NSString *)imgShopInside
{
    if (_imgShopInside.length == 0) {
        return @"";
    }
    return _imgShopInside;
}
- (NSString *)imgDoorNo
{
    if (_imgDoorNo.length == 0) {
        return @"";
    }
    return _imgDoorNo;
}
- (NSString *)imgLicense
{
    if (_imgLicense.length == 0) {
        return @"";
    }
    return _imgLicense;
}

- (BOOL)checkValidateWithStepIndex:(int)index {
    NSString *alertStr = @"";
    if (index == 0) {
        if ([NSStrUtil isEmptyOrNull:self.name]) {
            alertStr = @"请填写店铺名字";
            [self showInvalideAlertWithAlertStr:alertStr];
            return NO;
        } else if ([NSStrUtil isEmptyOrNull:self.address]) {
            alertStr = @"请填写店铺地址";
            [self showInvalideAlertWithAlertStr:alertStr];
            return NO;
        } else if (self.catId.length == 0) {
            alertStr = @"请选择店铺分类";
            [self showInvalideAlertWithAlertStr:alertStr];
            return NO;
        }
    } else if (index == 1) {
        if ([NSStrUtil isEmptyOrNull:self.imgLicense]) {
            alertStr = @"请上传营业执照";
            [self showInvalideAlertWithAlertStr:alertStr];
            return NO;
        }
    } else if (index == 2) {
        
    }
    return YES;
}
- (void)cleanRegisterData
{
    self.tel = @"";
    self.custFee = 0;
    self.name = @"";
    self.catId = @"";
    self.mobile = @"";
    self.province = @"";
    self.city = @"";
    self.district = @"";
    self.zoneId = 0;
    self.address = @"";
    self.endTime = @"";
    self.password = @"";
    self.openDays = @"";
    self.startTime = @"";
    self.checkCode = @"";
    self.masterImg = nil;
    self.licenseImg = nil;
    self.categoryName = @"";
    [self.hjImgArr removeAllObjects];
}
- (NSString *)cityZone
{
    return self.address;
//    if ([self.city isEqualToString:@"县"] || [self.city isEqualToString:@"市辖区"]) {
//        return [NSString stringWithFormat:@"%@ %@",self.province,self.district];
//    }
//    return [NSString stringWithFormat:@"%@ %@",self.city,self.district];
    
}
#pragma mark -showInvalideAlertWithAlertStr
- (void)showInvalideAlertWithAlertStr:(NSString *)alertStr {
    [[[UIAlertView alloc] initWithTitle:@"提示" message:alertStr delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
}
@end
