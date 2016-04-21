//
//  YTVipIncomeModel.m
//  YT_business
//
//  Created by chun.chen on 15/10/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTVipIncomeModel.h"

@implementation YTIncome

@end
@implementation YTIncomePageSet

@end
@implementation YTIncomeSet

@end
@implementation YTVipIncomeModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"incomeSet":@"data"};
}
@end
