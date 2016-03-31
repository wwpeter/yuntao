//
//  YTCityZoneModel.h
//  YT_customer
//
//  Created by chun.chen on 15/11/18.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTZone : YTBaseModel
@property (nonatomic,copy) NSString *zongId;
@property (nonatomic,copy) NSString *etag;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSArray *areaVoList;
@end

@interface YTCityZoneModel : YTBaseModel
@property (nonatomic,strong) YTZone *zone;
@end
