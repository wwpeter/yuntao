//
//  YTStatisticsHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/8/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTUpdoTextView.h"

@interface YTStatisticsHeadView : UIView

@property (nonatomic, strong)YTUpdoTextView *leftOnView;
@property (nonatomic, strong)YTUpdoTextView *leftTwView;
@property (nonatomic, strong)YTUpdoTextView *rightOnView;
@property (nonatomic, strong)YTUpdoTextView *rightTwView;

@property (nonatomic, assign)BOOL displayTopLine;

@end
