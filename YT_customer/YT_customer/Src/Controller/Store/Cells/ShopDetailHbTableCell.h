//
//  ShopDetailHbTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/8/1.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleHbModel;

@interface ShopDetailHbTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UILabel *remainLabel;

- (void)configShopDetailHbTableCellModel:(SingleHbModel *)hongbao;

@end
