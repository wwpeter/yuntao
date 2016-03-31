//
//  ShopSubtractRuleTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/11/9.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubtractRuleView;

@interface ShopSubtractRuleTableCell : UITableViewCell
@property (nonatomic, strong) SubtractRuleView *timeView;
@property (nonatomic, strong) SubtractRuleView *ruleView;
@property (nonatomic, strong) SubtractRuleView *dateView;
- (void)configShopSubtractRules:(id)model;
- (CGFloat)ruleRowHeight;
@end


@interface SubtractRuleView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *describe;

- (CGSize)fitOptimumSize;
@end
