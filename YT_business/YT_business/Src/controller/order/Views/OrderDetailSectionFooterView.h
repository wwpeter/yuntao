//
//  OrderDetailSectionFooterView.h
//  YT_business
//
//  Created by chun.chen on 16/1/11.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YTOrder;

typedef void (^OrderDetailSectionFooterViewRefundBlock)();

@interface OrderDetailSectionFooterView : UIView

@property (nonatomic, strong) UILabel* hbLabel;
@property (nonatomic, strong) UILabel* orderNumLabel;
@property (nonatomic, strong) UILabel* payOrderNumLabel;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIButton* refundBtn;

@property (nonatomic,copy) OrderDetailSectionFooterViewRefundBlock refundBlock;

- (void)configOrderDetailWithModel:(YTOrder *)order;
@end
