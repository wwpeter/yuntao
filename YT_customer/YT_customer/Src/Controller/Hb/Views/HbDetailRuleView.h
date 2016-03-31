//
//  HbDetailRuleView.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbDetailRuleView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (assign, nonatomic) CGFloat rulesHeight;

- (instancetype)initWithFrame:(CGRect)frame rules:(NSArray *)rules;
- (instancetype)initWithRulesDesc:(NSString *)ruleDesc frame:(CGRect)frame;

- (CGSize)fitOptimumSize;
@end
