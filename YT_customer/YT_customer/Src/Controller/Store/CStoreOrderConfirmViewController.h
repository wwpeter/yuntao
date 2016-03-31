//
//  CStoreOrderConfirmViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CStoreOrderConfirmViewController : UIViewController

@property (strong, nonatomic) NSArray *confirmOrders;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSDictionary *payReturnDic;

- (instancetype)initWithShopName:(NSString *)name shopId:(NSNumber *)shopId hbConfirmOrders:(NSArray *)confirmOrders;

@end
