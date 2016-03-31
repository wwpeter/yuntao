//
//  YTPaySuccessView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTPaySuccessViewDelegate;

@interface YTPaySuccessView : UIView <UIAlertViewDelegate>

@property(strong, nonatomic) UIImageView *iconImageView;
@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *describeLabel;
@property(strong, nonatomic) UIButton *buyButton;
@property(strong, nonatomic) UIButton *lookButton;

@property (weak, nonatomic) id<YTPaySuccessViewDelegate> delegate;

@end


@protocol YTPaySuccessViewDelegate <NSObject>
@optional
- (void)paySuccessView:(YTPaySuccessView *)view clickedButtonAtIndex:(NSInteger)buttonIndex;
@end