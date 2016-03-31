//
//  HbMoreFooterView.m
//  YT_customer
//
//  Created by chun.chen on 15/8/2.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "HbMoreFooterView.h"

@implementation HbMoreFooterView

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
#pragma mark - Event response
- (void)tapViewCallBack:(UITapGestureRecognizer *)tap
{
    self.didDown = !self.didDown;
    if (self.selectBlock) {
        self.selectBlock(_didDown);
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self).offset(-6);
        make.centerY.mas_equalTo(self);
    }];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.right).offset(3);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 7));
    }];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewCallBack:)]];
}
#pragma mark - Getters & Setters
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"查看更多红包";
    }
    return _titleLabel;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_store_hb_downArrow.png"]];
    }
    return _arrowImageView;
}
- (void)drawRect:(CGRect)rect {
    
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
