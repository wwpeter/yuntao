//
//  ShopDetailBottomView.h
//  YT_customer
//
//  Created by chun.chen on 15/8/1.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ShopBuyBlock)();

@interface ShopDetailBottomView : UIView
@property (strong, nonatomic)UILabel *textLabel;
@property (strong, nonatomic)UIButton *buyButton;
@property (copy,nonatomic) ShopBuyBlock buyBlock;
@end
