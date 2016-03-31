//
//  YTTaskHandler.h
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PreferencePayType) {
    /** 快捷买单 */
    PreferencePayTypeNone = 0,
    /** 使用红包 */
    PreferencePayTypeHongbao,
    /** 使用折扣支付 */
    PreferencePayTypeDiscount,
    /** 满减 */
    PreferencePayTypeSubtract
};

typedef NS_ENUM(NSInteger, YTShopDistributeHongbaoType) {
    /** 现金、实物红包 */
    YTShopDistributeHongbaoTypeKind = 0,
    /** 拼手气红包 */
    YTShopDistributeHongbaoTypeLuck,
    /** 普通 */
    YTShopDistributeHongbaoTypeNormal
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
    USER_PAY_REFUND = 8,
    /**<提现取消>*/
     CASHOUT_CANCEL = 9,
    /**<平台补贴>*/
    SHOP_CASHBACK = 10,
    /**<店铺会员收益>*/
    VIP_SHOP = 11,
    /**<拼手气红包>*/
    PSQ_HONGBAO = 12,
    /**<普通红包>*/
    PT_HONGBAO = 13,
    /**<会员余额支付>*/
    MEMBER_BLANCE_PAY,
};


@interface YTTaskHandler : NSObject
+ (NSString *)outPayAccountDetailWithType:(int)type;
@end
