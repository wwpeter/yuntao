#import "UserLoginHeloper.h"
#import "UIAlertView+TTBlock.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"
#import "NSStrUtil.h"
#import "UserInfomationModel.h"
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "UIAlertView+TTBlock.h"
#import "AppDelegate.h"

@interface UserLoginHeloper ()
@property (nonatomic,copy) loginSuccessBlock successBlock;
@property (nonatomic,copy) loginFailureBlock failureBlock;

@end
@implementation UserLoginHeloper

+ (UserLoginHeloper*)sharedMange
{
    static UserLoginHeloper* sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UserLoginHeloper alloc] init];
    });
    return sharedManager;
}
- (void)userLoginSuccess:(loginSuccessBlock)success
                 failure:(loginFailureBlock)failure
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您的账号已在其他设备登录，是否重新登录" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    __weak __typeof(self)weakSelf = self;
    [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            YTLoginViewController *loginVC = [[YTLoginViewController alloc] init];
            loginVC.loginType = LoginViewTypePhone;
            loginVC.successBlock = ^{
                strongSelf.realyLogin = YES;
                if (success) {
                    success();
                }
            };
            loginVC.failureBlock = ^{
                if (failure) {
                    failure();
                }
            };
            YTNavigationController *navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            [appdelegate.window.rootViewController presentViewController:navigationVC animated:YES completion:NULL];
        }
    }];
    [alert show];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}
@end
