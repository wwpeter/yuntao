//
//  IMHttpClient.m
//  iMei
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "NSStrUtil.h"
#import "YTHttpClient.h"
#import "YTModelFactory.h"
#import "DeviceUtil.h"
//#import "YTToastManager.h"

@implementation YTHttpClient
static YTHttpClient* client;

#pragma mark -client
+ (YTHttpClient*)client
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [YTHttpClient manager];
    });
    return client;
}

#pragma mark -override initWithBaseURL
- (instancetype)initWithBaseURL:(NSURL*)url
{
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer.timeoutInterval = 20;
        self.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        [self.requestSerializer setValue:[DeviceUtil deviceUserAgent] forHTTPHeaderField:@"User-Agent"];
        [self.requestSerializer setValue:@"hongbaoApp" forHTTPHeaderField:@"reqFrom"];
        [self setupCookies];
    }
    return self;
}

#pragma mark -responseObject
- (void)responseObject:(NSObject*)obj withOpenration:(AFHTTPRequestOperation*)operation
{
    
}
- (AFHTTPRequestOperation*)requestWithURL:(NSString*)url
                                    paras:(NSDictionary*)parasDict
                                  success:(void (^)(AFHTTPRequestOperation* operation, NSObject* parserObject))success
                                  failure:(void (^)(AFHTTPRequestOperation* operation, NSError* requestErr))failure
{

    NSMutableArray* fileDataArr = [parasDict objectForKey:postingDataKey];
    BOOL showLoading = ![[parasDict objectForKey:loadingKey] boolValue];
    BOOL isLoadingMore = [[parasDict objectForKey:isLoadingMoreKey] boolValue];
    if (showLoading) {
        // toast
        //[[IMToastManager manager] showprogress];
    }
    NSMutableDictionary* transferParas = [NSMutableDictionary dictionaryWithDictionary:[parasDict mutableCopy]];
    [transferParas removeObjectForKey:loadingKey];
    [transferParas removeObjectForKey:postingDataKey];
    [transferParas removeObjectForKey:isLoadingMoreKey];

    __weak typeof(self) wSelf = self;
    NSString* requestURL = [NSString stringWithFormat:@"%@/%@", hostURL, url];
    if ([url hasPrefix:@"http://"]) {
        requestURL = [NSString stringWithString:url];
    }
    AFHTTPRequestOperation* operation = [self POST:requestURL
        parameters:transferParas
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (fileDataArr.count > 0) {
                NSObject* fileData = fileDataArr.firstObject;
                if ([fileData isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary* fileDict in fileDataArr) {
                        if (fileDict.allKeys.count == 1) {
                            NSObject* fileObj = fileDict.allValues.lastObject;
                            if ([fileObj isKindOfClass:[NSData class]]) {
                                [formData appendPartWithFileData:(NSData*)fileObj name:[fileDict allKeys].lastObject fileName:[NSString stringWithFormat:@"%@.jpg", @"image"] mimeType:@"image/jpeg"];
                            }
                            else if ([fileObj isKindOfClass:[NSArray class]]) {
                                for (int i = 0; i < ((NSArray*)fileObj).count; i++) {
                                    [formData appendPartWithFileData:(NSData*)[(NSArray*)fileObj objectAtIndex:i] name:[NSString stringWithFormat:@"%@[%d]", fileDict.allKeys.lastObject, i] fileName:[NSString stringWithFormat:@"%@.jpg", @"image"] mimeType:@"image/jpeg"];
                                }
                            }
                        }
                    }
                }
                else {
                    if (fileDataArr.count == 1) {
                        NSData* fileData = fileDataArr.firstObject;
                        [formData appendPartWithFileData:fileData name:@"imgFile" fileName:[NSString stringWithFormat:@"%@.jpg", @"image"] mimeType:@"image/jpeg"];
                    }
                    else {
                        for (int i = 0; i < fileDataArr.count; i++) {
                            NSData* fileData = [fileDataArr objectAtIndex:i];
                            [formData appendPartWithFileData:fileData name:[NSString stringWithFormat:@"Filedata%d", i] fileName:[NSString stringWithFormat:@"%d.jpg", i] mimeType:@"image/jpeg"];
                        }
                    }
                }
            }
        }
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            // hideToast
            if (showLoading) {
                //                                                   [[IMToastManager manager] hideprogress];
            }

#ifdef DEBUG
//            NSLog(@"POST transferParas :%@ \n REQUSET URL:%@ \n RESPONSE JSON:%@", transferParas,requestURL,responseObject);
            NSLog(@"message:%@", responseObject[@"message"]);
#endif
            if (!success) {
                return;
            }
            [self saveCookiesWithUrl:requestURL];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                YTBaseModel* model = [YTModelFactory modelWithURL:url
                                                     responseJson:responseObject];
                model.isLoadingMore = operation.isLoadingMore;
                success(operation, model);
            }
            else {
                success(operation, responseObject);
            }

            if (!wSelf) {
                return;
            }
            [wSelf responseObject:responseObject withOpenration:operation];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            if (showLoading) {
                //                                                   [[IMToastManager manager] hideprogress];
            }
            if (!failure) {
                return;
            }
            failure(operation, error);
