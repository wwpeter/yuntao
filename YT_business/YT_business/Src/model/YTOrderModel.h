//
//  YTOrderModel.h
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTDrainageDetailModel.h"

@protocol YTOrder <NSObject>
@end
@interface YTOrder : YTBaseModel
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int payType;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int totalPrice;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *toOuterId;
@property (nonatomic,copy) NSString *outerPayId;
@property (nonatomic,copy) NSString *sellerShopId;
@property (nonatomic,copy) NSString *sellerShopName;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,strong) NSArray<YTCommonHongBao> *shopBuyHongbaos;
@end

@interface YTOrderSet : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTOrder> *records;
@end

@interface YTOrderModel : YTBaseModel
@property (nonatomic,strong) YTOrderSet *orderSet;
@end
