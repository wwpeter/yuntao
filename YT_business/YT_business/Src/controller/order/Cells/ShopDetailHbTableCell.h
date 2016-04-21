//
//  ShopDetailHbTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/7/14.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTCommonHongBao;

@interface ShopDetailHbTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UILabel *remainLabel;

- (void)configShopDetailHbTableCellModel:(YTCommonHongBao *)hongbao;

@end
