//
//  KindHongbaoTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/12/8.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTHbThrowView.h"

@class YTResultHongbao;

@interface KindHongbaoTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView* hbImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) YTHbThrowView* throwView;
@property (nonatomic, strong) UILabel* costLabel;

- (void)configKindHongbaoCellWithModel:(YTResultHongbao *)hongbao;

@end
