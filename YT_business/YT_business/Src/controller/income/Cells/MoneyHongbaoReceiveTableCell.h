//
//  MoneyHongbaoReceiveTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
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
