//
//  DeviceUtil.h
//  DangKe
//
//  Created by lv on 15/3/20.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceUtil : NSObject

+ (NSString *)deviceSystemName;
+ (NSString *)deviceSystemVersion;
+ (NSString *)devicesUUID;

+ (NSString *)deviceVersion;
+ (NSString *)deviceUserAgent;

@end
