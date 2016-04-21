//
//  HbDetailNotesView.h
//  YT_business
//
//  Created by chun.chen on 15/8/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HbDetaiDescribeView;
@class HbDetailRuleView;
@class YTUsrHongBao;


@interface HbDetailNotesView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YTUsrHongBao *usrHongbao;
@property (nonatomic, strong) HbDetaiDescribeView *describeView;
@property (nonatomic, strong) HbDetaiDescribeView *timeView;
@property (nonatomic, strong) HbDetailRuleView *ruleView;

-(instancetype)initWithUsrHongBao:(YTUsrHongBao *)hongbao frame:(CGRect)frame;
- (CGSize)fitOptimumSize;
@end
