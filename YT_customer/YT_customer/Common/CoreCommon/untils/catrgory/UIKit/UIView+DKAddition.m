//
//  UIView+DKAddition.m
//  DangKe
//
//  Created by lv on 15/5/6.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import "UIView+DKAddition.h"

@implementation UIView (DKAddition)

// coordinator getters
- (CGFloat)dk_height
{
    return CGRectGetHeight(self.bounds);
}

- (CGFloat)dk_width
{
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)dk_x
{
    return self.frame.origin.x;
}
- (void)setDk_x:(CGFloat)x
{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (void)setDk_y:(CGFloat)y
{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)dk_y
{
    return self.frame.origin.y;
}

- (CGSize)dk_size
{
    return self.frame.size;
}

- (CGPoint)dk_origin
{
    return self.frame.origin;
}

- (CGFloat)dk_centerX
{
    return self.center.x;
}

- (CGFloat)dk_centerY
{
    return self.center.y;
}

- (CGFloat)dk_bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (CGFloat)dk_right
{
    return self.frame.size.width + self.frame.origin.x;
}

// height
- (void)setDk_height:(CGFloat)height;
{
    CGRect newFrame = CGRectMake(self.dk_x, self.dk_y, self.dk_width, height);
    self.frame = newFrame;
}

- (void)dk_heightEqualToView:(UIView *)view
{
    self.dk_height = view.dk_height;
}

// width
- (void)setDk_width:(CGFloat)width
{
    CGRect newFrame = CGRectMake(self.dk_x, self.dk_y, width, self.dk_height);
    self.frame = newFrame;
}

- (void)dk_widthEqualToView:(UIView *)view
{
    self.dk_width = view.dk_width;
}

// center
- (void)setDk_centerX:(CGFloat)centerX
{
    CGPoint center = CGPointMake(self.dk_centerX, self.dk_centerY);
    center.x = centerX;
    self.center = center;
}

- (void)setDk_centerY:(CGFloat)centerY
{
    CGPoint center = CGPointMake(self.dk_centerX, self.dk_centerY);
    center.y = centerY;
    self.center = center;
}

- (void)dk_centerXEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.dk_topSuperView];
    CGPoint centerPoint = [self.dk_topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.dk_centerX = centerPoint.x;
}

- (void)dk_centerYEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewCenterPoint = [superView convertPoint:view.center toView:self.dk_topSuperView];
    CGPoint centerPoint = [self.dk_topSuperView convertPoint:viewCenterPoint toView:self.superview];
    self.dk_centerY = centerPoint.y;
}

// top, bottom, left, right
- (void)dk_top:(CGFloat)top FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_y = newOrigin.y + top + view.dk_height;
}

- (void)dk_bottom:(CGFloat)bottom FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_y = newOrigin.y - bottom - self.dk_height;
}

- (void)dk_left:(CGFloat)left FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_x = newOrigin.x - left - self.dk_width;
}

- (void)dk_right:(CGFloat)right FromView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_x = newOrigin.x + right + view.dk_width;
}

- (void)dk_topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.dk_height = self.dk_y - top + self.dk_height;
    }
    self.dk_y = top;
}

- (void)dk_bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.dk_height = self.superview.dk_height - bottom - self.dk_y;
    } else {
        self.dk_y = self.superview.dk_height - self.dk_height - bottom;
    }
}

- (void)dk_leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.dk_width = self.dk_x - left + self.superview.dk_width;
    }
    self.dk_x = left;
}

- (void)dk_rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize
{
    if (shouldResize) {
        self.dk_width = self.superview.dk_width - right - self.dk_x;
    } else {
        self.dk_x = self.superview.dk_width - self.dk_width - right;
    }
}

- (void)dk_topEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_y = newOrigin.y;
}

- (void)dk_bottomEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_y = newOrigin.y + view.dk_height - self.dk_height;
}

- (void)dk_leftEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_x = newOrigin.x;
}

- (void)dk_rightEqualToView:(UIView *)view
{
    UIView *superView = view.superview ? view.superview : view;
    CGPoint viewOrigin = [superView convertPoint:view.dk_origin toView:self.dk_topSuperView];
    CGPoint newOrigin = [self.dk_topSuperView convertPoint:viewOrigin toView:self.superview];
    
    self.dk_x = newOrigin.x + view.dk_width - self.dk_width;
}

// size
- (void)setDK_size:(CGSize)size
{
    self.frame = CGRectMake(self.dk_x, self.dk_y, size.width, size.height);
}

- (void)dk_sizeEqualToView:(UIView *)view
{
    self.frame = CGRectMake(self.dk_x, self.dk_y, view.dk_width, view.dk_height);
}

// imbueset
- (void)dk_fillWidth
{
    self.dk_width = self.superview.dk_width;
}

- (void)dk_fillHeight
{
    self.dk_height = self.superview.dk_height;
}

- (void)dk_fill
{
    self.frame = CGRectMake(0, 0, self.superview.dk_width, self.superview.dk_height);
}

- (UIView *)dk_topSuperView
{
    UIView *topSuperView = self.superview;
    
    if (topSuperView == nil) {
        topSuperView = self;
    } else {
        while (topSuperView.superview) {
            topSuperView = topSuperView.superview;
        }
    }
    
    return topSuperView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)roundedCornerAndBorderView{
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    
    return self;
}

- (id)subviewWithTag:(NSInteger)tag{
    
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

@end

