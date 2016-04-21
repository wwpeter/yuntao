//
//  YTQueryShopHelper.h
//  YT_business
//
//  Created by chun.chen on 15/6/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTQueryShopHelper : NSObject

@property (nonatomic,strong) NSMutableArray *shopArray;

+ (YTQueryShopHelper *)queryShopHelper;

@end
