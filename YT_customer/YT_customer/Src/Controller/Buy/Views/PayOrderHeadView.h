//
//  PayOrderHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/2.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RGLrTextView;
@class DealLrTextView;
@class PaySuccessModel;

@interface PayOrderHeadView : UIView

@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) RGLrTextView *totalPriceView;
@property (strong, nonatomic) RGLrTextView *orderPriceView;
@property (strong, nonatomic) RGLrTextView *feePriceView;
@property (strong, nonatomic) DealLrTextView *payView;
@property (strong, nonatomic) DealLrTextView *timeView;
@property (strong, nonatomic) DealLrTextView *orderView;
@property (strong, nonatomic) DealLrTextView *remarkView;

- (void)configPayOrderHeadViewWithIntroModel:(PaySuccessModel *)payModel;

@end


@interface DealLrTextView : UIView
@property (strong, nonatomic)UILabel *leftLabel;
@property (strong, nonatomic)UILabel *rightLabel;
@end
