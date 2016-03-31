//
//  UserLoginHeloper.h
//  YT_customer
//
//  Created by chun.chen on 15/7/30.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^loginSuccessBlock)();
typedef void (^loginFailureBlock)();

@interface UserLoginHeloper : NSObject <UIAlertViewDelegate>
@property (nonatomic, assign) BOOL realyLogin;
+ (UserLoginHeloper*)sharedMange;
- (void)userLoginSuccess:(loginSuccessBlock)success
         failure:(loginFailureBlock)failure;

@end
