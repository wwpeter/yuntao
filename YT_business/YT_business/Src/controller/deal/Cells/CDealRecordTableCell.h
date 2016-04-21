//
//  CDealRecordTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTTrade;
@class YTAccountDetail;

@interface CDealRecordTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *userImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *orderLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *payLabel;

- (void)configDealTableCellWithIntroModel:(YTTrade *)trade;
- (void)configDealTableCellWithAccountDetailModel:(YTAccountDetail *)accountDetail;
@end
