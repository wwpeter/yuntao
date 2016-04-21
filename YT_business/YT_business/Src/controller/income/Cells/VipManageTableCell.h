//
//  VipManageTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/12/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTHbThrowView.h"

@class YTVipManage;

@interface VipManageTableCell : UITableViewCell
@property (strong, nonatomic) YTHbThrowView *throwsView;
@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *sendLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) UILabel *costLabel;

- (void)configVipManageCellWithModel:(YTVipManage *)vipManage;
@end
