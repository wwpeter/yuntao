#import "AppDelegate.h"
#import "BusinessLeftSideDrawerViewController.h"
#import "YTNavigationController.h"
#import "YTRegisterHelper.h"
#import "YTLoginModel.h"
#import "UserMationMange.h"
#import "ViewController.h"
#import "LeftSideDrawerHelper.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RESideMenu.h"
#import "APService.h"
#import "UserMationMange.h"
#import "BusinessNotificationHelper.h"
#import "YTTaskHandler.h"
#import "WXApi.h"
#import "ApplyUntil.h"
#import "YTVenderDefine.h"
#import "YTCityZoneMange.h"

@interface AppDelegate () <RESideMenuDelegate,WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    NSData* usrData = [USERDEFAULT dataForKey:usrDataKey];
    if (usrData) {
        [self showBusinessDrawerViewController];
    }
    [self registerPush:launchOptions];
    [[YTCityZoneMange sharedMange] fetchAreaData];
    [WXApi registerApp:kWechatAppId withDescription:[ApplyUntil applicationName]];
    return YES;
}
#pragma mark - Wechat onResp
- (void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
         PayResp *response = (PayResp *)resp;
        [NOTIFICENTER postNotificationName:kWechatPayRespNotification object:response];
    }
}
//注册推送
- (void)registerPush:(NSDictionary*)launchOptions
{
// Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
//    [APService setDebugMode];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTagsAndAlias)
                                                 name:kUserLoginSuccessNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getNotification:)
                                                 name:kJPFNetworkDidReceiveMessageNotification
                                               object:nil];
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (!remoteNotification) {
//        [self userDidReceiveNotification:remoteNotification];
    }

}
- (void)configPretreatment
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* filePath = ArchiveFilePath(iYTImageFileName);
    if (![fileManager fileExistsAtPath:filePath]) { //如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* dataPath = [path stringByAppendingPathComponent:iYTImageFileName];
        [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
#pragma mark -rootViewController
- (void)showBusinessDrawerViewController
{
    if ([YTUsr usr].type == LoginViewTypeBusiness) {
        [[UserMationMange sharedInstance] updateUserInfo];
        [[UserMationMange sharedInstance] updateUserShopInfpSuccess:^(NSObject* parserObject) {
        } failure:^(NSString* errMessage){
        }];
    }
    BusinessLeftSideDrawerViewController* leftSideDrawerViewController = [[BusinessLeftSideDrawerViewController alloc] init];
    if ([LeftSideDrawerHelper sideDrawerHelper].viewControllers.count == 0) {
        [[LeftSideDrawerHelper sideDrawerHelper] businessLeftViewContrllers];
    }
    NSArray* viewControllers = [LeftSideDrawerHelper sideDrawerHelper].viewControllers;
    YTNavigationController* navigationController = [viewControllers firstObject];

    RESideMenu* sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftSideDrawerViewController
                                                                   rightMenuViewController:nil];
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"yt_leftSide_background_full.png"];
    sideMenuViewController.menuPreferredStatusBarStyle = UIStatusBarStyleDefault;
    sideMenuViewController.delegate = self;
    sideMenuViewController.scaleContentView = NO;
    sideMenuViewController.scaleMenuView = NO;

    NSString* xStr = [NSString stringWithFormat:@"%.f", 70 / (CGRectGetWidth(self.window.bounds) / 320)];
    sideMenuViewController.contentViewInPortraitOffsetCenterX = [xStr floatValue];
    sideMenuViewController.bouncesHorizontally = NO;

    [self.window setRootViewController:sideMenuViewController];
}
- (void)showLoginRootView
{
    UIStoryboard* stryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController* loginRootVC = [stryBoard instantiateInitialViewController];
    [self.window setRootViewController:loginRootVC];
}
#pragma mark -startLocationService
- (void)startLocationService
{
    [[UserMationMange sharedInstance] uploadUserLocationBlock:^(CLLocation* currentLocation,NSError *error){
        [YTRegisterHelper registerHelper].lat = currentLocation.coordinate.latitude;
        [YTRegisterHelper registerHelper].lon = currentLocation.coordinate.longitude;
    }];
}
#pragma mark -Notification Push
- (void)userDidReceiveNotification:(NSDictionary*)remoteNotification
{
//    [BusinessNotificationHelper openViewControllerReceiveNotificationWith:nil];
}
//接收自定义消息
- (void)getNotification:(NSNotification*)sender
{
    [APService handleRemoteNotification:sender.userInfo];
}
//设置别名
- (void)setTagsAndAlias
{
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        [APService setTags:[[NSSet alloc] initWithArray:@[ @"SALE", @"ALL" ]] alias:[NSString stringWithFormat:@"hb_userId_%@", [YTUsr usr].usrId] callbackSelector:nil object:nil];
    }
    else {
        [APService setTags:[[NSSet alloc] initWithArray:@[ @"BIZ", @"ALL" ]] alias:[NSString stringWithFormat:@"hb_userId_%@", [YTUsr usr].usrId] callbackSelector:nil object:nil];
    }
}
/**
 客户端后进入后台，返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication*)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 更新用户位置
    [self startLocationService];
    
//    [[BusinessNotificationHelper helper] showNotificationWithTitle:@"用户xxx象您支付了100元"];
}
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary* resultDic){

                                                  }];
        return YES;
    }
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}
#pragma mark - PushBack
// iOS8 加入注册推送设备信息 自动回调
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{

    [APService registerDeviceToken:deviceToken];
    [APService setTags:[[NSSet alloc] initWithArray:@[ @"ALL" ]] alias:@"hb_userId_ " callbackSelector:nil object:nil];
}
// 获取远程通知
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [APService handleRemoteNotification:userInfo];
}
// iOS7 更新获取远程通知
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    // IOS 7 Support Required
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//     [self userDidReceiveNotification:aps];
//}

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
