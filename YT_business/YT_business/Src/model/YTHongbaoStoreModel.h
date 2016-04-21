//
//  YTHongbaoStoreModel.h
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTTradeModel.h"

@interface YTHongbaoStore : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTUsrHongBao> *records;
@end


@interface YTHongbaoStoreModel : YTBaseModel
@property (nonatomic,strong) YTHongbaoStore *hongbaoStore;
@end
