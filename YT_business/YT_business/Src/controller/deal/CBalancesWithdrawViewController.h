//
//  CBalancesWithdrawViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@interface CBalancesWithdrawViewController : YTBaseViewController

@property (assign, nonatomic) NSInteger remain;

- (instancetype)initWithRemain:(NSInteger)remain;
@end
