//
//  DistributeKindTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/12/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTHbThrowView.h"

@class YTUsrHongBao;

@interface DistributeKindTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UIImageView* hbImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) YTHbThrowView* throwView;
@property (nonatomic, strong) UILabel* costLabel;

- (void)configDistributeKindCellWithModel:(YTUsrHongBao *)hongbao;

@end
