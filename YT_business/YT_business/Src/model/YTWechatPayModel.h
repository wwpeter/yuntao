//
//  YTWechatPayModel.h
//  YT_business
//
//  Created by chun.chen on 15/8/19.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTWechatPayShopOrder : YTBaseModel
@property (nonatomic,copy) NSString *shopOrderId;
@property (nonatomic,copy) NSString *outerPayId;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *toOuterId;
@property (nonatomic,copy) NSString *sellerShopId;
@property (nonatomic,copy) NSString *sellerShopName;

@property (nonatomic,assign) CGFloat totalPrice;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger payType;

@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@end

@interface YTWechatpayOrder : YTWechatPayShopOrder
@property (nonatomic,copy) NSString *payOrderId;
@property (nonatomic,copy) NSString *publishId;
@end


@interface YTWechatPayOrderReqData : YTBaseModel
@property (nonatomic,copy) NSString *appId;
@property (nonatomic,copy) NSString *nonceStr;
@property (nonatomic,copy) NSString *packageValue;
@property (nonatomic,copy) NSString *partnerId;
@property (nonatomic,copy) NSString *prepayId;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,assign) NSTimeInterval timeStamp;

@end

@interface YTWechatPaySet : YTBaseModel
@property (nonatomic,strong) YTWechatPayShopOrder *shopOrder;
@property (nonatomic,strong) YTWechatPayOrderReqData *wechatReqData;
@end

@interface YTWechatPayModel : YTBaseModel
@property (nonatomic,strong) YTWechatPaySet *wechatPay;
@end
