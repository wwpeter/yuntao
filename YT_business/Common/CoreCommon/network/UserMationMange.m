//
//  UserMationMange.m
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "UserMationMange.h"
#import "YTHttpClient.h"
#import "YTUpdateShopInfoModel.h"
#import "YTRegisterHelper.h"

@implementation UserMationMange

+ (UserMationMange*)sharedInstance
{
    static UserMationMange* sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];

    if (self) {
        self.userLocation = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    }
    return self;
}

- (NSNumber*)userId
{
    NSNumber* uid = [[NSUserDefaults standardUserDefaults] objectForKey:iYTUserIdKey];
    if (uid) {
        return uid;
    }
    else {
        return @0;
    }
}
- (void)updateUserShopInfpSuccess:(void (^)(NSObject* parserObject))success
                          failure:(void (^)(NSString* errMessage))failure
{
    if ([NSStrUtil isEmptyOrNull:[YTUsr usr].shop.shopId]) {
        return;
    }
    NSDictionary* parameters = @{ @"shopId" : [YTUsr usr].shop.shopId };
    wSelf(wSelf);
    [[YTHttpClient client] requestWithURL:shopInfoURL paras:parameters success:^(AFHTTPRequestOperation *operation, NSObject *parserObject) {
        YTUpdateShopInfoModel* shopModel = (YTUpdateShopInfoModel*)parserObject;
        [wSelf updateUserShopData:shopModel];
        if (success) {
            success(parserObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *requestErr) {
        if (failure) {
            failure(@"连接失败");
        }
    }];
//    [[YTHttpClient client] postRequestWithURL:shopInfoURL
//        paras:parameters
//        success:^(AFHTTPRequestOperation* operation, NSObject* parserObject) {
//            YTUpdateShopInfoModel* shopModel = (YTUpdateShopInfoModel*)parserObject;
//            [wSelf updateUserShopData:shopModel];
//            if (success) {
//                success(parserObject);
//            }
//        }
//        failure:^(NSString* errMessage) {
//            if (failure) {
//                failure(errMessage);
//            }
//        }];
}
- (void)updateUserInfo
{
    [[YTHttpClient client] requestWithURL:userInfoURL paras:@{} success:^(AFHTTPRequestOperation *operation, NSObject *parserObject) {
        
    } failure:NULL];
}
- (void)updateUserShopData:(YTUpdateShopInfoModel*)shopModel
{
    [YTUsr usr].shop = shopModel.shopInfo.shop;
    [YTUsr usr].shopCategory = shopModel.shopInfo.shopCategory;
    [YTUsr usr].hjImg = shopModel.shopInfo.hjImg;
    NSData* upUsrData = [NSKeyedArchiver archivedDataWithRootObject:[YTUsr usr]];
    [USERDEFAULT setObject:upUsrData forKey:usrDataKey];
    [USERDEFAULT synchronize];
}
- (void)uploadUserLocation
{
    [self uploadUserLocationBlock:NULL];
}
- (void)uploadUserLocationBlock:(void (^)(CLLocation* currentLocation, NSError* error))block
{
    [self uploadUserLocationCount:0 completionBlock:block];
}
- (void)uploadUserLocationCount:(NSInteger)count completionBlock:(void (^)(CLLocation* currentLocation, NSError* error))block
{
    __weak __typeof(self) weakSelf = self;
    __block NSInteger locCount = count;
    INTULocationManager* locMgr = [INTULocationManager sharedInstance];
    self.locationRequestID = [locMgr subscribeToLocationUpdatesWithBlock:^(CLLocation* currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        __typeof(weakSelf) strongSelf = weakSelf;
        if (status == INTULocationStatusSuccess) {
            NSLog(@"currentLocation = %@", currentLocation);
            if (currentLocation.coordinate.latitude != 0) {
                [strongSelf setupUserLocation:currentLocation];
                if (block) {
                    block(currentLocation, nil);
                }
            }
            else {
                if (count < 3) {
                    [strongSelf uploadUserLocationCount:++locCount completionBlock:block];
                }
            }
        }
        else if (status == INTULocationStatusTimedOut) {
            if (count < 3) {
                [strongSelf uploadUserLocationCount:++locCount completionBlock:block];
            }
            else {
                NSLog(@"获取位置超时");
                if (currentLocation.coordinate.latitude != 0) {
                    [strongSelf setupUserLocation:currentLocation];
                    if (block) {
                        block(currentLocation, NULL);
                    }
                }
                else {
                    [strongSelf showLocationAlert:@"获取位置超时" title:@""];
                }
            }
        }
        else if (status == INTULocationStatusServicesNotDetermined) {
            NSLog(@"User has not yet responded to the dialog that grants this app permission to access location services.");
            [strongSelf showLocationAlert:@"请检查是否同意应用使用位置服务" title:@"无法获取位置"];
        }
        else if (status == INTULocationStatusServicesDenied) {
            NSLog(@"User has explicitly denied this app permission to access location services.");
            [strongSelf showLocationAlert:@"请检查是否打开位置服务" title:@"无法获取位置"];
        }
        else if (status == INTULocationStatusServicesRestricted) {
            NSLog(@"User does not have ability to enable location services (e.g. parental controls, corporate policy, etc).");
            [strongSelf showLocationAlert:@"请检查是否具有位置权限" title:@"无法获取位置"];
        }
        else if (status == INTULocationStatusServicesDisabled) {
            NSLog(@"User has turned off location services device-wide (for all apps) from the system Settings app.");
            [strongSelf showLocationAlert:@"请检查是否打开系统位置服务" title:@"无法获取位置"];
        }
        else if (status == INTULocationStatusError) {
            NSLog(@"An error occurred while using the system location services");
            if (count < 3) {
                [strongSelf uploadUserLocationCount:++locCount completionBlock:block];
            }
            //            else {
            //                [strongSelf showLocationAlert:@"获取本地位置失败" title:@""];
            //            }
        }
        else {
            if (currentLocation.coordinate.latitude != 0) {
                [strongSelf setupUserLocation:currentLocation];
            }
        }
        strongSelf.locationRequestID = NSNotFound;
    }];
}
- (void)setupUserLocation:(CLLocation*)currentLocation
{
    if (currentLocation.coordinate.latitude != 0 && currentLocation.coordinate.latitude == self.userLocation.coordinate.latitude) {
        return;
    }
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray* userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
        objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hans", nil]
                                              forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.userLocation = currentLocation;
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray* placemarks, NSError* error) {
                       for (CLPlacemark* placemark in placemarks) {
                           NSDictionary* dic = [placemark addressDictionary];
                           if (dic[@"City"]) {
                               [YTRegisterHelper registerHelper].city = dic[@"City"];
                           }
                           if (dic[@"State"]) {
                               [YTRegisterHelper registerHelper].province = dic[@"State"];
                           }
                           if (dic[@"SubLocality"]) {
                               [YTRegisterHelper registerHelper].district = dic[@"SubLocality"];
                           }
                       }
                       [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages
                                                                 forKey:@"AppleLanguages"];
                       [[NSUserDefaults standardUserDefaults] synchronize];
                   }];
}
- (void)showLocationAlert:(NSString*)text title:(NSString*)title
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    });
}
@end
