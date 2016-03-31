//
//  YTNetworkMange.h
//  YT_business
//
//  Created by chun.chen on 15/6/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "YCApi.h"

@interface YTNetworkMange : AFHTTPRequestOperationManager

@property (nonatomic, assign) NSInteger errorCode;

+ (YTNetworkMange*)sharedMange;

- (void)getInfoDataWithServiceUrl:(NSString*)urlString
                        parameters:(NSDictionary*)parameters
                           success:(void (^)(id responseData))success
                           failure:(void (^)(NSString* errorMessage))failure;

/**
 * post方法, 一般用于向服务器端SAVE数据的接口，适合数据量较大的。
 */
/*
 eg:
 NSDictionary *parameters = @{@"phone":@"xxx"};
 [[YTNetworkMange sharedMange] postResultWithServiceUrl:YT_RegMobile parameters:parameters success:^(id responseData) {
 
 } failure:^(NSString *errorMessage) {
 
 }];
 */
- (void)postResultWithServiceUrl:(NSString*)urlString
                      parameters:(NSDictionary*)parameters
                     success:(void (^)(id responseData))success
                     failure:(void (^)(NSString* errorMessage))failure;

/**
 *   用post方法,特别用于单张图片指定文件名上传
 *
 *  @param method       服务器路径
 *  @param parameters   参数
 *  @param image        图片
 *  @param imageName    图片名称
 */
- (void)postResultWithServiceUrl:(NSString *)urlString
                      parameters:(NSDictionary *)parameters
                     singleImage:(UIImage *)image
                       imageName:(NSString *)imageName
                         success:(void (^) (id responseData))success
                         failure:(void (^) (NSString *errorMessage))failure;
/**
 *  上传多张图片
 *
 *  @param images   上传的图片数组
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)postFromWithImages:(NSArray*)images
                   success:(void (^)(id responseData))success
                   failure:(void (^)(NSString* errorMessage))failure;


@end
