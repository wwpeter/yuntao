//
//  YTRequestModel.m
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTRequestModel.h"

@implementation YTRequestModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithUrl:(NSString *)url isLoadingMore:(BOOL)isLoadingMore
{
    self = [super init];
    if (self) {
        _url = url;
        _isLoadingMore = isLoadingMore;
    }
    return self;
}

@end
