//
//  UIViewController+YTUrl.h
//  YT_business
//
//  Created by chun.chen on 15/6/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YTUrl)
@property (nonatomic, strong) NSDictionary* usrInfo;

- (void)postRequestParas:(NSDictionary*)requestParas
              requestURL:(NSString*)url
                 success:(void (^)(AFHTTPRequestOperation* operation, YTBaseModel* parserObject))success
                 failure:(void (^)(NSString* errorMessage))failure;
@end
