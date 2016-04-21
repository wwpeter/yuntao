//
//  YTPaySingleView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTPaySingleViewDelegate;

@interface YTPaySingleView : UIView

@property (strong, nonatomic) UIImageView *iconImageView;
// 标题
@property (strong, nonatomic) UILabel *titleLabel;
// 说明
@property (strong, nonatomic) UILabel *messageLabel;
// 选择
@property (strong, nonatomic) UIButton *accessoryButton;

// 底部线条边距
@property (assign, nonatomic) CGFloat separatorMargin;
// 选择
@property (assign, nonatomic) BOOL choiced;

@property (weak, nonatomic) id<YTPaySingleViewDelegate> delegate;

@end

@protocol YTPaySingleViewDelegate <NSObject>
@required
- (void)paySingleView:(YTPaySingleView *)view didSelectAccessoryButton:(UIButton *)button;
@end

