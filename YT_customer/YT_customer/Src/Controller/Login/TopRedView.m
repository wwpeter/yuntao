//
//  TopRedView.m
//  YT_business
//
//  Created by chun.chen on 15/6/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "TopRedView.h"

@implementation TopRedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(rect)/3;
    UIColor *rgRedColor = CCCUIColorFromHex(0xfa5e66);
    UIColor *rgGrayColor = CCCUIColorFromHex(0xc8c8c8);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    [bezierPath addLineToPoint:CGPointMake(width, CGRectGetHeight(rect))];
    [rgRedColor setStroke];
    [bezierPath setLineWidth:CGRectGetWidth(rect)];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(width+2, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(2*width+2, CGRectGetHeight(rect))];
    if (_index > 1) {
        [rgRedColor setStroke];
    } else {
        [rgGrayColor setStroke];
    }

    [bezierPath setLineWidth:CGRectGetWidth(rect)];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(2*width+4, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    if (_index > 2) {
        [rgRedColor setStroke];
    } else {
        [rgGrayColor setStroke];
    }
    [bezierPath setLineWidth:CGRectGetWidth(rect)];
    [bezierPath stroke];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
