//
//  BalancesWithdrawViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseViewController.h"

@interface BalancesWithdrawViewController : YTBaseViewController
@property (assign, nonatomic) NSInteger remain;

- (instancetype)initWithRemain:(NSInteger)remain;
@end
