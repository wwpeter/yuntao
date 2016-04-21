//
//  KindHongbaoTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTHbThrowView.h"

@class YTUsrHongBao;

@interface KindHongbaoTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView* hbImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) YTHbThrowView* throwView;
@property (nonatomic, strong) UILabel* costLabel;

- (void)configKindHongbaoCellWithModel:(YTUsrHongBao *)hongbao;

@end
