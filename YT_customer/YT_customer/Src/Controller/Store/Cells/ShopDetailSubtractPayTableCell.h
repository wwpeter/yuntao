//
//  ShopDetailSubtractPayTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/10/31.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDetailPayTableCell.h"

@class SubtractPayTimeView;
typedef void (^SubtractSelectBlock)();

@interface ShopDetailSubtractPayTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *buyLabel;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) SubtractPayTimeView *firstTimeView;
@property (nonatomic, strong) SubtractPayTimeView *secondTimeView;
@property (nonatomic, strong) SubtractPayTimeView *thirdTimeView;

@property (nonatomic, copy) SelectPayTypeBlock payBlock;
@property (nonatomic, copy) SubtractSelectBlock selectBlock;

- (void)configShopDetailSubtractPayTimes:(NSArray *)fullRules;

@end

@interface SubtractPayTimeView : UIView
@property (strong, nonatomic) UIImageView *timeImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@end
