//
//  MobileRechargeAmountView.h
//  YT_business
//
//  Created by chun.chen on 15/7/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MobileRechargeAmountViewSelectBlock)(NSNumber *amount);

@interface MobileRechargeAmountView : UIView
@property (copy, nonatomic) MobileRechargeAmountViewSelectBlock selectBlock;
@property (strong, nonatomic) NSArray *amounts;
@end
