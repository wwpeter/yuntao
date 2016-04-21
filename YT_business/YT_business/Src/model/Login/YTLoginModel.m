//
//  YTLoginModel.m
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTLoginModel.h"
#import "YTCategoryModel.h"
#import "YTUpdateShopInfoModel.h"
#import "UserMationMange.h"

@implementation YTImage
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"imageId" : @"id" };
}
#pragma mark -NSCoding
- (id)initWithCoder:(NSCoder*)aDecoder
{
    [self setImageId:[aDecoder decodeObjectForKey:@"imageId"]];
    [self setCreatedAt:[aDecoder decodeDoubleForKey:@"createdAt"]];
    [self setUpdatedAt:[aDecoder decodeDoubleForKey:@"updatedAt"]];
    [self setInsertUserId:[aDecoder decodeObjectForKey:@"insertUserId"]];
    [self setImg:[aDecoder decodeObjectForKey:@"img"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.imageId forKey:@"imageId"];
    [aCoder encodeDouble:self.createdAt forKey:@"createdAt"];
    [aCoder encodeDouble:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:self.insertUserId forKey:@"insertUserId"];
    [aCoder encodeObject:self.img forKey:@"img"];
}
@end

@implementation YTShop
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"shopId" : @"id" };
}
#pragma mark -NSCoding
- (id)initWithCoder:(NSCoder*)aDecoder
{
    [self setImg:[aDecoder decodeObjectForKey:@"img"]];
    [self setCode:[aDecoder decodeObjectForKey:@"code"]];
    [self setIsGroup:[aDecoder decodeBoolForKey:@"isGroup"]];
    [self setIsHongbao:[aDecoder decodeBoolForKey:@"isHongbao"]];
    [self setIsDiscount:[aDecoder decodeBoolForKey:@"isDiscount"]];
    [self setName:[aDecoder decodeObjectForKey:@"name"]];
    [self setQrcode:[aDecoder decodeObjectForKey:@"qrcode"]];
    [self setCustFee:[aDecoder decodeFloatForKey:@"custFee"]];
    [self setDistance:[aDecoder decodeFloatForKey:@"distance"]];
    [self setCost:[aDecoder decodeIntForKey:@"discount"]];
    [self setDiscount:[aDecoder decodeIntForKey:@"cost"]];
    [self setTitle:[aDecoder decodeObjectForKey:@"title"]];
    [self setShopId:[aDecoder decodeObjectForKey:@"shopId"]];
    [self setMobile:[aDecoder decodeObjectForKey:@"mobile"]];
    [self setStatus:[aDecoder decodeIntegerForKey:@"status"]];
    [self setUserId:[aDecoder decodeObjectForKey:@"userId"]];
    [self setZoneId:[aDecoder decodeObjectForKey:@"zoneId"]];
    [self setProvinceString:[aDecoder decodeObjectForKey:@"provinceString"]];
    [self setCityIdString:[aDecoder decodeObjectForKey:@"cityIdString"]];
    [self setAreaIdString:[aDecoder decodeObjectForKey:@"areaIdString"]];
    [self setAddress:[aDecoder decodeObjectForKey:@"address"]];
    [self setEndTime:[aDecoder decodeObjectForKey:@"endTime"]];
    [self setOpenDays:[aDecoder decodeObjectForKey:@"openDays"]];
    [self setDelStatus:[aDecoder decodeObjectForKey:@"delStatus"]];
    [self setStartTime:[aDecoder decodeObjectForKey:@"startTime"]];
    [self setSaleUserId:[aDecoder decodeObjectForKey:@"saleUserId"]];
    [self setProxyUserId:[aDecoder decodeObjectForKey:@"proxyUserId"]];
    [self setAuditComment:[aDecoder decodeObjectForKey:@"auditComment"]];
    [self setParkingSpace:[aDecoder decodeIntForKey:@"parkingSpace"]];
    [self setShopHongbaoRule:[aDecoder decodeObjectForKey:@"shopHongbaoRule"]];
    [self setUpdatedAt:[aDecoder decodeFloatForKey:@"updatedAt"]];
    [self setCreatedAt:[aDecoder decodeFloatForKey:@"createdAT"]];
    [self setFullSubtract:[aDecoder decodeObjectForKey:@"fullSubtract"]];
    [self setCurFullSubtract:[aDecoder decodeObjectForKey:@"curFullSubtract"]];
    [self setPromotionType:[aDecoder decodeIntForKey:@"promotionType"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.img forKey:@"img"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeBool:self.isGroup forKey:@"isGroup"];
    [aCoder encodeBool:self.isHongbao forKey:@"isHongbao"];
    [aCoder encodeBool:self.isDiscount forKey:@"isDiscount"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.qrcode forKey:@"qrcode"];
    [aCoder encodeFloat:self.custFee forKey:@"custFee"];
    [aCoder encodeFloat:self.distance forKey:@"distance"];
    [aCoder encodeInt:self.cost forKey:@"cost"];
    [aCoder encodeInt:self.discount forKey:@"discount"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.shopId forKey:@"shopId"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeInteger:self.status forKey:@"status"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.zoneId forKey:@"zoneId"];
    [aCoder encodeObject:self.provinceString forKey:@"provinceString"];
    [aCoder encodeObject:self.cityIdString forKey:@"cityIdString"];
    [aCoder encodeObject:self.areaIdString forKey:@"areaIdString"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.endTime forKey:@"endTime"];
    [aCoder encodeObject:self.openDays forKey:@"openDays"];
    [aCoder encodeObject:self.delStatus forKey:@"delStatus"];
    [aCoder encodeObject:self.startTime forKey:@"startTime"];
    [aCoder encodeObject:self.saleUserId forKey:@"saleUserId"];
    [aCoder encodeObject:self.proxyUserId forKey:@"proxyUserId"];
    [aCoder encodeObject:self.auditComment forKey:@"auditComment"];
    [aCoder encodeInt:self.parkingSpace forKey:@"parkingSpace"];
    [aCoder encodeObject:self.shopHongbaoRule forKey:@"shopHongbaoRule"];
    [aCoder encodeFloat:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:self.fullSubtract forKey:@"fullSubtract"];
     [aCoder encodeObject:self.curFullSubtract forKey:@"curFullSubtract"];
     [aCoder encodeInt:self.promotionType forKey:@"promotionType"];
}
- (NSAttributedString*)nameAttributeStr
{
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:self.name];
    if (self.isHongbao) {
        UIImage* redImage = [UIImage imageNamed:@"yt_hongIcon.png"];
        NSTextAttachment* redAttachment = [[NSTextAttachment alloc] init];
        redAttachment.image = redImage;
        redAttachment.bounds = CGRectMake(10, -2, redImage.size.width, redImage.size.height);
        NSAttributedString* redAttachmentString = [NSAttributedString attributedStringWithAttachment:redAttachment];
        [attString appendAttributedString:redAttachmentString];
    }
    if (self.isDiscount) {
        UIImage* foldImage = [UIImage imageNamed:@"yt_zheIcon.png"];
        NSTextAttachment* foldAttachment = [[NSTextAttachment alloc] init];
        foldAttachment.image = foldImage;
        foldAttachment.bounds = CGRectMake(15, -2, foldImage.size.width, foldImage.size.height);
        NSAttributedString* foldpAttachmentString = [NSAttributedString attributedStringWithAttachment:foldAttachment];
        [attString appendAttributedString:foldpAttachmentString];
    }
    return [[NSAttributedString alloc] initWithAttributedString:attString];
}
- (NSString *)userLocationDistance
{
    //第一个坐标
    CLLocation* current = [UserMationMange sharedInstance].userLocation;
    NSString* distanceStr = @"";
    if (self.lat != 0 && current.coordinate.latitude != 0) {
        //第二个坐标
        CLLocation* before = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lon];
        // 计算距离
        CLLocationDistance meters = [current distanceFromLocation:before];
        if (meters > 0) {
            if (meters > 100) {
                CGFloat distance = meters / 1000;
                if (distance > 9999) {
                    distanceStr = @">9999km";
                }
                else {
                    distanceStr = [NSString stringWithFormat:@"%.2fkm", distance];
                }
            }
            else {
                distanceStr = [NSString stringWithFormat:@"%.2fm", meters];
            }
        }
        self.distance = meters;
    }
    else {
        self.distance = 0;
    }
    return distanceStr;
}
@end

