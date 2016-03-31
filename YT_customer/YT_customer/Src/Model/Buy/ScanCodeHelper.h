//
//  ScanCodeHelper.h
//  YT_customer
//
//  Created by chun.chen on 15/6/24.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ScanCodeOpenType) {
    // 本地
    ScanCodeOpenTypeNative,
    // H5
    ScanCodeOpenTypeH5
};

typedef NS_ENUM(NSInteger, ScanCodeModule) {
    // 扫描使用红包
    ScanCodeModuleUseHb,
    // 给红包
    ScanCodeModuleGiveHb,
    // 店铺
    ScanCodeModuleShopInfo
};

@interface ScanCodeHelper : NSObject
@property (assign, nonatomic) BOOL isYtCode;
@property (copy, nonatomic) NSString *resultString;
@property (strong, nonatomic) NSNumber *shopId;
@property (assign, nonatomic) ScanCodeOpenType openType;
@property (assign, nonatomic) ScanCodeModule moudel;
@property (assign, nonatomic) NSInteger promotion;
@property (assign, nonatomic) NSInteger discount;
@property (assign, nonatomic) NSInteger promotionType;
@property (assign, nonatomic) BOOL isPromotion;

- (instancetype)initWithResultUrlString:(NSString *)string;
@end
