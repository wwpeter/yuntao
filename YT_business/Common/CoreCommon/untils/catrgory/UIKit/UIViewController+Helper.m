
#import "UIViewController+Helper.h"
#import "YTNavigationController.h"
#import "YTLoginViewController.h"
#import "LeftSideDrawerHelper.h"
#import "RESideMenu.h"
#import <MAMapKit/MAMapKit.h>
#import "UIActionSheet+TTBlock.h"
#import "CheckInstalledMapAPP.h"
#import "MarsLocationChange.h"
#import "YTVenderDefine.h"
#import "ApplyUntil.h"

@implementation UIViewController (Helper)

- (void)setExtraCellLineHidden:(UITableView*)tableView
{
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)showAlert:(NSString*)msg title:(NSString*)title
{
    UIAlertView* alert = [[UIAlertView alloc]
            initWithTitle:title
                  message:msg
                 delegate:nil
        cancelButtonTitle:@"关闭"
        otherButtonTitles:nil];
    [alert show];
}
- (void)callPhoneNumber:(NSString*)phoneNum
{
    UIWebView* callWebview = [[UIWebView alloc] init];
    NSString* callString = [NSString stringWithFormat:@"tel:%@", phoneNum];
    NSURL* telURL = [NSURL URLWithString:callString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
- (void)userLogin
{
    YTLoginViewController* loginVC = [[YTLoginViewController alloc] init];
    loginVC.loginType = LoginViewTypePhone;
    YTNavigationController* navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}
- (void)showContentViewControllerAtIndex:(NSInteger)index
{
    NSArray* viewControllers = [LeftSideDrawerHelper sideDrawerHelper].viewControllers;
    if (viewControllers.count <= index) {
        return;
    }
    if ([[viewControllers objectAtIndex:index] isEqual:[NSNull null]]) {
        [[LeftSideDrawerHelper sideDrawerHelper] replaceNavigationControllerWithIndex:index];
    }
    YTNavigationController* nav = viewControllers[index];
    [self.sideMenuViewController setContentViewController:nav
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (void)openNavigation:(CLLocationCoordinate2D)destination destinationNamen:(NSString*)name
{
    NSArray* appListArr = [CheckInstalledMapAPP checkHasOwnApp];
    NSString* sheetTitle = [NSString stringWithFormat:@"导航到 %@", name];
    UIActionSheet* sheet;
    if ([appListArr count] == 1) {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0], nil];
    }
    else if ([appListArr count] == 2) {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0], appListArr[1], nil];
    }
    else if ([appListArr count] == 3) {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0], appListArr[1], appListArr[2], nil];
    }
    __weak __typeof(self) weakSelf = self;
    [sheet setCompletionBlock:^(UIActionSheet* alertView, NSInteger buttonIndex) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (buttonIndex >= appListArr.count) {
            return ;
        }
        NSString* btnTitle = appListArr[buttonIndex];
        if (buttonIndex == 0) {
            MKMapItem* currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem* toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil]];
            toLocation.name = name;
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        }
        else if ([btnTitle isEqualToString:@"高德地图"]) {
            [MAMapServices sharedServices].apiKey = kGaodeiMapKey;
            MANaviConfig* config = [[MANaviConfig alloc] init];
            config.destination = destination;
            config.appScheme = kGaodeiScheme;
            config.appName = [ApplyUntil applicationName];
            config.style = MADrivingStrategyShortest;
            if (![MANavigation openAMapNavigation:config]) {
                [strongSelf showAlert:@"高德地图打开失败" title:@""];
            }
        }
        else if ([btnTitle isEqualToString:@"百度地图"]) {
            
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",destination.latitude, destination.longitude,name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
//            double bdNowLat, bdNowLon;
//            bd_encrypt(destination.latitude, destination.longitude, &bdNowLat, &bdNowLon);
//            NSString* stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving", bdNowLat, bdNowLon, destination.latitude, destination.longitude];
            NSURL* url = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

@end
