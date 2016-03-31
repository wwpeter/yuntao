//
//  ShopSubtractRuleSectionHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/11/9.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubtractFullRule;

@interface ShopSubtractRuleSectionHeadView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *describeLabel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descirbe;
@property (nonatomic, strong) UIColor *desTextColor;
@property (nonatomic, assign) BOOL showBottomLine;

- (void)configSubtractRule:(SubtractFullRule *)fullRule nowRule:(SubtractFullRule *)nowRule;
@end
