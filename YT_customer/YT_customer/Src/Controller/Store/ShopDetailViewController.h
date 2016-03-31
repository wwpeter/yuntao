//
//  ShopDetailViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/8/1.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopDetailViewController : UIViewController

@property(nonatomic, assign)BOOL isPromotion;
@property(nonatomic, copy)NSNumber *shopId;

-(instancetype)initWithShopId:(NSNumber *)shopId;

@end
