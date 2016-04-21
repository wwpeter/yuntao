//
//  ShopDetailAddressView.h
//  YT_business
//
//  Created by chun.chen on 15/8/17.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShopAddressViewSelectBlock)(NSInteger selectIndex);

@interface ShopDetailAddressView : UIView

@property (strong, nonatomic) UIImageView *addressIcon;
@property (strong, nonatomic) UIImageView *verticalLine;
@property (strong, nonatomic) UIButton *phoneButton;
@property (strong, nonatomic) UILabel *addressLabel;

@property (copy, nonatomic) ShopAddressViewSelectBlock selectBlock;

@end
