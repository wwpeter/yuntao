//
//  UIView+DKAddition.h
//  DangKe
//
//  Created by lv on 15/5/6.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface UIView (DKAddition)

// coordinator getters
- (CGFloat)dk_height;
- (CGFloat)dk_width;
- (CGFloat)dk_x;
- (CGFloat)dk_y;
- (CGSize)dk_size;
- (CGPoint)dk_origin;
- (CGFloat)dk_centerX;
- (CGFloat)dk_centerY;
- (CGFloat)dk_bottom;
- (CGFloat)dk_right;

- (void)setDk_x:(CGFloat)x;
- (void)setDk_y:(CGFloat)y;

// height
- (void)setDk_height:(CGFloat)height;
- (void)dk_heightEqualToView:(UIView *)view;

// width
- (void)setDk_width:(CGFloat)width;
- (void)dk_widthEqualToView:(UIView *)view;

// center
- (void)setDk_centerX:(CGFloat)centerX;
- (void)setDk_centerY:(CGFloat)centerY;
- (void)dk_centerXEqualToView:(UIView *)view;
- (void)dk_centerYEqualToView:(UIView *)view;

// top, bottom, left, right
- (void)dk_top:(CGFloat)top FromView:(UIView *)view;
- (void)dk_bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)dk_left:(CGFloat)left FromView:(UIView *)view;
- (void)dk_right:(CGFloat)right FromView:(UIView *)view;

- (void)dk_topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize;
- (void)dk_bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize;
- (void)dk_leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize;
- (void)dk_rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize;

- (void)dk_topEqualToView:(UIView *)view;
- (void)dk_bottomEqualToView:(UIView *)view;
- (void)dk_leftEqualToView:(UIView *)view;
- (void)dk_rightEqualToView:(UIView *)view;

// size
- (void)setDK_size:(CGSize)size;
- (void)dk_sizeEqualToView:(UIView *)view;

// imbueset
- (void)dk_fillWidth;
- (void)dk_fillHeight;
- (void)dk_fill;

- (UIView *)dk_topSuperView;


/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;
/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * The view controller whose view contains this view.
 */
- (UIViewController*)viewController;

/**
 给View加上圆角和边框
 */
- (UIView *)roundedCornerAndBorderView;

- (id)subviewWithTag:(NSInteger)tag;


@end

@protocol LayoutProtocol
@required
// put your layout code here
- (void)calculateLayout;
@end




