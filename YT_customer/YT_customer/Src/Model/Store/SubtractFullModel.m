//
//  SubtractFullModel.m
//  YT_customer
//
//  Created by chun.chen on 15/10/31.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "SubtractFullModel.h"
#import "NSDictionary+SafeAccess.h"
#import "NSStrUtil.h"
#import "NSDate+TimeInterval.h"

@implementation SubtractFullModel

- (instancetype)initWithSubtractFullDictionary:(NSDictionary*)dictionary{
    if (self = [super init]) {
        self.date = [dictionary stringForKey:@"date"];
        NSArray *times = [self.date componentsSeparatedByString:@"/"];
        self.startDateStr = [times firstObject];
        self.endDateStr = [times lastObject];
        NSArray *rules = [dictionary arrayForKey:@"rules"];
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithCapacity:rules.count];
        for (NSDictionary *dict in rules) {
            SubtractFullRule * fullRule = [SubtractFullRule modelObjectWithDictionary:dict];
            fullRule.dateStr = self.date;
            [mutableArr addObject:fullRule];
        }
        self.rules = [[NSArray alloc] initWithArray:mutableArr];
    }
    return self;
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end


@implementation SubtractFullRule

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithSubtractRuleDictionary:dict];
}

- (instancetype)initWithSubtractRuleDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.time = [dictionary stringForKey:@"time"];
        self.rule = [dictionary stringForKey:@"rule"];
        [self configData];
    }
    return self;
}

- (void)configData
{
    NSArray *times = [self.time componentsSeparatedByString:@"/"];
    self.startTime = [times firstObject];
    self.endTime = [times lastObject];
    if ([NSStrUtil isEmptyOrNull:self.rule]) {
        return;
    }
    NSArray* curArray = [self.rule componentsSeparatedByString:@"/"];
    self.subtractFull = [[curArray firstObject] integerValue] / 100;
    self.subtractCur = [curArray[1] integerValue] /100;
    self.subtractMax = [[curArray lastObject] integerValue] / 100;
    
}
@end


@implementation SubtractFullDes

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.other = [dictionary arrayForKey:@"other"];
        self.range = [dictionary stringForKey:@"range"];
    }
    return self;
}

@end
