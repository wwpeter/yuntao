//
//  YTRefundOrderModel.m
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTRefundOrderModel.h"

@implementation YTRefundOrderDetail
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"refundOrderDetailId":@"id"};
}
@end

@implementation YTRefundOrder
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"refundOrderId":@"id"};
}
@end

@implementation YTRefundOrderSet

@end

@implementation YTRefundOrderInfo
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"refundOrderSet":@"refundInfo"};
}
@end

@implementation YTRefundOrderModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"refundOrderInfo":@"data"};
}
@end
