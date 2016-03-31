//
//  YTModelFactory.h
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTBaseModel.h"

@interface YTModelFactory : NSObject
+ (YTBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict;
@end
