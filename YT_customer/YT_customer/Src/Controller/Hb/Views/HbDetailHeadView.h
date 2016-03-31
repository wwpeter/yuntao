//
//  HbDetailHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HbDetailModel;
@class YTResultHongbao;

@interface HbDetailHeadView : UIView

@property (nonatomic, assign) BOOL displayTime;
@property (nonatomic, strong) UIImageView *hbImageView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UIImageView *timeIconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *costLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (instancetype)initWithDisplayTime:(BOOL)displayTime frame:(CGRect)frame;
- (void)configDetailHeadViewWithHongBao:(HbDetailModel *)hongbao;
- (void)configDetailHeadViewWithResultHongBao:(YTResultHongbao *)hongbao;
@end
