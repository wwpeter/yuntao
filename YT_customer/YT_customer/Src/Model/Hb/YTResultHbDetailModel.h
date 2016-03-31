//
//  YTResultHbDetailModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/29.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTHbShopModel.h"
#import "YTResultHbModel.h"

@interface YTResultHbDetail : YTBaseModel
@property (nonatomic,strong) NSArray<YTHbShopModel> *shops;
@property (nonatomic,strong) YTResultHongbao *hongbao;
@end

@interface YTResultHbDetailModel : YTBaseModel
@property (nonatomic,strong) YTResultHbDetail *hbDetail;
@end
