//
//  PayViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/8/2.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShopDetailModel;

@interface PayViewController : UIViewController

@property (strong, nonatomic)ShopDetailModel *shopModel;
@property (strong, nonatomic)NSNumber *shopId;

@property (assign, nonatomic)PreferencePayType payType;
@property (assign, nonatomic)BOOL mayChange;
@property (assign, nonatomic)NSInteger payPrice;
@property (assign, nonatomic)NSInteger payChannel;
@property (strong, nonatomic)NSString *authCode;
@end
