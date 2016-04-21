//
//  YTHongbaoStoreModel.m
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTHongbaoStoreModel.h"

@implementation YTHongbaoStore

@end

@implementation YTHongbaoStoreModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"hongbaoStore":@"data"};
}
@end
