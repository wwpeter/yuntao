//
//  MobileRechargeAmountView.m
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "MobileRechargeAmountView.h"

static const NSInteger kAmountTag = 1000;

@implementation MobileRechargeAmountView

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
- (void)amountButtonClicked:(UIButton *)button
{
    NSNumber *amount = self.amounts[button.tag-kAmountTag];
    if (self.selectBlock) {
        self.selectBlock(amount);
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.amounts = @[@30,@50,@100,@200,@300,@500];
    CGFloat btnWidth = CGRectGetWidth(self.bounds)/3;
    for (NSInteger i = 0; i<6; i++) {
        CGFloat btnX = (i % 3) * btnWidth;
        CGFloat btnY = (i / 3) * btnWidth;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnX, btnY, btnWidth, btnWidth);
        button.tag = kAmountTag + i;
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [button setTitleColor:YTDefaultRedColor forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@元",self.amounts[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(amountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    
    CGFloat btnWidth = CGRectGetWidth(rect)/3;
    
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),0)];
    [ccColor  setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, btnWidth)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),btnWidth)];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),CGRectGetHeight(rect))];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(btnWidth, 0)];
    [bezierPath addLineToPoint:CGPointMake(btnWidth,CGRectGetHeight(rect))];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(2*btnWidth, 0)];
    [bezierPath addLineToPoint:CGPointMake(2*btnWidth,CGRectGetHeight(rect))];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
}

@end