@interface YTUsr () <NSCoding>

@end

@implementation YTUsr
static YTUsr* usr;

- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"usrId" : @"id" ,
              @"shopCategory" : @"shopcat"};
}
#pragma mark +usr
+ (YTUsr*)usr
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        usr = [[YTUsr alloc] init];
    });
    return usr;
}

#pragma mark -init
- (instancetype)init
{
    if (self = [super init]) {
        NSData* usrData = [USERDEFAULT dataForKey:usrDataKey];
        if (usrData) {
            self = [NSKeyedUnarchiver unarchiveObjectWithData:usrData];
            if ([NSStrUtil isEmptyOrNull:self.userName]) {
                self.userName = @"";
            }
        }
    }
    return self;
}
#pragma mark -update
- (void)updateUserShop:(YTUpdateShopInfo *)shopInfo
{
    usr.shop = shopInfo.shop;
    usr.shopCategory = shopInfo.shopCategory;
    usr.hjImg = shopInfo.hjImg;
    [self archiveUsrData];
}
#pragma mark -doLoginOut
- (void)doLoginOut
{
    usr.type = 0;
    usr.path = @"";
    usr.usrId = @"";
    usr.zoneId = @"";
    usr.avatar = @"";
    usr.source = @"";
    usr.mobile = @"";
    usr.delStatus = 0;
    usr.updatedAt = 0;
    usr.createdAt = 0;
    usr.userName = @"";
    usr.parentId = @"";
    usr.password = @"";
    usr.inviteUserId = @"";

    // remove UsrData
    [USERDEFAULT removeObjectForKey:usrDataKey];
    [USERDEFAULT removeObjectForKey:iYTUserSelectBankDateKey];
    [USERDEFAULT synchronize];

    // removeCookie
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in cookieStorage.cookies) {
        [cookieStorage deleteCookie:cookie];
    }
}

