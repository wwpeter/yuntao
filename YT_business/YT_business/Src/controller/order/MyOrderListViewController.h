//
//  MyOrderListViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/1.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"
#import "YTTaskHandler.h"

@interface MyOrderListViewController : YTBaseViewController
@property (assign, nonatomic) MyOrderListViewType viewType;

- (instancetype)initWithOrderListVieType:(MyOrderListViewType)type;
@end
