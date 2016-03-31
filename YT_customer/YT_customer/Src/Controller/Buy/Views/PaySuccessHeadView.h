//
//  PaySuccessHeadView.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaySuccessModel;
@interface PaySuccessHeadView : UIView

@property (strong, nonatomic)UIImageView *iconImageView;

@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *nameLabel;
@property (strong, nonatomic)UILabel *costLabel;
@property (strong, nonatomic)UILabel *timeLabel;
@property (strong, nonatomic)UILabel *orderLabel;

- (void)configPaySuccessHeadViewWithModel:(PaySuccessModel *)paySuccessModel;

@end
