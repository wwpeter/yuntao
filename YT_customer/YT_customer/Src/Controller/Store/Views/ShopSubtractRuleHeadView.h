//
//  ShopSubtractRuleHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/11/9.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubtractFullDes;
@class ShopSubtractRuleSectionHeadView;

@interface ShopSubtractRuleHeadView : UIView

@property (nonatomic, strong)ShopSubtractRuleSectionHeadView *headView;
@property (nonatomic, assign) CGFloat rulesHeight;

- (instancetype)initWithRulesDesc:(NSArray *)texts frame:(CGRect)frame;

- (CGSize)fitOptimumSize;
@end
