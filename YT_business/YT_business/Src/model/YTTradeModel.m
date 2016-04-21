//
//  YTTradeModel.m
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTTradeModel.h"

@implementation YTHongBao
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"indexId":@"id"};
}
@end

@implementation YTUsrHongBao
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"indexId":@"id",
             @"hongbaoId":@"id"};
}
- (NSMutableAttributedString *)costAttributeStr {
    NSString *costStr = [NSString stringWithFormat:@"￥%.2f",self.price/100.];
    NSString *remainNumStr = [NSString stringWithFormat:@"/个 库存%d",self.remainNum];
    NSString *costNoAttrStr = [NSString stringWithFormat:@"%@%@",costStr,remainNumStr];
    
    NSMutableAttributedString *costAttributeStr = [[NSMutableAttributedString alloc] initWithString:costNoAttrStr];
    [costAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, costStr.length)];
    [costAttributeStr addAttribute:NSForegroundColorAttributeName value:YTDefaultRedColor range:NSMakeRange(0, costStr.length)];
    return costAttributeStr;
}
@end

@implementation YTCommonUser
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"userId":@"id"};
}
@end

@implementation YTTrade
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"tradeId":@"id",
             @"trademessage":@"message"};
}
- (CGFloat )promotionTotalPrice;
{
    CGFloat promotion = self.promotion < 2 ? 2 : self.promotion;
    CGFloat total = self.originPrice - (self.originPrice*(promotion/100));
    return total;
}
@end

@implementation YTTradeSet

@end

@implementation YTTradeModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"tradeSet":@"data"};
}
@end
