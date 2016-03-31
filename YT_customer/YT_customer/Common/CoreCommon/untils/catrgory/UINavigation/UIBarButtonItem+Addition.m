//
//  UIBarButtonItem+Addition.m
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "UIBarButtonItem+Addition.h"
#import <objc/runtime.h>

static char* addBadgeView;

@implementation UIBarButtonItem (Addition)
- (void)setBadgeView:(JSBadgeView *)badgeView
{
    objc_setAssociatedObject(self, &addBadgeView, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (JSBadgeView *)badgeView
{
    return objc_getAssociatedObject(self, &addBadgeView);
}

- (instancetype)initWithCustomTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 88, 44);
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    return buttonItem;
}
- (instancetype)initWithCustomImage:(UIImage *)image highlightImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tintColor = [UIColor clearColor];
    //改为 固定的宽高
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.badgeView = [[JSBadgeView alloc] initWithParentView:button alignment:JSBadgeViewAlignmentTopRight];
    UIBarButtonItem *buttonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    return buttonItem;
}

- (instancetype)initWithYunTaoBacktarget:(id)target action:(SEL)action;
{
    UIImage *norImage = [UIImage imageNamed:@"yt_navigation_backBtn_normal.png"];
    UIImage *higlImage = [UIImage imageNamed:@"yt_navigation_backBtn_high.png"];
    return [self initWithCustomImage:norImage highlightImage:higlImage target:target action:action];
}
- (instancetype)initWithYunTaoSideLefttarget:(id)target action:(SEL)action
{
    UIImage *norImage = [UIImage imageNamed:@"yt_navigation_normalBtn_high.png"];
    UIImage *higlImage = [UIImage imageNamed:@"yt_navigation_siderBtn_high.png"];
    return [self initWithCustomImage:norImage highlightImage:higlImage target:target action:action];
}
@end
