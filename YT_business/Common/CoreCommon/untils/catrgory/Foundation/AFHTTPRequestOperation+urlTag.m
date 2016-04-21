//
//  AFHTTPRequestOperation+urlTag.m
//  XiangQu
//
//  Created by yandi on 14/10/29.
//  Copyright (c) 2014年 Qiuyin. All rights reserved.
//

#import "AFHTTPRequestOperation+urlTag.h"
static char *operationUrlTag;
static char *operationLoadingMore;

@implementation AFHTTPRequestOperation (urlTag)

- (void)setUrlTag:(NSString *)urlTag {
    objc_setAssociatedObject(self, &operationUrlTag, urlTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)urlTag{
    return objc_getAssociatedObject(self, &operationUrlTag);
}

- (void)setIsLoadingMore:(BOOL)isLoadingMore {
    objc_setAssociatedObject(self, &operationLoadingMore, @(isLoadingMore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isLoadingMore {
    return [objc_getAssociatedObject(self, &operationLoadingMore) boolValue];
}
@end
