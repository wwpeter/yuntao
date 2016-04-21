//
//  YTCityMatch.h
//  YT_business
//
//  Created by chun.chen on 15/6/26.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTCityMatch : YTBaseModel
@property (nonatomic,assign) NSInteger zoneId;
@property (nonatomic,assign) NSInteger level;
@property (nonatomic,assign) NSInteger parentId;
@property (nonatomic,assign) NSInteger zipCode;
@property (nonatomic,copy)   NSString *name;
@property (nonatomic,copy)   NSString *path;
@end


@interface YTCityMatchModel : YTBaseModel
@property (nonatomic,strong) YTCityMatch *cityMatch;
@end