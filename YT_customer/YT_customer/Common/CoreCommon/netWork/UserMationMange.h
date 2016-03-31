//
//  UserMationMange.h
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INTULocationManager.h"

typedef void(^UserLocationBlock)(CLLocation* currentLocation,NSError *error);

@class UserCityModel;
@interface UserMationMange : NSObject

@property (nonatomic, strong) CLLocation* userLocation;
@property (nonatomic, assign) BOOL didLocation;
@property (nonatomic, assign) INTULocationRequestID locationRequestID;

@property (nonatomic, copy) UserLocationBlock locationBlock;

+ (UserMationMange *)sharedInstance;
- (BOOL)userLogin;
- (NSNumber *)userId;
- (NSString *)payPwd;

- (UserCityModel *)userCityModel;
- (void)setupUserDefaultCity;

- (void)uploadUserLocationBlock:(void (^)(CLLocation* currentLocation,INTULocationStatus status))block;
@end
