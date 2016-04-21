//
//  HbPaySuccessViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PaySuccessViewMode) {
    /**< 付款*/
    PaySuccessViewModeHbPay,
    /**< 退款*/
    PaySuccessViewModeRefundPay
};

@interface HbPaySuccessViewController : UIViewController

@property (assign, nonatomic)PaySuccessViewMode viewMode;
@property (assign, nonatomic)BOOL hideButton;
@property (copy, nonatomic)NSString *navigationTitle;
@property (copy, nonatomic)NSString *paySuccessTitle;
@property (copy, nonatomic)NSString *paySuccessDescribe;
@end
