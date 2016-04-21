//
//  OrderDetailTableCell.h
//  YT_business
//
//  Created by chun.chen on 16/1/12.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTCommonHongBao;

@interface OrderDetailTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *costLabel;

- (void)configOrderDetailTableCellModel:(YTCommonHongBao *)hongbao;
@end
