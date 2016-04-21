//
//  HbStoreListModel.m
//  YT_business
//
//  Created by chun.chen on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "HbStoreListModel.h"

@implementation HbStoreListModel

- (instancetype)initWithHbStoreListDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.hbName = @"名字名字名字";
        self.price = @"100";
        self.describe = @"红包描述红包描述红包描述红包描述红包描述红包描述红包描述";
        self.cost = @"5";
        self.stock = 100;
        [self setupCostAttributed];
    }
    return self;
}

- (void)setupCostAttributed
{
     NSString *str = [NSString stringWithFormat:@"￥%@/个 库存%@",self.cost,@(self.stock)];
    NSMutableAttributedString* attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 1)];
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(1, self.cost.length)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:YTDefaultRedColor range:NSMakeRange(0, self.cost.length+1)];
    self.costAttributed = attributedStr;

}
@end
