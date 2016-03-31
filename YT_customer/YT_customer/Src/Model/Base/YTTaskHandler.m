//
//  YTTaskHandler.m
//  YT_customer
//
//  Created by chun.chen on 15/9/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTTaskHandler.h"

@implementation YTTaskHandler
+ (NSString *)outPayAccountDetailWithType:(int)type
{
    if (type == SHOP_BUY_HONGBAO) {
        return @"买红包分润";
    }
    else if (type == REFUND_ORDER_DETAIL) {
        return @"退款红包分润";
    }
    else if (type == SMS_CHARGE) {
        return @"话费充值";
    }
    else if (type == USER_PAY) {
        return @"用户付款成功";
    }
    else if (type == DAN_MIAN_FU) {
        return @"当面付";
    }
    else if (type == DANG_MIAN_FU_CANCEL) {
        return @"当面付撤销";
    }
    else if (type == CASHOUT) {
        return @"余额提现";
    }
    else if (type == USER_PAY_REFUND) {
        return @"退款成功";
    } else if (type == CASHOUT_CANCEL) {
        return @"提现取消";
    } else if (type == SHOP_CASHBACK) {
        return @"平台补贴";
    } else if (type == VIP_SHOP) {
        return @"店铺会员收益";
    } else if (type ==  PSQ_HONGBAO) {
        return @"拼手气红包";
    } else if (type == PT_HONGBAO) {
        return @"普通红包";
    } else if (type == MEMBER_BLANCE_PAY) {
        return @"会员余额支付";
    }
    return @"";
}
@end
