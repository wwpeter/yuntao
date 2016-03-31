//
//  YTResultHbModel.m
//  YT_customer
//
//  Created by chun.chen on 15/9/28.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTResultHbModel.h"
#import "UserMationMange.h"

@implementation YTResultHongbao
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"hongbaoId",
                                                       }];
}
- (NSString *)userLocationDistance
{
    //第一个坐标
    CLLocation* current = [UserMationMange sharedInstance].userLocation;
    NSString* distanceStr = @"";
    if (self.lat != 0 && current.coordinate.latitude != 0) {
        //第二个坐标
        CLLocation* before = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lon];
        // 计算距离
        CLLocationDistance meters = [current distanceFromLocation:before];
        if (meters > 0) {
            if (meters > 100) {
                CGFloat distance = meters / 1000;
                if (distance > 9999) {
                    distanceStr = @">9999km";
                }
                else {
                    distanceStr = [NSString stringWithFormat:@"%.2fkm", distance];
                }
            }
            else {
                distanceStr = [NSString stringWithFormat:@"%.2fm", meters];
            }
        }
//        self.distance = meters;
    }
//    else {
//        self.distance = 0;
//    }
    return distanceStr;
}

@end

@implementation YTResultHbSet

@end

@implementation YTResultHbModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"resultHbSet",
                                                       }];
}
@end
