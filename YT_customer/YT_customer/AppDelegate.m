#import "AppDelegate.h"
#import "YTLoginRootViewController.h"
#import "YCTabBarViewController.h"
#import "UserMationMange.h"
#import "YTNetworkMange.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YCApi.h"
#import "YCVenderDefine.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "PayUtil.h"
#import "StoreSortMange.h"
//#import <Bugtags/Bugtags.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{

    [[UITabBar appearance] setSelectedImageTintColor:CCCUIColorFromHex(0xfd5c63)];
    BOOL showLogin = [[UserMationMange sharedInstance] userLogin];
    if (showLogin) {
        [YCApi setupCookies];
    }
    else {
        [self showUserLoginViewController];
    }
    // 存储用户城市信息
    [[UserMationMange sharedInstance] setupUserDefaultCity];
    [StoreSortMange updateStoreSortCat];//全部分类
    [self configVender];
    
    return YES;
}
// 显示登录界面
- (void)showUserLoginViewController
{
    YTLoginRootViewController* loginRootViewController = [[YTLoginRootViewController alloc] init];
    [self.window setRootViewController:loginRootViewController];
}
// 显示tabbar界面
- (void)showUserTabBarViewController
{
    UIStoryboard* stryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    YCTabBarViewController* tabBaarViewController = [stryBoard instantiateInitialViewController];
    [self.window setRootViewController:tabBaarViewController];
}

- (void)configVender
{
    [UMSocialData setAppKey:YC_UM_Appkey];
    //打开调试log的开关
//    [UMSocialData openLog:YES];
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:YC_WeiXin_APPID appSecret:YC_WeiXin_Secret url:YC_APP_URL];
    //设置手机QQ的AppId，指定你的分享url，若传nil，将使用友盟的网址
    [UMSocialQQHandler setQQWithAppId:YC_QQ_APPID appKey:YC_QQ_APPKEY url:YC_APP_URL];
    //  设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    [WXApi registerApp:YC_WeiXin_APPID withDescription:@""];
    
//    BOOL valiTest = [[NSUserDefaults standardUserDefaults] boolForKey:iYCUserTestKey];
//    BTGInvocationEventEvent ationEventEvent = valiTest ? BTGInvocationEventBubble : BTGInvocationEventNone;
//    [Bugtags startWithAppKey:@"99ed17f0bff79e64079b8c79c1b90a83" invocationEvent:ationEventEvent];
}
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary* resultDic){

                                                  }];
        return YES;
    }
    if ([WXApi handleOpenURL:url delegate:[PayUtil sharedPayUtil]]) {
        return YES;
    }
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (!result) {
        return YES;
    }
    return YES;
}

/**
 客户端后进入后台，返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication*)application
{
    [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
