//
//  YTSignTextView.m
//  YT_business
//
//  Created by chun.chen on 16/1/13.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import "YTSignTextView.h"

@implementation YTSignTextView
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

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}
#pragma mark - Setter & Getter
- (void)setTitleColor:(UIColor*)titleColor
{
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CCCUIColorFromHex(0x666666);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    UIColor* ccColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    UIBezierPath* bezierPath;
    if (_displayTop) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, 0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
        [ccColor setStroke];
        [bezierPath setLineWidth:1.0];
        [bezierPath stroke];
    }
    if (_displayBottom) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
        [ccColor setStroke];
        [bezierPath setLineWidth:0.5f];
        [bezierPath stroke];
    }
}

@end
