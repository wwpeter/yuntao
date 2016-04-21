//
//  HbDetailRecommendView.h
//  YT_business
//
//  Created by chun.chen on 15/8/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTCommonShop;

typedef void(^RecommendShopSelectBlock)(YTCommonShop *commonShop);

@interface HbDetailRecommendView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic,copy) NSArray *recommendShops;
@property (nonatomic,copy) RecommendShopSelectBlock shopSelectBlock;

-(instancetype)initWithRecommendShop:(NSArray *)recommendShop frame:(CGRect)frame;

@end
