//
//  SearchSectionHeadView.m
//  YT_customer
//
//  Created by chun.chen on 15/9/29.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "SearchSectionHeadView.h"

@implementation SearchSectionHeadView

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
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.mas_equalTo(self);
    }];
    UIImageView* leftLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    UIImageView* rightLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [self addSubview:leftLine];
    [self addSubview:rightLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(_titleLabel.left).offset(-5);
    }];
    [rightLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(_titleLabel.right).offset(5);
    }];
}
#pragma mark - Setter & Getter
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = CCCUIColorFromHex(0x666666);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.text = @"去以下商家消费即可免费领取红包";
    }
    return _titleLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
