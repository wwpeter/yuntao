//
//  BusinessNotificationHelper.h
//  YT_business
//
//  Created by chun.chen on 15/7/29.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**< 红包上架申请已提交审核*/
extern NSString* const RED_SHELVES_APPLICATIONS_HAVE_BEEN_SUBMITTED_FOR_REVIEW;
/**< 红包上架申请已通过审核*/
extern NSString* const RED_SHELVES_APPLICATION_HAS_BEEN_APPROVED;
/**< 红包上架未通过审核*/
extern NSString* const RED_SHELVES_NOT_APPROVED;
/**< 红包申请下架审核中(红包下架)*/
extern NSString* const APPLICATION_ENVELOPES_SHELVES_AUDIT;
/**< 退款申请*/
extern NSString* const REFUND_REQUEST;
/**< 退款成功*/
extern NSString* const REFUND_SUCCESSFULLY;
/**< 商家入驻信息审核通过*/
extern NSString* const INFORMATION_AUDIT_BY_MERCHANTS_SETTLED;
/**< 商家入驻信息审核不通过（设置+消息）*/
extern NSString* const INFORMATION_IS_NOT_AUDITED_BY_MERCHANTS_SETTLED;
/**< 红包被强制下架的消息*/
extern NSString* const RED_IS_FORCED_OFF_THE_SHELF_NEWS;
/**< 收到支付消息*/
extern NSString* const RECEIVE_THE_PAYMENT_MESSAGE;
/**< 交易退款*/
extern NSString* const TRADING_REFUNDS;
/**< 提现申请提交*/
extern NSString* const WITHDRAWALS_FILING;
/**< 提现完成(后台已打款)*/
extern NSString* const WITHDRAW_COMPLETE;
/**< 手机充值*/
extern NSString* const PHONE_RECHARGE;
/**< 被定向投放*/
extern NSString* const IT_IS_DIRECTED_DELIVERY;

@interface BusinessNotificationHelper : NSObject

+ (BusinessNotificationHelper*)helper;
- (void)openViewControllerReceiveNotificationWith:(NSString*)notificationModel;
- (void)showNotificationWithTitle:(NSString *)title;

@end
