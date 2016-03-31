//
//  MoneyHbDetailViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/12/8.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseViewController.h"
@class YTPublish;
@interface MoneyHbDetailViewController : YTBaseViewController
@property (nonatomic, strong)YTPublish *publish;
@property (nonatomic, assign)NSInteger amount;
@property (nonatomic, assign)NSInteger getNum;
@end
