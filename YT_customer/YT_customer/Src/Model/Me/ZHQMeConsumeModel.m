//
//  ZHQMeConsumeModel.m
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "ZHQMeConsumeModel.h"
#import "NSDate+TimeInterval.h"

@implementation ZHQMeConsumeModel

-(instancetype)initMeConsumeModelWithDictionary:(NSDictionary *)dictionray
{
    self = [super init];
    if (self) {
        self.consumeId = dictionray[@"toOuterId"];
        self.orderId = dictionray[@"id"];
        self.hbTitle = dictionray[@"shop"][@"name"];
        self.consumeImg = dictionray[@"shop"][@"img"];
        self.hbReceiveStatus = dictionray[@"receiveStatus"];
        self.hbPayStatus = [dictionray[@"status"] integerValue];
        self.price = [[NSNumber alloc]initWithFloat:[dictionray[@"totalPrice"] floatValue] / 100];
        NSNumber *time = dictionray[@"createdAt"];
        self.hbDate = [NSDate dateWithTimeIntervalSince1970:time.longLongValue / 1000];
    }
    return self;
}
-(void)setHbReceiveStatus:(NSNumber *)hbReceiveStatus
{
    _hbReceiveStatus = hbReceiveStatus;
    switch (_hbReceiveStatus.integerValue) {
        case 1:
            _hbReceiveStatusStr =  @"红包未领取";
            break;
        case 2:
            _hbReceiveStatusStr =  @"红包已领取";
            break;
        default:
            break;
    }
}
-(void)setHbPayStatus:(UserPayStatus)hbPayStatus
{
    _hbPayStatus = hbPayStatus;
    switch (self.hbPayStatus) {
        case WAITE_PAY:
//            _hbReceiveStatusStr =  @"红包未支付";
            break;
        case PAYED:
//            _hbReceiveStatusStr =  @"红包已领取";
            break;
        case CANCEL:
//            _hbReceiveStatusStr =  @"红包已领取";
            break;
        case USER_PAY_REFUNDING:
            _hbReceiveStatusStr =  @"退款中";
            break;
        case USER_PAY_REFUND_SUCCESS:
            _hbReceiveStatusStr =  @"退款成功";
            break;
        default:
            break;
    }
}


@end
