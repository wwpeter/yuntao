//
//  taskHandler.h
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YTPayType) {
    /**< 支付宝支付*/
    YTPayTypeZfb = 1,
    /**< 微信支付*/
    YTPayTypeWechat = 2
};
typedef NS_ENUM(NSInteger, YTSHOPSTATUS) {
    /**< 待审核*/
    YTSHOPSTATUSINIT = 0,
    /**< 审核通过*/
    YTSHOPSTATUSAUDIT_PASS = 1,
    /**< 审核未通过*/
    YTSHOPSTATUSAUDIT_NOT_PASS = 2,
    /**< 等待审核*/
    YTSHOPSTATUSAUDIT_WAITMARK = 3,
    /**< 等待入驻*/
    YTSHOPSTATUSAUDIT_WAIT = 4,
};

typedef NS_ENUM(NSInteger, YTLoginViewType) {
    /**< 商户登录*/
    LoginViewTypeBusiness = 3,
    /**< 营业员登录*/
    LoginViewTypeAsstanter = 5,
    LoginViewTypeProxt,
    LoginViewTypePhone
};

typedef NS_ENUM(NSUInteger, YTPAYSTATUS) {
    /**< 未付款*/
    YTPAYSTATUS_WAITEPAY= 1,
    /**< 已付款*/
    YTPAYSTATUS_PAYED= 2,
    /**< 撤销*/
    YTPAYSTATUS_CANCEL= 3,
    /**< 退款中*/
    YTPAYSTATUS_USERPAYREFUND= 4,
    /**< 退款成功*/
    YTPAYSTATUS_USERPAYREFUNDSUCESS =5
};
typedef NS_ENUM(NSUInteger, YTPAYTYPE) {
    /**< 用户付款*/
    YTPAYTYPE_USERPAY = 1,
    /**< 当面付*/
    YTPAYTYPE_FACEPAY = 2,
    /**< 退款*/
    YTPAYTYPE_FACErREFUND = 3
};
typedef NS_ENUM(NSUInteger, YTACCOUNTDETAILTYPE) {
    /**< 买红包分润*/
    SHOP_BUY_HONGBAO = 1,
    /**< 退款红包分润*/
    REFUND_ORDER_DETAIL = 2,
    /**< 话费充值*/
    SMS_CHARGE = 3,
    /**< 用户付款成功*/
    USER_PAY = 4,
    /**< 当面付*/
    DAN_MIAN_FU = 5,
    /**< 当面付撤销*/
    DANG_MIAN_FU_CANCEL = 6,
    /**< 余额提现*/
    CASHOUT = 7,
    /**< 退款成功*/
    USER_PAY_REFUND = 8
    
};
typedef NS_ENUM(NSUInteger, YTRECEIVESTATUS) {
    YTRECEIVESTATUS_UNRECEIVE =  1,
    YTRECEIVESTATUS_RECEIVED 
};

// 引流红包状态
typedef NS_ENUM(NSUInteger, YTDRAINAGESTATUS) {
    /** *  待定价 */
    YTDRAINAGESTATUS_PRECONFIRMPRICE = 0,
    /** *  待商户确认 */
    YTDRAINAGESTATUS_PRECONFIRMSHOP,
    /** *  待审核 */
    YTDRAINAGESTATUS_PREAUDIT,
    /** *  投放中 */
    YTDRAINAGESTATUS_PASS,
    /** *  代理商审核未通过 */
    YTDRAINAGESTATUS_AUDITNOTPASS,
    /** *  已下架 */
    YTDRAINAGESTATUS_AUDITOFFSHELVESPASS,
    /** *  强制下架 */
    YTDRAINAGESTATUS_FORCEOFFSHELVES,
    /** *  已过期 */
    YTDRAINAGESTATUS_EXPIRED
};
// 购买红包状态
typedef NS_ENUM(NSUInteger, YTSHOPBUYHBSTATUS) {
    /** *  即将被领完 */
    YTSHOPBUYHBSTATUS_SOONNO = 1,
    /** *  促销中 */
    YTSHOPBUYHBSTATUS_PROMOTING,
    /** *  已关闭 */
    YTSHOPBUYHBSTATUS_CLOSED,
    /** *  已下架 */
    YTSHOPBUYHBSTATUS_STOCK,
    /** *  未付款 */
    YTSHOPBUYHBSTATUS_WAITEPAY
};
typedef NS_ENUM(NSInteger, YTORDERSTATUS) {
    /** 待支付 */
    YTORDERSTATUS_WAITEPAY = 1,
    /** 交易成功 */
    YTORDERSTATUS_SUCCESS = 2,
    /** 退款中 */
    YTORDERSTATUS_REFUND = 3,
    /** 退款成功 */
    YTORDERSTATUS_REFUNDSUCCESS = 4,
    /** 超时关闭 */
    YTORDERSTATUS_TIMEOUT = 5,
};

typedef NS_ENUM(NSInteger, MyOrderListViewType) {
    // 我的支付订单
    MyOrderListViewTypePayment,
    // 我的退款订单
    MyOrderListViewTypeRefund
};

typedef NS_ENUM(NSInteger, YTDistributePublishType) {
    /** 现金红包 */
    YTDistributeHongbaoTypeXjhb = 1,
    /** 拼手气红包 */
    YTDistributeHongbaoTypePsqhb = 3,
    /** 普通红包 */
    YTDistributeHongbaoTypePthb = 4,
    /** 通知 */
    YTDistributeHongbaoTypeNotice = 5
};



@interface YTTaskHandler : NSObject
+ (NSString *)outPayTyoeStrWithType:(int)type;
+ (NSString *)outPayAccountDetailWithType:(int)type;
+ (NSString *)outReceivewStatusStrWithStatus:(int)status;
+ (NSString *)outDrainageStatusStrWithStatus:(int)status;
+ (NSString *)outShopBuyHbStatusStrWithStatus:(int)status;
+ (NSString *)outOrderStatusStrWithStatus:(int)status;

+ (NSString *)hbDetailStatusImageNameWithUsr:(int)status;
+ (NSString *)hbDetailStatusImageNameWithCommon:(int)status;

+ (NSDate *)outDateWithDateStr:(NSString *)dateStr withStyle:(NSString *)style;
+ (NSString *)outDateStrWithTimeStamp:(NSTimeInterval)timeStamp withStyle:(NSString *)style;
@end
