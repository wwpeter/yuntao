//
//  YTNoticeTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTNotice;
@class YTPublish;

@interface YTNoticeTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, getter=isRead) BOOL read;
@property (nonatomic, strong) UIImageView* headImageView;
@property (nonatomic, strong) UIImageView* dotsImageView;
@property (nonatomic, strong) UILabel* mesLabel;
@property (nonatomic, strong) UILabel* timeLabel;

- (void)configNoticeCellWithModel:(YTNotice *)notice;
- (void)configNoticeCellWithPublishModel:(YTPublish *)publish;
@end
