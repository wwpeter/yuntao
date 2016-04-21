//
//  RGCheckView.h
//  YT_business
//
//  Created by chun.chen on 15/6/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGCheckView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *checkButton;

@property (readonly, nonatomic) UIImageView *topLine;
@property (readonly, nonatomic) UIImageView *bottomLine;
@property (assign, nonatomic) CGFloat leftMargin;

@property (assign, nonatomic) BOOL displayTopLine;
@property (assign, nonatomic) BOOL didSelect;

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame;

@end
