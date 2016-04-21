//
//  DrainageDetailTableHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTDrainageDetail;
@protocol DrainageDetailHeadViewDelegate;

@interface DrainageDetailTableHeadView : UIView

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *throwLabel;
@property (strong, nonatomic) UILabel *pullLabel;
@property (strong, nonatomic) UILabel *leadLabel;

@property (nonatomic, weak) id<DrainageDetailHeadViewDelegate> delegate;

- (void)configDrainageDetailHeadViewWithModel:(YTDrainageDetail *)drainageDetail;

@end


@protocol DrainageDetailHeadViewDelegate <NSObject>
@optional
- (void)drainageDetailHeadViewDidTap:(DrainageDetailTableHeadView *)view;
@end