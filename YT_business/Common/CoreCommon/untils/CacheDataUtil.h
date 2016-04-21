//
//  CacheDataUtil.h
//  DangKe
//
//  Created by lv on 15/3/24.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import <Foundation/Foundation.h>

// 搜索 缓存数据
static NSString *const iYTUserSearchStoreData =  @"UserSearchStoreData";

@interface CacheDataUtil : NSObject

+ (void)saveData:(id)cacheObject withFileName:(NSString*)fileName;
+ (id)loadCacheObjectWithFileName:(NSString*)fileName;
+ (void)cleanAllUserCache;
+ (void)cleanCacheWithFileNmae:(NSString *)fileName;
@end
