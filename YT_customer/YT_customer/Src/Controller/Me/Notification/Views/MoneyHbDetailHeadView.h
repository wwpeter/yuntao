//
//  MoneyHbDetailHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/12/8.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTPublish;
@interface MoneyHbDetailHeadView : UIView
@property (nonatomic, strong) UIImageView *hbImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mesLabel;
@property (nonatomic, strong) UILabel *costLabel;
@property (nonatomic, strong) UILabel *wordLabel;
- (void)configHbDetailWithModel:(YTPublish *)publish;
- (void)hideCostView;
@end
