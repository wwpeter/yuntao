//
//  OrderRefundHbTableCell.h
//  YT_business
//
//  Created by chun.chen on 16/1/13.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTCommonHongBao;

@interface OrderRefundHbTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIButton* selectBtn;
@property (strong, nonatomic) UIImageView* hbImageView;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UILabel* describeLabel;
@property (strong, nonatomic) UILabel* costLabel;

- (void)configOrderRefundTableCellModel:(YTCommonHongBao*)hongbao;
@end
