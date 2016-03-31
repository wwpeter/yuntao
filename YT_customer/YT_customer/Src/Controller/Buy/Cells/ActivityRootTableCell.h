//
//  ActivityRootTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/12/29.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTActivity;

@interface ActivityRootTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *activImageView;

- (void)configCellWithActivity:(YTActivity *)activity;
@end
