//
//  MarsLocationChange.h
//  YT_business
//
//  Created by chun.chen on 15/7/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
//火星转百度坐标
void bd_decrypt(double bd_lat, double bd_lon, double *gg_lat, double *gg_lon);
//百度坐标转火星
void bd_encrypt(double gg_lat, double gg_lon, double *bd_lat, double *bd_lon);

@interface MarsLocationChange : NSObject

@end
