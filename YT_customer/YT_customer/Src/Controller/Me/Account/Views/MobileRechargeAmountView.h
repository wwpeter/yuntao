//
//  MobileRechargeAmountView.h
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MobileRechargeAmountViewSelectBlock)(NSNumber *amount);

@interface MobileRechargeAmountView : UIView

@property (copy, nonatomic) MobileRechargeAmountViewSelectBlock selectBlock;
@property (strong, nonatomic) NSArray *amounts;
@end
