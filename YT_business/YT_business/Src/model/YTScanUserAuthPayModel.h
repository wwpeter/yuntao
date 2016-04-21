//
//  YTScanUserAuthPayModel.h
//  YT_business
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTScanUserAuthPaySet : YTBaseModel
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *createToken;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) NSTimeInterval lastTime;
@end

@interface YTScanUserAuthPayModel : YTBaseModel
@property (nonatomic,strong) YTScanUserAuthPaySet *userAuthPaySet;
@end
