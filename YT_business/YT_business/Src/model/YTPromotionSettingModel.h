//
//  YTPromotionSettingModel.h
//  YT_business
//
//  Created by chun.chen on 15/7/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"


@interface YTPromotionSet : YTBaseModel

@property (nonatomic,strong) YTShop *shop;
@end

@interface YTPromotionSettingModel : YTBaseModel
@property (nonatomic,strong) YTPromotionSet *promotionSet;
@end


@protocol YTFullSubtract <NSObject>

@end


@interface YTSubtractFullModel : YTBaseModel

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSArray<YTFullSubtract> *rules;

@end

@interface YTFullSubtract : YTBaseModel
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, assign) NSInteger subtractFull;
@property (nonatomic, assign) NSInteger subtractCur;
@property (nonatomic, assign) NSInteger subtractMax;
@end
