//
//  ShopDetailAddressView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/6.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShopDetailAddressSelectBlock)(NSInteger selectIndex);

@interface ShopDetailAddressView : UIView

@property (strong, nonatomic) UIImageView *addressIcon;
@property (strong, nonatomic) UIImageView *verticalLine;
@property (strong, nonatomic) UIButton *phoneButton;
@property (strong, nonatomic) UILabel *addressLabel;

@property (copy, nonatomic) ShopDetailAddressSelectBlock selectBlock;

@end
