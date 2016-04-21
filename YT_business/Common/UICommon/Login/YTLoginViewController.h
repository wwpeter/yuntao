//
//  YTLoginViewController.h
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"
#import "YTTaskHandler.h"

typedef void (^loginSuccessBlock)();
typedef void (^loginFailureBlock)();

@interface YTLoginViewController : YTBaseViewController
@property (nonatomic,assign) YTLoginViewType loginType;
@property (nonatomic,copy) loginSuccessBlock successBlock;
@property (nonatomic,copy) loginFailureBlock failureBlock;

@end
