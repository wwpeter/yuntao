//
//  PayModeTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/12/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayModeTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *iconImageView;
// 标题
@property (strong, nonatomic) UILabel *titleLabel;
// 说明
@property (strong, nonatomic) UILabel *messageLabel;

- (void)payModeSelect:(BOOL)select;
@end
