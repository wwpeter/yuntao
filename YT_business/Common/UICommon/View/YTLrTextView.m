//
//  YTLrTextView.m
//  YT_business
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTLrTextView.h"

@implementation YTLrTextView
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
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftLabel);
        make.right.mas_equalTo(-15);
    }];
}
#pragma mark - Setter & Getter
- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.numberOfLines = 1;
        _leftLabel.font = [UIFont systemFontOfSize:14];
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
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = CCCUIColorFromHex(0x666666);
        _rightLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
