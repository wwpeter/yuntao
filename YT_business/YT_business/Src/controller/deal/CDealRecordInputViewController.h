//
//  CDealRecordInputViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

typedef NS_ENUM(NSInteger, DealRecordInputMode) {
    // 收款
    DealRecordInputModeCollection,
    // 验证红包
    DealRecordInputModeVerify
};

@interface CDealRecordInputViewController : YTBaseViewController

@property (nonatomic) DealRecordInputMode inputMode;
@property (nonatomic) YTPayType payType;
@property (nonatomic, copy) NSString *totalAmount;
@end
