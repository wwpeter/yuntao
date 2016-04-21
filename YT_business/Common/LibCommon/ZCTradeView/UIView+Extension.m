//
//  UIView+Extension.m
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

// 最大的尺寸
#define ZCMAXSize CGSizeMake(MAXFLOAT, MAXFLOAT)

// 快速实例
#define Object(Class) [[Class alloc] init];

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setZc_x:(CGFloat)zc_x
{
    CGRect frame = self.frame;
    frame.origin.x = zc_x;
    self.frame = frame;
}

- (CGFloat)zc_x
{
    return self.frame.origin.x;
}

- (void)setZc_y:(CGFloat)zc_y
{
    CGRect frame = self.frame;
    frame.origin.y = zc_y;
    self.frame = frame;
}

- (CGFloat)zc_y
{
    return self.frame.origin.y;
}

- (void)setZc_width:(CGFloat)zc_width
{
    CGRect frame = self.frame;
    frame.size.width = zc_width;
    self.frame = frame;
}
- (CGFloat)zc_width
{
    return self.frame.size.width;
}

- (void)setZc_height:(CGFloat)zc_height
{
    CGRect frame = self.frame;
    frame.size.height = zc_height;
    self.frame = frame;
}
- (CGFloat)zc_height
{
     return self.frame.size.height;
}
- (void)setZc_size:(CGSize)zc_size
{
    CGRect frame = self.frame;
    frame.size = zc_size;
    self.frame = frame;
}

- (CGSize)zc_size
{
    return self.frame.size;
}

- (void)setZc_centerX:(CGFloat)zc_centerX
{
    CGPoint center = self.center;
    center.x = zc_centerX;
    self.center = center;
}

- (CGFloat)zc_centerX
{
    return self.center.x;
}
- (void)setZc_centerY:(CGFloat)zc_centerY
{
    CGPoint center = self.center;
    center.y = zc_centerY;
    self.center = center;
}

- (CGFloat)zc_centerY
{
    return self.center.y;
}

/** 水平居中 */
- (void)alignHorizontal
{
    self.zc_x = (self.superview.zc_width - self.zc_width) * 0.5;
}

/** 垂直居中 */
- (void)alignVertical
{
    self.zc_y = (self.superview.zc_height - self.zc_height) * 0.5;
}

/** 添加子控件 */
- (void)addSubview:(Class)class propertyName:(NSString *)propertyName
{
    id subView = Object(class);
    if ([self isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)self;
        [cell.contentView addSubview:subView];
    } else {
        [self addSubview:subView];
    }
    [self setValue:subView forKeyPath:propertyName];
}

@end
 