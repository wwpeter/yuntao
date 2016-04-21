//
//  CDealRecordTableHeadView.h
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DealRecordHeadSelectBlock)(NSInteger selectIndex);

@interface CDealRecordTableHeadView : UIView

@property (strong, nonatomic) UIButton*zfbPayBtn;
@property (strong, nonatomic) UIButton*wxPayBtn;
@property (copy, nonatomic) DealRecordHeadSelectBlock selectBlock;
@end
