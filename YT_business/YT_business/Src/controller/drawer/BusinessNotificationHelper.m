#import "BusinessNotificationHelper.h"
#import "RESideMenu.h"
#import "YTNavigationController.h"
#import "YTNoticeViewController.h"
#import <TSMessages/TSMessage.h>
#import <TSMessages/TSMessageView.h>

NSString* const RED_SHELVES_APPLICATIONS_HAVE_BEEN_SUBMITTED_FOR_REVIEW = @"RED_SHELVES_APPLICATIONS_HAVE_BEEN_SUBMITTED_FOR_REVIEW";
NSString* const RED_SHELVES_APPLICATION_HAS_BEEN_APPROVED = @"RED_SHELVES_APPLICATION_HAS_BEEN_APPROVED";
NSString* const RED_SHELVES_NOT_APPROVED = @"RED_SHELVES_NOT_APPROVED";
NSString* const APPLICATION_ENVELOPES_SHELVES_AUDIT = @"APPLICATION_ENVELOPES_SHELVES_AUDIT";
NSString* const REFUND_REQUEST = @"REFUND_REQUEST";
NSString* const REFUND_SUCCESSFULLY = @"REFUND_SUCCESSFULLY";
NSString* const INFORMATION_AUDIT_BY_MERCHANTS_SETTLED = @"INFORMATION_AUDIT_BY_MERCHANTS_SETTLED";
NSString* const INFORMATION_IS_NOT_AUDITED_BY_MERCHANTS_SETTLED = @"INFORMATION_IS_NOT_AUDITED_BY_MERCHANTS_SETTLED";
NSString* const RED_IS_FORCED_OFF_THE_SHELF_NEWS = @"RED_IS_FORCED_OFF_THE_SHELF_NEWS";
NSString* const RECEIVE_THE_PAYMENT_MESSAGE = @"RECEIVE_THE_PAYMENT_MESSAGE";
NSString* const TRADING_REFUNDS = @"TRADING_REFUNDS";
NSString* const WITHDRAWALS_FILING = @"WITHDRAWALS_FILING";
NSString* const WITHDRAW_COMPLETE = @"WITHDRAW_COMPLETE";
NSString* const PHONE_RECHARGE = @"PHONE_RECHARGE";
NSString* const IT_IS_DIRECTED_DELIVERY = @"IT_IS_DIRECTED_DELIVERY";

@interface BusinessNotificationHelper ()<TSMessageViewProtocol>

@end

@implementation BusinessNotificationHelper
+ (BusinessNotificationHelper*)helper
{
    static BusinessNotificationHelper* helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[BusinessNotificationHelper alloc] init];
    });
    return helper;
}
- (void)openViewControllerReceiveNotificationWith:(NSString*)notificationModelnotificationModel
{
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (![viewController isMemberOfClass:[RESideMenu class]]) {
        return;
    }
//    RESideMenu* windowView = (RESideMenu*)viewController;
//    YTNavigationController* nav = (YTNavigationController*)windowView.contentViewController;
//    NSLog(@"%@", [nav class]);
}
- (void)showNotificationWithTitle:(NSString *)title
{
    UIViewController* viewController = [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController] ;
    if (![viewController isMemberOfClass:[RESideMenu class]]) {
        return;
    }
     [TSMessage dismissActiveNotification];
        RESideMenu* sideMenuVC = (RESideMenu*)viewController;
        YTNavigationController* nav = (YTNavigationController*)sideMenuVC.contentViewController;
        [TSMessage setDelegate:self];
    __weak __typeof(self)weakSelf = self;
    [TSMessage showNotificationInViewController:nav
                                          title:title
                                       subtitle:nil
                                          image:nil
                                           type:TSMessageNotificationTypeMessage
                                       duration:30
                                       callback:^{
                                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                                           [strongSelf pushToNotifyListViewController:nav];
                                       }
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];

}
- (void)pushToNotifyListViewController:(UINavigationController*)nav
{
    [TSMessage dismissActiveNotification];
    YTNoticeViewController *noticeVC = [[YTNoticeViewController alloc] init];
    [nav pushViewController:noticeVC animated:YES];
    
}
- (void)customizeMessageView:(TSMessageView *)messageView
{
    UIButton *colsedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    colsedBtn.frame = CGRectMake(kDeviceWidth-36, 2, 36, 36);
    [colsedBtn setImage:[UIImage imageNamed:@"NotificationColsedBackground.png"] forState:UIControlStateNormal];
    [colsedBtn addTarget:self action:@selector(colsedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:colsedBtn];
}

- (void)colsedButtonClicked:(id)sender
{
    [TSMessage dismissActiveNotification];
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
