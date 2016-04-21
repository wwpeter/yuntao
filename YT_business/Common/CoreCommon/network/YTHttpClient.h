//
//  IMHttpClient.h
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface YTHttpClient : AFHTTPRequestOperationManager

+ (YTHttpClient*)client;
- (AFHTTPRequestOperation*)requestWithURL:(NSString*)url
                                    paras:(NSDictionary*)parasDict
                                  success:(void (^)(AFHTTPRequestOperation* operation, NSObject* parserObject))success
                                  failure:(void (^)(AFHTTPRequestOperation* operation, NSError* requestErr))failure;

- (AFHTTPRequestOperation*)requestMultipartWithURL:(NSString*)url
                                        parameters:(NSDictionary*)parasDict
                                             Image:(UIImage*)image
                                           success:(void (^)(AFHTTPRequestOperation* operation, NSObject* parserObject))success
                                           failure:(void (^)(AFHTTPRequestOperation* operation, NSError* requestErr))failure;

@end
