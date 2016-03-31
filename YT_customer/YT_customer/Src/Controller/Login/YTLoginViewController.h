//
//  YTLoginViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YTLoginViewType) {

    LoginViewTypeBusiness,

    LoginViewTypeProxt,
 
    LoginViewTypePhone
};

typedef void (^loginSuccessBlock)();
typedef void (^loginFailureBlock)();

@interface YTLoginViewController : UIViewController

@property (assign, nonatomic) YTLoginViewType loginType;
@property (nonatomic,copy) loginSuccessBlock successBlock;
@property (nonatomic,copy) loginFailureBlock failureBlock;

@end
