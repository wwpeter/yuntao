//
//  PrEmptyView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrEmptyView : UIView

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;

// 是否显示箭头 默认显示
@property (assign, nonatomic) BOOL displayArrow;
// 标题颜色
@property (strong, nonatomic) UIColor *titleColor;

@end
