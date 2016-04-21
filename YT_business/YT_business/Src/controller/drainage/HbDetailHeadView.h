//
//  HbDetailHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTCommonHongBao;
@class YTUsrHongBao;


@interface HbDetailHeadView : UIView

// 红包图片
@property (strong, nonatomic) UIImageView *hbImageView;
// 状态图片
@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UIImageView *shopIconImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *shopLabel;


- (void)configDetailHeadViewWithCommonHongBao:(YTCommonHongBao *)hongbao;
- (void)configDetailHeadViewWithUsrHongBao:(YTUsrHongBao *)hongbao;

@end
