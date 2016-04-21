//
//  YTBarPayModel.h
//  YT_business
//
//  Created by chun.chen on 15/7/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTBarPayOrder : YTBaseModel
@property (nonatomic,copy) NSString *assId;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *payTime;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *shop;
@property (nonatomic,copy) NSString *shopId;
@property (nonatomic,copy) NSString *shopUserId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *toOuterId;
@property (nonatomic,assign) int payType;
@property (nonatomic,assign) int receiveStatus;
@property (nonatomic,assign) int totalPrice;
@property (nonatomic,assign) int status;

@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,assign) NSTimeInterval createdAt;
@end

@interface YTBarPaySet : YTBaseModel
@property (nonatomic, strong)NSString *payInfo;
@property (nonatomic, strong)YTBarPayOrder *payOrder;
@end

@interface YTBarPayModel : YTBaseModel
@property (nonatomic, strong)YTBarPaySet *barPaySet;
@end
