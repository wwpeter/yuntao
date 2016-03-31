//
//  YTBaseViewController.h
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTRequestModel.h"
#import "YTBaseModel.h"
#import "YCApi.h"

@interface YTBaseViewController : UIViewController

@property (nonatomic,   copy) NSString *requestURL;
@property (nonatomic, strong) NSDictionary *requestParas;
//
- (void)actionFetchRequest:(YTRequestModel *)request result:(YTBaseModel *)parserObject
              errorMessage:(NSString *)errorMessage;

- (void)cancelLoginEvent;
@end
