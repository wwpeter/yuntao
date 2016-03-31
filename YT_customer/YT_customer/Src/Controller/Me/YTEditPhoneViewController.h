//
//  YTEditPhoneViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/9/8.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EditSuccessBlock)(NSString *mobile);

@interface YTEditPhoneViewController : UIViewController

@property (nonatomic,copy) EditSuccessBlock editSuccessBlock;

@end
