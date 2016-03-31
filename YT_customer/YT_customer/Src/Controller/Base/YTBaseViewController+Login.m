//
//  YTBaseViewController+Login.m
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseViewController+Login.h"
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "UIAlertView+TTBlock.h"
#import <objc/runtime.h>

void swizzle_method(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didSwizzleMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didSwizzleMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation YTBaseViewController (Login)
static char* showValueKey;

+ (void)load
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    swizzle_method([self class], @selector(authFromLoginWithReqURL:), @selector(actionShowLogin:));
#pragma clang diagnostic pop
}

#pragma mark -swizzle Method Login
- (void)actionShowLogin:(NSString*)reqUrlAfterAuth
{

    if ([self showValue]) {
        return;
    }
    [self setShowValue:YES];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您的账号已在其他设备登录，是否重新登录" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __weak typeof(self) wSelf = self;
    [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            YTLoginViewController* loginVC = [[YTLoginViewController alloc] init];
            loginVC.loginType = LoginViewTypePhone;
            loginVC.successBlock = ^{
                if (!wSelf) {
                    return;
                }
                __strong typeof(wSelf) sSelf = wSelf;
                NSMutableDictionary* reqParas = [NSMutableDictionary dictionaryWithDictionary:sSelf.requestParas];
                sSelf.requestParas = reqParas;
                sSelf.requestURL = reqUrlAfterAuth;
                [sSelf setShowValue:NO];
            };
            loginVC.failureBlock = ^{
                if (!wSelf) {
                    return;
                }
                __strong typeof(wSelf) sSelf = wSelf;
                [sSelf setShowValue:NO];
                [sSelf cancelLoginEvent];
                [sSelf handlePromptWithUrl:reqUrlAfterAuth];
            };
            YTNavigationController* navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
            [self.view.window.rootViewController presentViewController:navigationVC animated:YES completion:NULL];
        }
    }];
    [alert show];
}

- (BOOL)showValue
{
    return [objc_getAssociatedObject(self, &showValueKey) boolValue];
}

- (void)setShowValue:(BOOL)showValue
{
    objc_setAssociatedObject(self, &showValueKey, @(showValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -handlePromptWithUrl
- (void)handlePromptWithUrl:(NSString*)url
{
}

@end
