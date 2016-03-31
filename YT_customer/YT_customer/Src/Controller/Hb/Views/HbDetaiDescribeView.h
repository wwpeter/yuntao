//
//  HbDetaiDescribeView.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbDetaiDescribeView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *describeLabel;

- (instancetype)initWithFrame:(CGRect)frame describeTextHeight:(CGFloat)height;
- (instancetype)initWithDescribe:(NSString *)describe frame:(CGRect)frame;

- (CGSize)fitOptimumSize;
@end
