//
//  ShopDetailSectionHeadView.m
//  YT_business
//
//  Created by chun.chen on 15/7/14.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "ShopDetailSectionHeadView.h"

@implementation ShopDetailSectionHeadView

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
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(_rightLabel.left);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
    }];
}
#pragma mark - Setter & Getter
- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.numberOfLines = 1;
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = CCCUIColorFromHex(0x666666);
        _leftLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.numberOfLines = 1;
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textColor = CCCUIColorFromHex(0x999999);
        _rightLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _rightLabel;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];

}

@end
