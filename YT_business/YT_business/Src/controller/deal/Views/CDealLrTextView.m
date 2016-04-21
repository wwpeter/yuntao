//
//  CDealLrTextView.m
//  YT_business
//
//  Created by chun.chen on 15/8/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "CDealLrTextView.h"

@implementation CDealLrTextView

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
        make.width.mas_equalTo(60);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftLabel.right).offset(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}
#pragma mark - Setter & Getter
- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.numberOfLines = 1;
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = CCCUIColorFromHex(0x999999);
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
        _rightLabel.textColor = CCCUIColorFromHex(0x333333);
        _rightLabel.lineBreakMode = NSLineBreakByTruncatingTail;
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
