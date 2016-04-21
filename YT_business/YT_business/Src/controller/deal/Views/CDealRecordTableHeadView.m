//
//  CDealRecordTableHeadView.m
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "CDealRecordTableHeadView.h"

@implementation CDealRecordTableHeadView

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
- (void)zfbPayButtonClicked:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(0);
    }
}
- (void)wxPayButtonClicked:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(1);
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = CCCUIColorFromHex(0x282d3c);
    [self addSubview:self.zfbPayBtn];
    [self addSubview:self.wxPayBtn];
    [_zfbPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    [_wxPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(_zfbPayBtn.right);
    }];
}
#pragma mark - Getters & Setters
- (UIButton *)zfbPayBtn
{
    if (!_zfbPayBtn) {
        _zfbPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _zfbPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_zfbPayBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        _zfbPayBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 65, 0, 0);
        _zfbPayBtn.titleEdgeInsets = UIEdgeInsetsMake(40, -30, 0, 0);
        [_zfbPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_zfbPayBtn setTitle:@"支付宝收款" forState:UIControlStateNormal];
        [_zfbPayBtn setImage:[UIImage imageNamed:@"yt_payType_zfb.png"] forState:UIControlStateNormal];
        [_zfbPayBtn addTarget:self action:@selector(zfbPayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zfbPayBtn;
}
- (UIButton *)wxPayBtn
{
    if (!_wxPayBtn) {
        _wxPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _wxPayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _wxPayBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 65, 0, 0);
        _wxPayBtn.titleEdgeInsets = UIEdgeInsetsMake(40, -30, 0, 0);
//        [_wxPayBtn setTitleColor:[CCCUIColorFromHex(0xffffff) colorWithAlphaComponent:0.5 ] forState:UIControlStateNormal];
        [_wxPayBtn setTitle:@"微信收款" forState:UIControlStateNormal];
        [_wxPayBtn setImage:[UIImage imageNamed:@"yt_payType_wx.png"] forState:UIControlStateNormal];
        [_wxPayBtn addTarget:self action:@selector(wxPayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxPayBtn;
}

- (void)drawRect:(CGRect)rect {

    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(rect)/2, 15)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)-15)];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}
@end
