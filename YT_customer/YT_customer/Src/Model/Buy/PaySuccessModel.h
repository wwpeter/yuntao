//
//  PaySuccessModel.h
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserPayModelStatus) {
    // 未付款
    UserPayModelStatusWaitePay = 1,
    // 支付成功
    UserPayModelStatusWaitePayed = 2,
    // 撤销
    UserPayModelStatusWaiteCancel = 3,
    // 退款中
    UserPayModelStatusWaiteUserPayRefund = 4,
    // 退款成功
    UserPayModelStatusWaiteUserPayRefundSuccess = 5
};

@interface PaySuccessModel : NSObject
@property (assign, nonatomic) UserPayModelStatus payStatus; // 支付状态
@property (assign, nonatomic) NSInteger reciveStatus; //红包领取状态
@property (strong, nonatomic) NSNumber* orderId; //订单Id;
@property (strong, nonatomic) NSNumber* storeId; // 商户Id
@property (strong, nonatomic) NSString* storeName; // 商户名称
@property (strong, nonatomic) NSString* storeImg; // 商户图片
@property (strong, nonatomic) NSString* consumeTime; // 消费时间
@property (strong, nonatomic) NSString* createTime; // 创建时间
@property (strong, nonatomic) NSString* orderCode; // 订单号
@property (strong, nonatomic) NSString* storePhone; //商户电话
@property (strong, nonatomic) NSString* payStatusStr; //商户状态文字
@property (strong, nonatomic) NSString* message; //商户状态文字
@property (assign, nonatomic) CGFloat maxCost; // 总价值

@property (assign, nonatomic) NSInteger totalPrice; // 支付金额
@property (assign, nonatomic) NSInteger originPrice; // 总金额

@property (strong, nonatomic) NSMutableArray* hbList; //红包列表

- (instancetype)initWithPaySuccessDictionary:(NSDictionary*)dictionary showUserHB:(BOOL)show;
@end
