#import "UserMationMange.h"
#import "UserCityModel.h"
#import "YTCityZoneMange.h"

@interface UserMationMange ()
//@property (nonatomic, strong) CLLocationManager *locationManager;
@end
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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(uploadUserLocation)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (BOOL)userLogin
{
    NSNumber* uid = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUserIdKey];
    if (uid) {
        return YES;
    }
    return NO;
}
- (NSNumber*)userId
{
    NSNumber* uid = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUserIdKey];
    if (uid) {
        return uid;
    }
    else {
        return @0;
    }
}
- (NSString *)payPwd
{
    NSString *payPwd = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUserPayPwdKey];
    if (payPwd) {
        return payPwd;
    }else{
        return nil;
    }
}
- (void)setupUserDefaultCity
{
    [[YTCityZoneMange sharedMange] fetchAreaData];
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:iYCUserCityKey]) {
        UserCityModel* cityModel = [[UserCityModel alloc] init];
        [self saveUserCity:cityModel];
    }
}
- (UserCityModel*)userCityModel
{
    NSData* citydata = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUserCityKey];
    UserCityModel* cityModel = [NSKeyedUnarchiver unarchiveObjectWithData:citydata];
    return cityModel;
}
- (void)uploadUserLocation
{
    [self uploadUserLocationBlock:NULL];
}
- (void)uploadUserLocationBlock:(void (^)(CLLocation* currentLocation,INTULocationStatus status))block
{
    [self uploadUserLocationCount:0 completionBlock:block];
}

- (void)uploadUserLocationCount:(NSInteger)count completionBlock:(void (^)(CLLocation* currentLocation,INTULocationStatus status))block
{
    __weak __typeof(self) weakSelf = self;
    __block NSInteger locCount = count;
    INTULocationManager* locMgr = [INTULocationManager sharedInstance];
    self.locationRequestID = [locMgr subscribeToLocationUpdatesWithBlock:^(CLLocation* currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
        __typeof(weakSelf) strongSelf = weakSelf;
        if (status == INTULocationStatusSuccess) {
//            NSLog(@"currentLocation = %@", currentLocation);
            if (currentLocation.coordinate.latitude != 0) {
                [strongSelf setupUserLocation:currentLocation];
            }
            else {
                if (count < 3) {
                    [strongSelf uploadUserLocationCount:++locCount completionBlock:block];
                }
            }
        }
        else if (status == INTULocationStatusTimedOut) {
//            if (count < 3) {
//                [strongSelf uploadUserLocationCount:++locCount completionBlock:block];
//            }
//            else {
                NSLog(@"获取位置超时");
                if (currentLocation.coordinate.latitude != 0) {
                    [strongSelf setupUserLocation:currentLocation];
                }
                else {
                    [strongSelf showLocationAlert:@"获取位置超时" title:@""];
                }
//            }
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
        if (block) {
            block(currentLocation, status);
        }
        strongSelf.locationRequestID = NSNotFound;
    }];
}

#pragma mark -CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    if(error.code == kCLErrorLocationUnknown)
//    {
//         [self showLocationAlert:@"无法获取当前位置信息" title:@""];
//    }
//    else if(error.code == kCLErrorNetwork)
//    {
//        [self showLocationAlert:@"请检查网络" title:@"无法获取位置"];
//    }
//    else if(error.code == kCLErrorDenied)
//    {
//        [self showLocationAlert:@"请检查是否打开位置服务" title:@"无法获取位置"];
//        [manager stopUpdatingLocation];
//    }
//}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *curLocation = [locations lastObject];
//    if (curLocation.coordinate.latitude != 0) {
//        [self setupUserLocation:curLocation];
//        if (self.locationBlock) {
//            self.locationBlock(curLocation,nil);
//        }
//    }
//}

- (void)setupUserLocation:(CLLocation*)currentLocation
{
    self.didLocation = YES;
    if (currentLocation.coordinate.latitude!=0 && currentLocation.coordinate.latitude == self.userLocation.coordinate.latitude) {
        return;
    }
    NSMutableArray* userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-Hans", nil]
                                              forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.userLocation = currentLocation;
//    [[INTULocationManager sharedInstance] cancelLocationRequest:self.locationRequestID];
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray* placemarks, NSError* error) {
                       UserCityModel* cityModel = [[UserCityModel alloc] init];
                       for (CLPlacemark* placemark in placemarks) {
                           NSDictionary* dic = [placemark addressDictionary];
                           if (dic[@"City"]) {
                               cityModel.city = dic[@"City"];
                           }
                           if (dic[@"State"]) {
                               cityModel.province = dic[@"State"];
                           }
                           [self saveUserCity:cityModel];
                       }
                       [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages
                                                                 forKey:@"AppleLanguages"];
                       [[NSUserDefaults standardUserDefaults] synchronize];
                   }];
}
- (void)saveUserCity:(UserCityModel*)cityModel
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* encodedObject = [NSKeyedArchiver archivedDataWithRootObject:cityModel];
    [userDefaults setObject:encodedObject forKey:iYCUserCityKey];
    [userDefaults synchronize];
}
- (void)showLocationAlert:(NSString*)text title:(NSString*)title
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:text delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert show];
    });
}
@end
