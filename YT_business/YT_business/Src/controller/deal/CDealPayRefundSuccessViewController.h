//
//  CDealPayRefundSuccessViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@class YTTrade;

@interface CDealPayRefundSuccessViewController : YTBaseViewController

@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) YTTrade *trade;
@end
