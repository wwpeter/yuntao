//
//  ShopDetailViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@interface ShopDetailViewController : YTBaseViewController

@property(nonatomic, copy)NSString *shopId;

-(instancetype)initWithShopId:(NSString *)shopId;

@end
