//
//  YTBaseModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "JSONModel.h"

@interface YTBaseModel : JSONModel
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, assign) BOOL isLoadingMore;
@end
