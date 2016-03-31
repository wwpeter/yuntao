//
//  EmptyDataEffect.h
//  YT_customer
//
//  Created by chun.chen on 15/8/10.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIScrollView+EmptyDataSet.h"

typedef NS_ENUM(NSUInteger, EmptyDataEffectType) {
    /**< 没有网络*/
    EmptyDataEffectTypeNetworkNone,
    /**< 网络错误*/
    EmptyDataEffectTypeNetworkError,
    /**< 地理位置错误*/
    EmptyDataEffectTypeLocationError,
    /**< 商户搜索*/
    EmptyDataEffectTypeSearchStore,
    EmptyDataEffectTypeHehe
};
@interface EmptyDataEffect : NSObject
+ (NSAttributedString*)titleForEmptyDataEffectType:(EmptyDataEffectType)effectType;
+ (NSAttributedString*)descriptionForEmptyDataEffectType:(EmptyDataEffectType)effectType;
+ (NSAttributedString*)buttonTitleForEmptyDataEffectType:(EmptyDataEffectType)effectType;
+ (UIImage*)imageForEmptyDataEffectType:(EmptyDataEffectType)effectType;
+ (UIImage *)buttonBackgroundImageForState:(UIControlState)state effectType:(EmptyDataEffectType)effectType;
@end
