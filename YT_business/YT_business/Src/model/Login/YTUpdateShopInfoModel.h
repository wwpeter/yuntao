//
//  YTUpdateShopInfoModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/29.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTDrainageDetailModel.h"

@protocol YTUpdateShopInfo <NSObject>
@end

@interface YTUpdateShopInfo : YTBaseModel
@property (nonatomic,strong) YTShop *shop;
@property (nonatomic,strong) NSArray<YTImage> *hjImg;
@property (nonatomic,strong) YTCategory*shopCategory;
@property (nonatomic,copy) NSString *shopHtmlUrl;
@property (nonatomic,strong) NSArray<YTCommonHongBao> *receiveableHongbao;
@end

@interface YTUpdateShopInfoModel : YTBaseModel
@property (nonatomic,strong) YTUpdateShopInfo *shopInfo;
@end
