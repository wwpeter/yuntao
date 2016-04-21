//
//  YTBankModel.m
//  YT_business
//
//  Created by chun.chen on 15/7/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBankModel.h"

@implementation YTBank
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"bankId" : @"id" };
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
    [USERDEFAULT setObject:bankData forKey:iYTUserSelectBankDateKey];
    [USERDEFAULT synchronize];
}
+ (YTBank *)unarchiveBank
{
    NSData* bankData = [USERDEFAULT dataForKey:iYTUserSelectBankDateKey];
    if (!bankData) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:bankData];
}

@end

@implementation YTSaveBank
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"bank" : @"data" };
}
@end
@implementation YTBankModel
- (NSDictionary*)modelKeyJSONKeyMapper
{
    return @{ @"banks" : @"data" };
}
@end
