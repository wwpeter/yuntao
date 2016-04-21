//
//  CHbDetailAddressView.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HbDetailAddressViewBlock)(NSInteger selectIndex);

@interface CHbDetailAddressView : UIView

@property (strong, nonatomic) UIImageView *addressIcon;
@property (strong, nonatomic) UIImageView *verticalLine;
@property (strong, nonatomic) UIButton *phoneButton;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *shopLabel;
@property (strong, nonatomic) UILabel *addressLabel;

@property (copy, nonatomic) HbDetailAddressViewBlock selectBlock;

@end
