//
//  CStoreReceiveSelectListTableCell.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HbIntroModel;
@interface CStoreReceiveSelectListTableCell : UITableViewCell

@property (assign, nonatomic) BOOL didSetupConstraints;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UILabel *numberLabel;

- (void)configStoreReceiveSelectListTableListModel:(HbIntroModel *)hbModel;

@end
