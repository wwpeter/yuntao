//
//  YTHongbaoPayModel.h
//  YT_business
//
//  Created by chun.chen on 15/7/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTHongbaoPayShopOrder : YTBaseModel
@property (nonatomic,copy) NSString *shopOrderId;
@property (nonatomic,assign) CGFloat totalPrice;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSInteger payType;
@end

@interface YTHongbaoPaySet : YTBaseModel
@property (nonatomic,strong) YTHongbaoPayShopOrder *shopOrder;
@property (nonatomic,copy) NSString *payInfo;
@end

@interface YTHongbaoPayModel : YTBaseModel
@property (nonatomic,strong) YTHongbaoPaySet *hongbaoPay;
@end
