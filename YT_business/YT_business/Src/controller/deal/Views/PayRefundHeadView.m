//
//  PayRefundHeadView.m
//  YT_business
//
//  Created by chun.chen on 15/7/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "PayRefundHeadView.h"

@implementation PayRefundHeadView

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

#pragma mark - Subviews
- (void)configSubViews
{
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.waveImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.orderLabel];
    [self addSubview:self.timeLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [_waveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(16);
    }];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_waveImageView.top);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImageView.right).offset(10);
        make.top.mas_equalTo(_iconImageView);
        make.right.mas_equalTo(self);
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.bottom).offset(3);
    }];
    [_orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_amountLabel.bottom).offset(2);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_orderLabel.bottom).offset(2);
    }];
    
}


#pragma mark - Getters & Setters
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_suc"]];
    }
    return _iconImageView;
}
- (UIImageView *)waveImageView
{
    if (!_waveImageView) {
        _waveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wave_line"]];
    }
    return _waveImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = CCCUIColorFromHex(0x666666);
        _amountLabel.font = [UIFont systemFontOfSize:14];
        _amountLabel.numberOfLines = 1;
        _amountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _amountLabel;
}
- (UILabel *)orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.textColor = CCCUIColorFromHex(0x666666);
        _orderLabel.font = [UIFont systemFontOfSize:14];
        _orderLabel.numberOfLines = 1;
        _orderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _orderLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CCCUIColorFromHex(0x666666);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.numberOfLines = 1;
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _timeLabel;
}

@end
