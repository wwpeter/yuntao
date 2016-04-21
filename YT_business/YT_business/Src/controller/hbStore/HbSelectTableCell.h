//
//  HbSelectTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTUsrHongBao;;

@interface HbSelectTableCell : UITableViewCell

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UITextField *textFiled;

- (void)configHbStoreTableListModel:(YTUsrHongBao *)hongbao;

@end
