//
//  DistributePayViewController.h
//  YT_business
//
//  Created by chun.chen on 15/12/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"
#import "YTDistributeMoneyHbModel.h"
#import "DistributeMoneyViewController.h"

@interface DistributePayViewController : YTBaseViewController

@property (nonatomic, strong)YTDistributeMoneyHbModel *hongbao;
@property (nonatomic, assign) CGFloat cost;
@end
