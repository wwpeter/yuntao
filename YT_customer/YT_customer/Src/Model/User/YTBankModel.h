//
//  YTBankModel.h
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTBank <NSObject>

@end
@interface YTBank : YTBaseModel
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *fullName;/**< 银行名称*/
@property (nonatomic,copy) NSString *bankName;/**< 银行名称*/
@property (nonatomic,copy) NSString *bankNo;/**< 银行账号*/
@property (nonatomic,copy) NSString *secName;/**< 分行名称*/
@property (nonatomic,copy) NSString *thirdName;/**< 支行名称*/
@property (nonatomic,copy) NSString *realName;/**< 账户名称*/
@property (nonatomic,copy) NSString *titleImg;/**< 银行logo*/
@property (nonatomic,copy) NSString *bankId;
@property (nonatomic,copy) NSString *userId;

+ (void)saveArchiveBank:(YTBank *)bank;
+ (YTBank *)unarchiveBank;
@end

@interface YTSaveBank : YTBaseModel
@property (nonatomic,strong) YTBank *bank;
@end

@interface YTBankModel : YTBaseModel
@property (nonatomic,strong) NSArray<YTBank> *banks;
@end
