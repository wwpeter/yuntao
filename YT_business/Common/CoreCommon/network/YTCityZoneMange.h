//
//  YTCityZoneMange.h
//  YT_business
//
//  Created by chun.chen on 15/11/17.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const iYTCityZoneData =  @"city_zone.plist";

@interface YTCityZoneMange : NSObject
+ (YTCityZoneMange *)sharedMange;
+ (NSArray *)allProvinces;
- (void)fetchAreaData;
@end
