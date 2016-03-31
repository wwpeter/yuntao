//
//  HbIntroTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>



@class HbIntroModel;
@interface HbIntroTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UIImageView *hbStatusImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *timeLabel;

- (void)configHbIntroCellWithIntroModel:(HbIntroModel *)introModel;

@end
