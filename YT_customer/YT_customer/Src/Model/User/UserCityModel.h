//
//  UserCityModel.h
//  YT_customer
//
//  Created by chun.chen on 15/6/22.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCityModel : NSObject<NSCoding>

@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;

@end
