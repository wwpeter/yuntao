//
//  UIBarButtonItem+Addition.h
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Addition)

- (instancetype)initWithCustomTitle:(NSString *)title target:(id)target action:(SEL)action;
- (instancetype)initWithCustomImage:(UIImage *)image highlightImage:(UIImage *)highImage target:(id)target action:(SEL)action;
- (instancetype)initWithYunTaoBacktarget:(id)target action:(SEL)action;
- (instancetype)initWithYunTaoSideLefttarget:(id)target action:(SEL)action;

@end
