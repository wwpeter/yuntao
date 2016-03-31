//
//  HbEmptyView.h
//  YT_business
//
//  Created by chun.chen on 15/6/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbEmptyView : UIView

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

// 是否显示箭头 默认显示
@property (assign, nonatomic) BOOL displayArrow;
// 高度
@property (assign, nonatomic) NSInteger yOffset;
// 标题颜色
@property (strong, nonatomic) UIColor *titleColor;
// 副标题颜色
@property (strong, nonatomic) UIColor *descriptionColor;

@end
