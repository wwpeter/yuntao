//
//  OrderListModel.h
//  YT_business
//
//  Created by 郑海清 on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleHbModel.h"
@interface OrderListModel : NSObject

@property (strong, nonatomic) NSNumber *orderId;//红包ID
@property (strong, nonatomic) NSNumber *payOrderId;//支付订单号
@property (strong, nonatomic) NSString *shopName;//商店名称
@property (strong, nonatomic) NSNumber *shopId;// 商店Id
@property (strong, nonatomic) NSNumber *orderStatus;//WAITE_PAY(1, "待支付"), TRADE_SUCCESS(2, "交易成功"), REFUNDING(3, "退款中"), REFUNDED(4, "已退款"), CLOSED(5, "已关闭");支付状态
@property (strong, nonatomic) NSArray *hbList;//红包列表
@property (strong, nonatomic) NSNumber *totalPrice;//总价
@property (strong, nonatomic) NSNumber *hbNum;//红包数量


@property (strong, nonatomic) NSDate *creatDate;//创建订单时间
@property (strong, nonatomic) NSDate *closeDate;//关闭订单时间
@property (strong, nonatomic) NSDate *dealDate;//成交时间
@property (strong, nonatomic) NSDate *applyRefundDate;//申请退款时间
@property (strong, nonatomic) NSDate *refundDate;//退款时间


//
@property (strong, nonatomic) NSString *payWayName;
@property (strong, nonatomic) NSString *payWayDetail;
@property (strong, nonatomic) NSString *payWayIconName;


- (instancetype)initWithOrderListDictionary:(NSDictionary *)dictionary;



@end
