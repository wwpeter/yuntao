//
//  OrderCellFootView.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTOrder;
@interface OrderCellFootView : UIView

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UIButton *payButton;

@property (assign, nonatomic) BOOL showPayButton;
@property (strong, nonatomic) dispatch_block_t payBlock;

- (void)configOrderFootViewWithOrder:(YTOrder *)order;
@end
