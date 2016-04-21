//
//  DealRecordDetailRemarkView.m
//  YT_business
//
//  Created by chun.chen on 15/11/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "DealRecordDetailRemarkView.h"

@implementation DealRecordDetailRemarkView

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
+ (CGFloat)remarkHeight:(NSString *)remark
{
    NSString *remarkStr = [NSString stringWithFormat:@"备注:%@",remark];
    return [NSStrUtil stringHeightWithString:remarkStr stringFont:[UIFont systemFontOfSize:15] textWidth:kDeviceWidth-15]+20;
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    [self addSubview:self.remarkLabel];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self);
    }];
}
#pragma mark - Getters & Setters
- (void)setRemark:(NSString *)remark
{
    _remark = [remark copy];
    _remarkLabel.text = [NSString stringWithFormat:@"备注:%@",remark];
}

- (UILabel *)remarkLabel
{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.font = [UIFont systemFontOfSize:15];
        _remarkLabel.textColor = CCCUIColorFromHex(0x333333);
        _remarkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _remarkLabel;
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}
@end
