//
//  YTVipIncomeModel.h
//  YT_business
//
//  Created by chun.chen on 15/10/28.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTIncome <NSObject>

@end

@interface YTIncome : YTBaseModel
@property (nonatomic, assign) NSInteger vipShopAmountSum;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* userId;
@end

@interface YTIncomePageSet : YTBaseModel
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, copy) NSArray<YTIncome>* records;
@end

@interface YTIncomeSet : YTBaseModel
@property (nonatomic, assign) NSInteger totalAmount;
@property (nonatomic, assign) NSInteger yestodayAmount;
@property (nonatomic, strong) YTIncomePageSet* page;
@end

@interface YTVipIncomeModel : YTBaseModel
@property (nonatomic, strong) YTIncomeSet* incomeSet;
@end
