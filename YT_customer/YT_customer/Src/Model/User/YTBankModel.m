//
//  YTBankModel.m
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBankModel.h"

@implementation YTBank
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"bankId"}];
}
#pragma mark -NSCoding
- (id)initWithCoder:(NSCoder*)aDecoder
{
    [self setName:[aDecoder decodeObjectForKey:@"name"]];
    [self setBankName:[aDecoder decodeObjectForKey:@"bankName"]];
    [self setBankNo:[aDecoder decodeObjectForKey:@"bankNo"]];
    [self setSecName:[aDecoder decodeObjectForKey:@"secName"]];
    [self setThirdName:[aDecoder decodeObjectForKey:@"thirdName"]];
    [self setRealName:[aDecoder decodeObjectForKey:@"realName"]];
    [self setTitleImg:[aDecoder decodeObjectForKey:@"titleImg"]];
    [self setBankId:[aDecoder decodeObjectForKey:@"bankId"]];
    [self setUserId:[aDecoder decodeObjectForKey:@"userId"]];
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.bankName forKey:@"bankName"];
    [aCoder encodeObject:self.bankNo forKey:@"bankNo"];
    [aCoder encodeObject:self.secName forKey:@"secName"];
    [aCoder encodeObject:self.thirdName forKey:@"thirdName"];
    [aCoder encodeObject:self.realName forKey:@"realName"];
    [aCoder encodeObject:self.titleImg forKey:@"titleImg"];
    [aCoder encodeObject:self.bankId forKey:@"bankId"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
}

+ (void)saveArchiveBank:(YTBank *)bank;
{
    NSData* bankData = [NSKeyedArchiver archivedDataWithRootObject:bank];
    [[NSUserDefaults standardUserDefaults] setObject:bankData forKey:iYTUserSelectBankDateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (YTBank *)unarchiveBank
{
    NSData* bankData = [[NSUserDefaults standardUserDefaults] dataForKey:iYTUserSelectBankDateKey];
    if (!bankData) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:bankData];
}

@end

@implementation YTSaveBank
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"bank"}];
}
@end

@implementation YTBankModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"data":@"banks"}];
}
@end
