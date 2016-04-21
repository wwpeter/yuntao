//
//  DealRecordDetailCutTableCell.h
//  YT_business
//
//  Created by chun.chen on 15/11/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTTrade;
@class CDealLrTextView;

@interface DealRecordDetailCutTableCell : UITableViewCell
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (strong, nonatomic) CDealLrTextView *payView;
@property (strong, nonatomic) CDealLrTextView *timeView;
@property (strong, nonatomic) CDealLrTextView *orderView;

- (void)configDealRecordDetailCut:(YTTrade *)trade;

@end
