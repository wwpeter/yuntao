//
//  AFHTTPRequestOperation+urlTag.h
//  XiangQu
//
//  Created by yandi on 14/10/29.
//  Copyright (c) 2014年 Qiuyin. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>

@interface AFHTTPRequestOperation (urlTag)
@property (nonatomic, strong) NSString *urlTag;
@property (nonatomic, assign) BOOL isLoadingMore;
@end
