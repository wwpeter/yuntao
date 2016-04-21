//
//  OrderDetailViewController.h
//  YT_business
//
//  Created by chun.chen on 16/1/11.
//  Copyright © 2016年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@class YTOrder;

typedef void (^paySuccessBlock)();

@interface OrderDetailViewController : YTBaseViewController

@property (nonatomic, strong) YTOrder *order;
@property (nonatomic, copy) paySuccessBlock successBlock;
@end
