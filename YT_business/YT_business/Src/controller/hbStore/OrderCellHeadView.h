//
//  OrderCellHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTTaskHandler.h"

@interface OrderCellHeadView : UIView

@property (strong, nonatomic) UIView *marginView;
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) dispatch_block_t actionBlock;

- (void)configStatusLabel:(NSInteger)status viewType:(MyOrderListViewType)type;
@end
