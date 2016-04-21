//
//  UserMationMange.h
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INTULocationManager.h"

@interface UserMationMange : NSObject

@property (nonatomic, strong) CLLocation* userLocation;
@property (nonatomic, assign) INTULocationRequestID locationRequestID;

+ (UserMationMange *)sharedInstance;
- (NSNumber *)userId;
- (void)updateUserInfo;
- (void)updateUserShopInfpSuccess:(void (^)(NSObject* parserObject))success
                          failure:(void (^)(NSString* errMessage))failure;
- (void)uploadUserLocationBlock:(void (^)(CLLocation* currentLocation,NSError *error))block;

@end
