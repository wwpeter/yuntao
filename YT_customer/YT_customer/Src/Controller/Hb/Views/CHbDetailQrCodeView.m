//
//  CHbDetailQrCodeView.m
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "CHbDetailQrCodeView.h"

@implementation CHbDetailQrCodeView
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

#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.serialLabel];
    [self addSubview:self.qrImageView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(60);
    }];
    [_serialLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_titleLabel);
    }];
    [_qrImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(55);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(148, 148));
    }];
}
#pragma mark - Setter & Getter
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.text = @"序列号";
    }
    return _titleLabel;
}
- (UILabel*)serialLabel
{
    if (!_serialLabel) {
        _serialLabel = [[UILabel alloc] init];
        _serialLabel.numberOfLines = 1;
        _serialLabel.font = [UIFont systemFontOfSize:18];
        _serialLabel.textColor = CCCUIColorFromHex(0x333333);
        _serialLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _serialLabel;
}
- (UIImageView*)qrImageView
{
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc] init];
        _qrImageView.layer.masksToBounds = YES;
        _qrImageView.layer.borderWidth = 1;
        _qrImageView.userInteractionEnabled = YES;
        UIColor* ccColor = CCCUIColorFromHex(0xcccccc);
        _qrImageView.layer.borderColor = [ccColor CGColor];
    }
    return _qrImageView;
}

- (void)drawRect:(CGRect)rect
{
    UIColor* ccColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    UIBezierPath* bezierPath;

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(15, 40)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 40)];
    [ccColor setStroke];
    [bezierPath setLineWidth:0.5f];
    [bezierPath stroke];

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
