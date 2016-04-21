//
//  PromotionTableHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/8/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTStatisticsHeadView.h"

@class YTYellowBackgroundView;
@interface PromotionTableHeadView : UIView

@property (strong, nonatomic)UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel* consumeLabel;
@property (nonatomic, strong) UILabel* consumeMesLabel;
@property (nonatomic, strong) YTYellowBackgroundView* yellowView;
@property (nonatomic, strong) YTStatisticsHeadView* statisticsView;

- (void)startActivityAnimating;
- (void)stopActivityAnimating;
@end
