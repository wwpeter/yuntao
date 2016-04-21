//
//  PromotionHbIntroView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HbDescribeView.h"

@class YTPromotionHongbao;

@interface PromotionHbIntroView : UIView

// 到期时间
@property (strong, nonatomic) UILabel *timeLabel;
// 红包状态
@property (strong, nonatomic) UILabel *statusLabel;
// 红包描述
@property (strong, nonatomic) HbDescribeView *describeView;

- (void)configPromotionHbIntroViewWithModel:(YTPromotionHongbao *)promotionHongbao;
@end
