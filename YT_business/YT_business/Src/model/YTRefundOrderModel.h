//
//  YTRefundOrderModel.h
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTRefundOrderDetail <NSObject>
@end
@interface YTRefundOrderDetail : YTBaseModel
@property (nonatomic,assign) int num;
@property (nonatomic,assign) int amount;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) int totalAmount;
@property (nonatomic,copy) NSString *hongbaoId;
@property (nonatomic,copy) NSString *shopOrderId;
@property (nonatomic,copy) NSString *refundOrderId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,copy) NSString *refundOrderDetailId;
@end

@protocol YTRefundOrder <NSObject>
@end
@interface YTRefundOrder : YTBaseModel
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int totalNum;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *reason;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *toOuterId;
@property (nonatomic,assign) int totalAmount;
@property (nonatomic,copy) NSString *shopOrderId;
@property (nonatomic,copy) NSString *refundOrderId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,strong) NSArray<YTRefundOrderDetail> *refundOrderDetails;
@end

@interface YTRefundOrderSet : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTRefundOrder> *records;
@end

@interface YTRefundOrderInfo : YTBaseModel
@property (nonatomic,strong) YTRefundOrderSet *refundOrderSet;
@end

@interface YTRefundOrderModel : YTBaseModel
@property (nonatomic,strong) YTRefundOrderInfo *refundOrderInfo;
@end
