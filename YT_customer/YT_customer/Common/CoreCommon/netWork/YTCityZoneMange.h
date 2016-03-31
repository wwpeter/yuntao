//
//  YTCityZoneMange.h
//  YT_customer
//
//  Created by chun.chen on 15/11/18.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const iYTCityZoneData =  @"city_zone.plist";

@interface YTCityZoneMange : NSObject

+ (YTCityZoneMange *)sharedMange;
+ (NSArray *)allProvinces;
- (void)fetchAreaData;

@end
