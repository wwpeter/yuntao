//
//  ShopDetailPayTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/10/10.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectPayTypeBlock)(PreferencePayType payType);

@interface ShopDetailPayTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *buyLabel;
@property (strong, nonatomic) UIButton *payButton;
@property (assign, nonatomic) PreferencePayType payType;
@property (copy, nonatomic) SelectPayTypeBlock payBlock;

- (void)showDiscountPay:(NSInteger)discount;
- (void)showHongbaoPay;
@end
