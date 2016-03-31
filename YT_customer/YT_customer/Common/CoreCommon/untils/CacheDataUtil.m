//
//  CacheDataUtil.m
//  DangKe
//
//  Created by lv on 15/3/24.
//  Copyright (c) 2015年 lv. All rights reserved.
//

#import "CacheDataUtil.h"
#import "ABSaveSystem.h"
@implementation CacheDataUtil

+ (void)saveData:(id)cacheObject withFileName:(NSString*)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = ArchiveFilePath(kYCDataFileName);
    if(![fileManager fileExistsAtPath:filePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dataPath = [path stringByAppendingPathComponent:kYCDataFileName];
        [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [ABSaveSystem saveObject:cacheObject key:fileName];
    });

}
+ (id)loadCacheObjectWithFileName:(NSString*)fileName
{
   id object = [ABSaveSystem objectForKey:fileName];
    return object;
}
+ (void)cleanCacheWithFileName:(NSString *)fileName
{
    [ABSaveSystem removeValueForKey:fileName];
}
+ (void)cleanAllUserCache
{
    
}

@end
