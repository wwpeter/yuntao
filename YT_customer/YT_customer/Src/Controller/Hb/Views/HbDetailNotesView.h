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
@class HbDetailModel;
@class YTResultHongbao;

@interface HbDetailNotesView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HbDetailModel *hongbao;
@property (nonatomic, strong) HbDetaiDescribeView *describeView;
@property (nonatomic, strong) HbDetaiDescribeView *timeView;
@property (nonatomic, strong) HbDetailRuleView *ruleView;

-(instancetype)initWithUsrHongBao:(HbDetailModel *)hongbao frame:(CGRect)frame;
-(instancetype)initWithResultHongBao:(YTResultHongbao *)hongbao frame:(CGRect)frame;
- (CGSize)fitOptimumSize;
@end
