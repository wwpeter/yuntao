//
//  VipIncomTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/10/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTIncome;

@interface VipIncomTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UILabel *mesLabel;

- (void)configIncomTableCellWithModel:(YTIncome*)income;

@end
