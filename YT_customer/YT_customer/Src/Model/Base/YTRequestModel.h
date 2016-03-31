//
//  YTRequestModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTRequestModel : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isLoadingMore;

- (instancetype)initWithUrl:(NSString *)url isLoadingMore:(BOOL)isLoadingMore;

@end