#ifdef DEBUG
            NSLog(@"REQUSET URL:%@ \n ERROR JSON:%@", requestURL, error);
#endif
        }];
    operation.urlTag = url;
    operation.isLoadingMore = isLoadingMore;
    return operation;
}
- (AFHTTPRequestOperation*)requestMultipartWithURL:(NSString*)url
                                        parameters:(NSDictionary*)parasDict
                                             Image:(UIImage*)image
                                           success:(void (^)(AFHTTPRequestOperation* operation, NSObject* parserObject))success
                                           failure:(void (^)(AFHTTPRequestOperation* operation, NSError* requestErr))failure
{
    __weak typeof(self) wSelf = self;
    NSString* requestURL = [NSString stringWithFormat:@"%@/%@", hostURL, url];
    if ([url hasPrefix:@"http://"]) {
        requestURL = [NSString stringWithString:url];
    }
    AFHTTPRequestOperation* operation = [self POST:requestURL
        parameters:parasDict
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (!image) {
                return;
            }
            NSString* fileName = [NSString stringWithFormat:@"%@.jpg", @"image"];
            NSData* imageData = UIImageJPEGRepresentation(image, 0.5);
            [formData appendPartWithFileData:imageData
                                        name:@"imgFile"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];

        }
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            if (!success) {
                return;
            }
#ifdef DEBUG
            NSLog(@"POSTREQUSET URL:%@ \n RESPONSE JSON:%@",requestURL,responseObject);
#endif
            [self saveCookiesWithUrl:requestURL];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                YTBaseModel* model = [YTModelFactory modelWithURL:url
                                                     responseJson:responseObject];
                model.isLoadingMore = operation.isLoadingMore;
                success(operation, model);
            }
            else {
                success(operation, responseObject);
            }

            if (!wSelf) {
                return;
            }
            [wSelf responseObject:responseObject withOpenration:operation];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            if (!failure) {
                return;
            }
#ifdef DEBUG
            NSLog(@"REQUSET URL:%@ \n ERROR JSON:%@", requestURL, error);
#endif
            failure(operation, error);
        }];
    operation.urlTag = url;
    operation.isLoadingMore = NO;
    return operation;
}
- (void)saveCookiesWithUrl:(NSString*)url
{
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
    //    NSLog(@"---------------------------------------------------------");
    //    NSLog(@"cookie url is %@",url);
    //    for (NSHTTPCookie *cookie in cookies) {
    //        NSLog(@"cookie:\n%@", cookie);
    //    }
    //    NSLog(@"---------------------------------------------------------");
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:iYTUsercookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setupCookies
{
    NSData* cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:iYTUsercookiesKey];
    if ([cookiesdata length]) {
        NSArray* cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie* cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}
@end
