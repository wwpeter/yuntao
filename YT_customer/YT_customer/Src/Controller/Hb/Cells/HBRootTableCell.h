//
//  HBRootTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/9/28.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTResultHongbao;

@interface HBRootTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UIImageView *distanceImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;

- (void)configHbIntroCellWithIntroModel:(YTResultHongbao *)hongbao;

@end
