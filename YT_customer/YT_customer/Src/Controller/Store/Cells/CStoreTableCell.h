//
//  CStoreTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CStoreIntroModel;

@interface CStoreTableCell : UITableViewCell


@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIImageView *storeImageView;
@property (strong, nonatomic) UIImageView *rankImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UILabel *catLabel;
@property (strong, nonatomic) UILabel *discountLabel;
@property (strong, nonatomic) UILabel *subtractLabel;

- (void)configStoreCellWithModel:(CStoreIntroModel *)introModel;

@end
