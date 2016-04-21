//
//  YTPayTableCell.h
//  YT_business
//
//  Created by chun.chen on 16/1/13.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTPayTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *iconImageView;
// 标题
@property (strong, nonatomic) UILabel *titleLabel;
// 说明
@property (strong, nonatomic) UILabel *messageLabel;

@property (nonatomic) int payType;
@end
