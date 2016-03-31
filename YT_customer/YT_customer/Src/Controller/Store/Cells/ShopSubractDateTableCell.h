//
//  ShopSubractDateTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/11/11.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopSubtractRuleTableCell.h"

@class SubtractFullRule;

@interface ShopSubractDateTableCell : UITableViewCell
@property (nonatomic, strong) SubtractRuleView *timeView;
@property (nonatomic, strong) SubtractRuleView *dateView;

- (void)configShopSubtractDateRules:(SubtractFullRule *)fullRule;
@end
