//
//  DrainageDetailTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTCommonShop;

@interface DrainageDetailTableCell : UITableViewCell

@property (strong, nonatomic) UIImageView *statusImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *throwLabel;
@property (strong, nonatomic) UILabel *pullLabel;
@property (strong, nonatomic) UILabel *leadLabel;

- (void)configDrainageDetailCellWithModel:(YTCommonShop *)commonShop;

@end
