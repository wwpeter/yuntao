//
//  PromotionSettingHbCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/12.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "XLFormBaseCell.h"

extern NSString * const XLFormRowDescriptorTypePromotionSetting;

@interface PromotionSettingHbCell : XLFormBaseCell

@end


@interface PromotionHbDescribe : NSObject

@property (nonatomic ,assign) BOOL selected;
@property (nonatomic ,copy) NSString *hbDescribe;

+ (PromotionHbDescribe *)promotionHbDescribeWithSelected:(BOOL)selected describe:(NSString *)describe;
@end