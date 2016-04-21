//
//  DealRecordDetailSalesTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/11/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealRecordDetailSalesTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@end
