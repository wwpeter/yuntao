//
//  YTQueryShopModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTLoginModel.h"

@interface YTQueryShopSet : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTShop> *records;
@end

@interface YTQueryShopModel : YTBaseModel
@property (nonatomic,strong) YTQueryShopSet *shopSet;
@end
