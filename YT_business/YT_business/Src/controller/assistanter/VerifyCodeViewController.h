//
//  VerifyCodeViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@protocol VerifyCodeViewControllerDelegate;

@interface VerifyCodeViewController : UIViewController

@property (weak, nonatomic) id<VerifyCodeViewControllerDelegate> delegate;

@end


@protocol VerifyCodeViewControllerDelegate <NSObject>
@optional
- (void)verifyCodeViewController:(VerifyCodeViewController *)controller didverifyResult:(NSString *)result;

@end