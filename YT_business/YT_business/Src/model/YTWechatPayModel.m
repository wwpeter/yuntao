//
//  YTWechatPayModel.m
//  YT_business
//
//  Created by chun.chen on 15/8/19.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTWechatPayModel.h"

@implementation YTWechatPayShopOrder
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"shopOrderId":@"id"};
}

@end

@implementation YTWechatpayOrder

- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"payOrderId":@"id"};
}

@end

@implementation YTWechatPayOrderReqData

@end

@implementation YTWechatPaySet
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"wechatReqData":@"unifiedOrderClientReqData"};
}
@end

@implementation YTWechatPayModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"wechatPay":@"data"};
}

@end
