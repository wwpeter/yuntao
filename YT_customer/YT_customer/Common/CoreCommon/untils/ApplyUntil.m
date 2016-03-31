//
//  ApplyUntil.m
//  DangKe
//
//  Created by lv on 15/5/18.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import "ApplyUntil.h"

@implementation ApplyUntil

+ (NSNumber *)bigAppid {
    return @1;
}
+ (NSNumber *)appid {
    return @4;
}
+ (NSNumber *)plat {
    return @1;
}
+ (NSNumber *)channel {
    return @1;
}
+ (NSNumber *)gap {
    return @0;
}
+ (NSString*)version
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleShortVersionString"];
}
+ (NSString*)build
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:(NSString*)kCFBundleVersionKey];
}
+ (NSString*)bundleId
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:(NSString*)kCFBundleIdentifierKey];
}
+ (NSString*)bundleName
{
    NSDictionary* bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:(NSString*)kCFBundleNameKey];
}


@end
