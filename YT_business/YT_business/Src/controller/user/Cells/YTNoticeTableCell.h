//
//  YTNoticeTableCell.h
//  YT_business
//
//  Created by chun.chen on 16/1/8.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTNotifyMessage;

@interface YTNoticeTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, getter=isRead) BOOL read;
@property (nonatomic, strong) UIImageView* headImageView;
@property (nonatomic, strong) UIImageView* dotsImageView;
@property (nonatomic, strong) UILabel* mesLabel;
@property (nonatomic, strong) UILabel* timeLabel;

- (void)configNoticeCellWithModel:(YTNotifyMessage *)notice;

@end
