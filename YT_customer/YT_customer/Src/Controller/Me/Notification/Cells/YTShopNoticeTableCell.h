//
//  YTShopNoticeTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/12/8.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTXjswHb;

@interface YTShopNoticeTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UIImageView *rankImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *costLabel;
@property (nonatomic, strong) UILabel *catLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *subtractLabel;

- (void)configShopNoticeCellWithModel:(YTXjswHb *)xjswHb;
@end
