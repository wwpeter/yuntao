//
//  YTAuthResultModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTCreateUserAuthModel.h"

@interface YTAuthResultPayOrder : YTBaseModel
@property (nonatomic,assign) BOOL admin;
@property (nonatomic,assign) BOOL isRefund;
@property (nonatomic,copy) NSNumber *orderId;
@property (nonatomic,copy) NSString *createToken;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *toOuterId;
@property (nonatomic,strong) NSNumber *shopId;
@property (nonatomic,strong) NSNumber *shopUserId;
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,assign) NSInteger areaUserId;
@property (nonatomic,assign) NSInteger areaZoneId;
@property (nonatomic,assign) NSInteger assId;
@property (nonatomic,assign) NSInteger cityUserId;
@property (nonatomic,assign) NSInteger cityZoneId;
@property (nonatomic,assign) NSInteger inviteUserId;
@property (nonatomic,assign) NSInteger payType;
@property (nonatomic,assign) NSInteger proportionPay;
@property (nonatomic,assign) NSInteger receiveStatus;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger totalPrice;
@property (nonatomic,assign) NSInteger payChannel;
@property (nonatomic,assign) NSInteger originPrice;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval payTime;
@end

@interface YTAuthResultExtras : YTBaseModel
@property (nonatomic,copy) NSString *payInfo;
@property (nonatomic,strong) YTAuthResultPayOrder *payOrder;
@property (nonatomic,strong) NSDictionary *unifiedOrderClientReqData;
@end

@interface YTAuthResultSet : YTCreateUserAuthSet
@property (nonatomic,strong) YTAuthResultExtras *extras;
@end

@interface YTAuthResultModel : YTBaseModel
@property (nonatomic,strong) YTAuthResultSet *authResultSet;
@end
