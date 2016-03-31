//
//  CheckInstalledMapAPP.m
//  YT_business
//
//  Created by chun.chen on 15/7/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "CheckInstalledMapAPP.h"

@implementation CheckInstalledMapAPP
-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

+(NSArray *)checkHasOwnApp{
    NSArray *mapSchemeArr = @[@"iosamap://navi",@"baidumap://map/"];
    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"苹果(系统)地图", nil];
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
            if (i == 0){
                [appListArr addObject:@"高德地图"];
            }else if (i == 1){
                [appListArr addObject:@"百度地图"];
            }
        }
    }
    return appListArr;
}

@end
