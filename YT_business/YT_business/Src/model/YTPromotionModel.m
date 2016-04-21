//
//  YTPromotionModel.m
//  YT_business
//
//  Created by yandi on 15/6/22.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTPromotionModel.h"

@implementation YTPromotionHongbao
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"promotionHongbaoId":@"id"};
}

- (NSMutableAttributedString *)remainNumStr {
    NSString *remainStr = [NSString stringWithFormat:@"%d",self.remainNum];
    NSString *placeHolderStr = @"余:";
    NSMutableAttributedString *remainNumStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",placeHolderStr,remainStr]];
    [remainNumStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, placeHolderStr.length)];
    [remainNumStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(placeHolderStr.length, remainStr.length)];
    return remainNumStr;
}

- (NSMutableAttributedString *)releaseNumStr {
    NSString *numStr = [NSString stringWithFormat:@"%d",self.ling];
    NSString *placeHolderStr = @"已发放:";
    NSMutableAttributedString *relaseNummStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",placeHolderStr,numStr]];
    [relaseNummStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, placeHolderStr.length)];
    [relaseNummStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(placeHolderStr.length, numStr.length)];
    return relaseNummStr;
}

@end

@implementation YTPromotionHongbaoSet

@end

@implementation YTPromotionModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"promotionHongbaoSet":@"data"};
}
@end
