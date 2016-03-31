//
//  MoneyHongbaoReceiveTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/12/8.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTPsqptHb;
@interface MoneyHongbaoReceiveTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *costLabel;

- (void)configKMoneyHongbaoReceiveCellWithModel:(YTPsqptHb *)psqptHb;
@end
