//
//  YTUserAuthResultModel.h
//  YT_business
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTUserAuthResultPayOrder : YTBaseModel
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *toOuterId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) int originPrice;
@property (nonatomic,assign) int totalPrice;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int payType;
@property (nonatomic,assign) int payChannel;
@property (nonatomic,assign) NSTimeInterval lastTime;
@end

@interface YTUserAuthResultExtras : YTBaseModel
@property (nonatomic,copy) NSString *payInfo;
@property (nonatomic,strong) YTUserAuthResultPayOrder *payOrder;
@end

@interface YTUserAuthResultSet : YTBaseModel
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *createToken;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) NSTimeInterval lastTime;
@property (nonatomic,strong) YTUserAuthResultExtras *extras;
@end

@interface YTUserAuthResultModel : YTBaseModel
@property (nonatomic,strong) YTUserAuthResultSet *authResultSet;
@end
