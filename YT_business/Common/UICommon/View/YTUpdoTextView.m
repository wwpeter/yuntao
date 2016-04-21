//
//  YTUpdoTextView.m
//  YT_business
//
//  Created by chun.chen on 15/8/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTUpdoTextView.h"

@implementation YTUpdoTextView

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
    [self addSubview:self.upLabel];
    [self addSubview:self.downLabel];
    
    [_upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-10);
    }];
    [_downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(10);
    }];
}
#pragma mark - Setter & Getter
- (UILabel *)upLabel
{
    if (!_upLabel) {
        _upLabel = [[UILabel alloc] init];
        _upLabel.numberOfLines = 1;
        _upLabel.font = [UIFont systemFontOfSize:18];
        _upLabel.textColor = CCCUIColorFromHex(0xfd5c63);
        _upLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _upLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _upLabel;
}
- (UILabel *)downLabel
{
    if (!_downLabel) {
        _downLabel = [[UILabel alloc] init];
        _downLabel.numberOfLines = 1;
        _downLabel.font = [UIFont systemFontOfSize:12];
        _downLabel.textColor = CCCUIColorFromHex(0x666666);
        _downLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _downLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _downLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
