//
//  CDealHbIntroTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YTTradeModel.h"

@interface CDealHbIntroTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UIImageView *hbStatusImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *timeLabel;

- (void)configDealHbIntroCellWithIntroModel:(YTHongBao *)trade;


@end
