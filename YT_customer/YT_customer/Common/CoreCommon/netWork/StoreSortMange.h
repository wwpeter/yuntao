//
//  StoreSortMange.h
//  YT_customer
//
//  Created by chun.chen on 15/6/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreSortMange : NSObject
+ (id)storeSortAreaWithProvince:(NSString *)province city:(NSString *)city;
+ (void)updateStoreSortCat;
@end
