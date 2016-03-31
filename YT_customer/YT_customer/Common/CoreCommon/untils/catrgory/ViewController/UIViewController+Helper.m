
#import "UIViewController+Helper.h"
#import "YTNavigationController.h"
#import "YTLoginViewController.h"
#import "UIActionSheet+TTBlock.h"
#import "CheckInstalledMapAPP.h"
#import "MarsLocationChange.h"
#import "ApplyUntil.h"
#import "UserLoginHeloper.h"

@implementation UIViewController (Helper)

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
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
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *callString = [NSString stringWithFormat:@"tel:%@",phoneNum];
    NSURL *telURL =[NSURL URLWithString:callString];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
- (void)userLogin
{
    YTLoginViewController* loginVC = [[YTLoginViewController alloc] init];
    loginVC.loginType = LoginViewTypePhone;
    loginVC.successBlock = ^{
        [UserLoginHeloper sharedMange].realyLogin = YES;
    };
    YTNavigationController* navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
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
//    __weak __typeof(self) weakSelf = self;
    [sheet setCompletionBlock:^(UIActionSheet* alertView, NSInteger buttonIndex) {
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
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
            NSString *appName = [ApplyUntil bundleName];
            NSString *urlScheme = @"YCGaoMapBack";
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,destination.latitude, destination.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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
