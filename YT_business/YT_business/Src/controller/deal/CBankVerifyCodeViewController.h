//
//  CBankVerifyCodeViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@interface CBankVerifyCodeViewController : YTBaseViewController

@property (strong, nonatomic)NSString *phoneNum;

- (instancetype)initWithPhoneNum:(NSString *)phoneNum;

@end
