//
//  SearchHbDetailTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/9/29.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTHbShopModel;
@interface SearchHbDetailTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *shopImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *discountLabel;

- (void)configSearchHbDetailCellWithModel:(YTHbShopModel *)shopModel;
@end
