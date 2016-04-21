//
//  CDealRecordDetailTableHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTTrade;
@class RGLrTextView;
@class CDealLrTextView;

@interface CDealRecordDetailTableHeadView : UIView

@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) RGLrTextView *totalPriceView;
@property (strong, nonatomic) RGLrTextView *orderPriceView;
@property (strong, nonatomic) RGLrTextView *procedurePriceView;
@property (strong, nonatomic) RGLrTextView *feePriceView;
@property (strong, nonatomic) RGLrTextView *subsidyView;
@property (strong, nonatomic) CDealLrTextView *payView;
@property (strong, nonatomic) CDealLrTextView *timeView;
@property (strong, nonatomic) CDealLrTextView *orderView;
@property (strong, nonatomic) CDealLrTextView *remarkView;

- (void)configDealRecordDetailHeadWithIntroModel:(YTTrade *)trade;

@end