#pragma mark -NSCoding
- (id)initWithCoder:(NSCoder*)aDecoder
{
    [self setType:[aDecoder decodeIntForKey:@"type"]];
    [self setPath:[aDecoder decodeObjectForKey:@"path"]];
    [self setUsrId:[aDecoder decodeObjectForKey:@"usrId"]];
    [self setPayPwd:[aDecoder decodeObjectForKey:@"payPwd"]];
    [self setZoneId:[aDecoder decodeObjectForKey:@"zoneId"]];
    [self setAvatar:[aDecoder decodeObjectForKey:@"avatar"]];
    [self setSource:[aDecoder decodeObjectForKey:@"source"]];
    [self setMobile:[aDecoder decodeObjectForKey:@"mobile"]];
    [self setDelStatus:[aDecoder decodeIntForKey:@"delStatus"]];
    [self setUserName:[aDecoder decodeObjectForKey:@"userName"]];
    [self setParentId:[aDecoder decodeObjectForKey:@"parentId"]];
    [self setPassword:[aDecoder decodeObjectForKey:@"password"]];
    [self setUpdatedAt:[aDecoder decodeFloatForKey:@"updatedAt"]];
    [self setCreatedAt:[aDecoder decodeFloatForKey:@"createdAT"]];
    [self setInviteUserId:[aDecoder decodeObjectForKey:@"inviteUserId"]];
    [self setShop:[aDecoder decodeObjectForKey:@"shop"]];
    [self setHjImg:[aDecoder decodeObjectForKey:@"hjImg"]];
    [self setShopCategory:[aDecoder decodeObjectForKey:@"shopCategory"]];

    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeInt:self.type forKey:@"type"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.payPwd forKey:@"payPwd"];
    [aCoder encodeObject:self.usrId forKey:@"usrId"];
    [aCoder encodeObject:self.zoneId forKey:@"zoneId"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.source forKey:@"source"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeInt:self.delStatus forKey:@"delStatus"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.parentId forKey:@"parentId"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeFloat:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeFloat:self.createdAt forKey:@"createdAt"];
    [aCoder encodeObject:self.inviteUserId forKey:@"inviteUserId"];
    [aCoder encodeObject:self.shop forKey:@"shop"];
    [aCoder encodeObject:self.hjImg forKey:@"hjImg"];
    [aCoder encodeObject:self.shopCategory forKey:@"shopCategory"];
}

#pragma mark -override
- (instancetype)initWithJSONDict:(NSDictionary*)dict
{
    self = [self.class usr];
    if (self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self performSelector:@selector(injectJSONData:)
                   withObject:dict];
#pragma clang diagnostic pop
        [self archiveUsrData];
    }
    return self;
}

#pragma mark -archiveUsrData
- (void)archiveUsrData
{
    if (![NSStrUtil isEmptyOrNull:self.usrId]) {
        NSData* usrData = [NSKeyedArchiver archivedDataWithRootObject:usr];
        [USERDEFAULT setObject:usrData forKey:usrDataKey];
        [USERDEFAULT synchronize];
    }
}
@end

@implementation YTLoginModel
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"usr" : @"data" };
}
@end
