//
//  YTAccountSafeViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/23.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@class YTDetailActionView;

@interface YTAccountSafeViewController : YTBaseViewController
@property (strong, nonatomic) YTDetailActionView *phoneView;
@property (strong, nonatomic) YTDetailActionView *passwordView;
@end
