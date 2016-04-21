#import "DrainageViewController.h"
#import "HbStoreRootViewController.h"
#import "LeftSideDrawerHelper.h"
#import "PromotionViewController.h"
//#import "MyOrderViewController.h"
#import "AssistanterMangeViewController.h"
#import "CDealRecordViewController.h"
#import "StoreAuditFailViewController.h"
#import "StoreEditInfomationViewController.h"
#import "StoreWaiteAuditViewController.h"
#import "VerifyCodeRootViewController.h"
#import "YTNoticeViewController.h"
#import "YTUserSettingViewController.h"
//#import "YTUserShopCodeViewController.h"
#import "VipIncomViewController.h"
#import "VipManageViewController.h"
#import "YTMoreViewController.h"

@implementation LeftSideDrawerHelper

+ (LeftSideDrawerHelper*)sideDrawerHelper
{
    static LeftSideDrawerHelper* helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[LeftSideDrawerHelper alloc] init];
    });
    return helper;
}

- (id)init
{
    self = [super init];

    if (self) {
        [self businessLeftViewContrllers];
    }
    return self;
}

- (void)businessLeftViewContrllers
{
    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
    YTNavigationController* nav;

    if ([YTUsr usr].shop.status == YTSHOPSTATUSINIT || [YTUsr usr].shop.status == YTSHOPSTATUSAUDIT_WAITMARK) {
        StoreWaiteAuditViewController* storeWaiteAuditVC = [[StoreWaiteAuditViewController alloc] init];
        nav = [[YTNavigationController alloc] initWithRootViewController:storeWaiteAuditVC];
    }
    else if ([YTUsr usr].shop.status == YTSHOPSTATUSAUDIT_NOT_PASS) {
        StoreAuditFailViewController* storeAuditFailVC = [[StoreAuditFailViewController alloc] init];
        nav = [[YTNavigationController alloc] initWithRootViewController:storeAuditFailVC];
    }
    else if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        CDealRecordViewController* center = [[CDealRecordViewController alloc] init];
        nav = [[YTNavigationController alloc] initWithRootViewController:center];
    }
    else {
        DrainageViewController* drainageVC = [[DrainageViewController alloc] init];
        nav = [[YTNavigationController alloc] initWithRootViewController:drainageVC];
    }
    [mutableArray addObject:nav];

    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        for (NSUInteger i = 0; i < 3; i++) {
            [mutableArray addObject:[NSNull null]];
        }
    }
    else {

        for (NSUInteger i = 0; i < 5; i++) {
            [mutableArray addObject:[NSNull null]];
        }
    }
    self.viewControllers = [[NSMutableArray alloc] initWithArray:mutableArray];
}
- (void)replaceNavigationControllerWithIndex:(NSInteger)index
{
    YTNavigationController* nav = [[YTNavigationController alloc] init];
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        if (index == 0) {
            CDealRecordViewController* dealRecordVC = [[CDealRecordViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:dealRecordVC];
        }
        else if (index == 1) {
            VerifyCodeRootViewController* center2 = [[VerifyCodeRootViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:center2];
        }
        else if (index == 2) {
            YTNoticeViewController* center3 = [[YTNoticeViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:center3];
        }
        else if (index == 3) {
            YTUserSettingViewController* center4 = [[YTUserSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
            nav = [[YTNavigationController alloc] initWithRootViewController:center4];
        }
    }
    else {
        if (index == 0) {
            DrainageViewController* drainageVC = [[DrainageViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:drainageVC];
            //            CDealRecordViewController* dealRecordVC = [[CDealRecordViewController alloc] init];
            //            nav = [[YTNavigationController alloc] initWithRootViewController:dealRecordVC];
        }
        //        else if (index == 1) {
        //            DrainageViewController* drainageVC = [[DrainageViewController alloc] init];
        //            nav = [[YTNavigationController alloc] initWithRootViewController:drainageVC];
        //        }
        //        else if (index == 2) {
        //            VerifyCodeRootViewController* verifyCodeRootVC = [[VerifyCodeRootViewController alloc] init];
        //            nav = [[YTNavigationController alloc] initWithRootViewController:verifyCodeRootVC];
        //        }
        //        else if (index == 2) {
        //            PromotionViewController* promotionVC = [[PromotionViewController alloc] init];
        //            nav = [[YTNavigationController alloc] initWithRootViewController:promotionVC];
        //        }
        else if (index == 1) {
            HbStoreRootViewController* hbStoreRootVC = [[HbStoreRootViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:hbStoreRootVC];
        }
        //        else if (index == 5) {
        //            MyOrderViewController* myOrderVC = [[MyOrderViewController alloc] init];
        //            nav = [[YTNavigationController alloc] initWithRootViewController:myOrderVC];
        //        }
        //        else if (index == 6) {
        //            YTUserShopCodeViewController* userShopCodeVC = [[YTUserShopCodeViewController alloc] init];
        //            nav = [[YTNavigationController alloc] initWithRootViewController:userShopCodeVC];
        //        }
        else if (index == 2) {
            VipIncomViewController* vipIncomVC = [[VipIncomViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:vipIncomVC];
        }
        else if (index == 3) {
            VipManageViewController* vipManageVC = [[VipManageViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:vipManageVC];
        }
        else if (index == 4) {
            YTMoreViewController* moreVC = [[YTMoreViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:moreVC];
        }
        else if (index == 5) {
            StoreEditInfomationViewController* storeEditInfomationVC = [[StoreEditInfomationViewController alloc] init];
            nav = [[YTNavigationController alloc] initWithRootViewController:storeEditInfomationVC];
        }
    }
    [self.viewControllers replaceObjectAtIndex:index withObject:nav];
}
@end
