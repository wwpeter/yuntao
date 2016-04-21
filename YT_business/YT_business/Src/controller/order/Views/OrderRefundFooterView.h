//
//  OrderRefundFooterView.h
//  YT_business
//
//  Created by chun.chen on 16/1/13.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderRefundFooterViewRefundBlock)();

@interface OrderRefundFooterView : UIView
@property (nonatomic, strong)UILabel *refundMesLabel;
@property (nonatomic, strong)UILabel *amountLabel;
@property (nonatomic, strong)UILabel *hongbaoNumLabel;
@property (nonatomic, strong)UIButton *refundBtn;

@property (nonatomic, assign)CGFloat amount;
@property (nonatomic, assign)NSInteger hongbaoNum;
@property(nonatomic,getter=isRefundEnabled) BOOL refundEnabled;

@property (nonatomic, copy)OrderRefundFooterViewRefundBlock refundBlock;
@end
