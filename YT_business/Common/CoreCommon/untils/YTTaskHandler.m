//
//  taskHandler.m
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTTaskHandler.h"

@implementation YTTaskHandler
static NSDateFormatter *dateFormatter;
+ (NSString *)outPayTyoeStrWithType:(int)type
{
    if (type == YTPAYTYPE_USERPAY) {
        return @"用户付款";
    }else if (type == YTPAYTYPE_FACEPAY) {
        return @"当面付";
    }else if (type == YTPAYTYPE_FACErREFUND){
        return @"退款";
    }
    return @"";
}
+ (NSString *)outReceivewStatusStrWithStatus:(int)status {
    if (status == YTRECEIVESTATUS_RECEIVED) {
        return @"已领取";
    } else if (status == YTRECEIVESTATUS_UNRECEIVE) {
        return @"未领取";
    }
    return @"";
}
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
    }
    return @"";
}
+ (NSString *)outDrainageStatusStrWithStatus:(int)status {
    if (status == YTDRAINAGESTATUS_PRECONFIRMPRICE) {
        return @"待审核";
//        return @"待定价";
    } else if (status == YTDRAINAGESTATUS_PRECONFIRMSHOP) {
        return @"待确认";
    } else if (status == YTDRAINAGESTATUS_PREAUDIT) {
        return @"待审核";
    }else if (status == YTDRAINAGESTATUS_PASS) {
        return @"投放中";
    }else if (status == YTDRAINAGESTATUS_AUDITNOTPASS) {
        return @"审核未通过";
    }else if (status == YTDRAINAGESTATUS_AUDITOFFSHELVESPASS) {
        return @"已下架";
    }else if (status == YTDRAINAGESTATUS_FORCEOFFSHELVES) {
        return @"强制下架";
    }else if (status == YTDRAINAGESTATUS_EXPIRED) {
        return @"已过期";
    }
    return @"";
}
+ (NSString *)outShopBuyHbStatusStrWithStatus:(int)status
{
    if (status == YTSHOPBUYHBSTATUS_SOONNO) {
        return @"即将被领完";
    } else if (status == YTSHOPBUYHBSTATUS_PROMOTING) {
        return @"促销中";
    } else if (status == YTSHOPBUYHBSTATUS_CLOSED) {
        return @"已关闭";
    }else if (status == YTSHOPBUYHBSTATUS_STOCK) {
        return @"已下架";
    }else if (status == YTSHOPBUYHBSTATUS_WAITEPAY) {
        return @"未付款";
    }
    return @"";
}
+ (NSString *)outOrderStatusStrWithStatus:(int)status
{
    if (status == YTORDERSTATUS_WAITEPAY) {
        return @"待支付";
    }
    else if (status == YTORDERSTATUS_SUCCESS) {
        return @"交易成功";
    }
    else if (status == YTORDERSTATUS_REFUND) {
        return @"退款中";
    }
    else if (status == YTORDERSTATUS_REFUNDSUCCESS) {
        return @"退款成功";
    }
    else if (status == YTORDERSTATUS_TIMEOUT) {
        return @"超时关闭";
    }
    return @"";
}
+ (NSString *)hbDetailStatusImageNameWithUsr:(int)status
{
    return @"";
}
+ (NSString *)hbDetailStatusImageNameWithCommon:(int)status
{
    if (status == YTDRAINAGESTATUS_PRECONFIRMPRICE) {
        return @"hb_status_03.png";
    } else if (status == YTDRAINAGESTATUS_PRECONFIRMSHOP) {
        return @"hb_status_02.png";
    } else if (status == YTDRAINAGESTATUS_PREAUDIT) {
        return @"hb_status_03.png";
    }else if (status == YTDRAINAGESTATUS_PASS) {
        return @"hb_status_09.png";
    }else if (status == YTDRAINAGESTATUS_AUDITNOTPASS) {
        return @"hb_status_08.png";
    }else if (status == YTDRAINAGESTATUS_AUDITOFFSHELVESPASS) {
        return @"hb_status_13.png";
    }else if (status == YTDRAINAGESTATUS_FORCEOFFSHELVES) {
        return @"hb_status_05.png";
    }else if (status == YTDRAINAGESTATUS_EXPIRED) {
        return @"hb_status_11.png";
    }
    return @"";
}
+ (NSDate *)outDateWithDateStr:(NSString *)dateStr withStyle:(NSString *)style {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    dateFormatter.dateFormat = style;
    return [dateFormatter dateFromString:dateStr];
}

+ (NSString *)outDateStrWithTimeStamp:(NSTimeInterval)timeStamp withStyle:(NSString *)style {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    timeStamp = timeStamp/1000.;
    dateFormatter.dateFormat = style;
    NSDate *receiveDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [dateFormatter stringFromDate:receiveDate];
}
@end
