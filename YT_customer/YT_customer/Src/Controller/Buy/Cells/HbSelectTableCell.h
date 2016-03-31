//
//  HbSelectTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HbIntroModel;
@class SingleHbModel;
@protocol HbSelectTableCellDelegate;

@interface HbSelectTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UIButton *leftSelectButton;
@property (strong, nonatomic) UIImageView *hbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *thanLabel;

@property (strong, nonatomic) HbIntroModel *introModel;
@property (weak, nonatomic) id<HbSelectTableCellDelegate> delegate;

- (void)configHbSelectCellWithIntroModel:(HbIntroModel *)introModel;
- (void)configHbSelectCellWithSingleModel:(SingleHbModel *)introModel;
@end

@protocol HbSelectTableCellDelegate <NSObject>
@required
- (void)hbSelectTableCell:(HbSelectTableCell *)cell didSelect:(HbIntroModel *)introModel;
@end
