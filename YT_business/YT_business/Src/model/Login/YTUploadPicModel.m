//
//  YTUploadPicModel.m
//  YT_business
//
//  Created by chun.chen on 15/11/26.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTUploadPicModel.h"

@implementation YTUploadPicModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"url":@"data"};
}
@end
