//
//  OpenHongbaoHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/12/8.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpenHongbaoHeadView;
@class YTPublish;

typedef void (^OpenHongbaoActionBlock)(OpenHongbaoHeadView *view);

@interface OpenHongbaoHeadView : UIView

@property (nonatomic, strong) UIImageView *hbImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hbtypeLabel;
@property (nonatomic, strong) UILabel *mesLabel;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, copy) OpenHongbaoActionBlock actionBlock;

- (void)configHbDetailWithModel:(YTPublish *)publish;
- (void)startAnimation;
- (void)endAnimation;
@end
