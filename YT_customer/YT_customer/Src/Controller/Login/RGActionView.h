//
//  RGActionView.h
//  YT_business
//
//  Created by chun.chen on 15/6/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RGActionViewDelegate;

@interface RGActionView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UIButton *clickButton;
@property (strong, nonatomic) UIImageView *arrowView;
@property (readonly, nonatomic) UIImageView *topLine;
@property (readonly, nonatomic) UIImageView *bottomLine;
@property (strong, nonatomic) UIImage *arrowImage;
@property (assign, nonatomic) CGFloat leftMargin;
// defines NO
@property (assign, nonatomic) BOOL displayTopLine;
@property (assign, nonatomic) BOOL diversification;
@property (assign, nonatomic) BOOL didSelect;

@property (assign, nonatomic) id<RGActionViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame;

@end

@protocol RGActionViewDelegate <NSObject>
@optional
- (void)rgactionViewDidClicked:(RGActionView *)actionView;
@end
