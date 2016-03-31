//
//  AddBankCardViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseViewController.h"

@class YTBank;

typedef void (^AddBankCardSuccessBlock)(YTBank *bank);

@interface AddBankCardViewController : YTBaseViewController

@property (nonatomic, copy)AddBankCardSuccessBlock addSucessBlock;
@end
