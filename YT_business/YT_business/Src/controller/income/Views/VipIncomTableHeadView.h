//
//  VipIncomTableHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/10/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IncomCostView;

@interface VipIncomTableHeadView : UIView

@property (nonatomic, strong)IncomCostView *leftView;
@property (nonatomic, strong)IncomCostView *rightView;

@property (nonatomic, copy)NSString *totalIncome;
@property (nonatomic, copy)NSString *yesterdayIncom;

@end


@interface IncomCostView : UIView

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *costLabel;

@end