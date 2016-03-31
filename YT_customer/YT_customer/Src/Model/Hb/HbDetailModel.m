//
//  HbDetailModel.m
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "HbDetailModel.h"
#import "NSDictionary+SafeAccess.h"
#import "NSStrUtil.h"
#import "NSDate+TimeInterval.h"

@implementation HbDetailModel
- (instancetype)initWithHbDetailDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        NSDictionary* hbDictionary = [dictionary objectForKey:@"hongbao"];
        NSDictionary* shopDictionary = [dictionary dictionaryForKey:@"shop"];
        NSDictionary* userHbDictionary = [dictionary objectForKey:@"userHongbao"];
        NSTimeInterval startInterval = 0;
        NSTimeInterval endInterval = 0;
        if (hbDictionary) {
            self.hbId = [hbDictionary numberForKey:@"id"];
            self.price = [hbDictionary stringForKey:@"price"];
            self.describe = [hbDictionary stringForKey:@"title"];
            self.ruleDesc = [hbDictionary stringForKey:@"ruleDesc"];
            if ([userHbDictionary objectForKey:@"name"]) {
                self.hbStatus = [userHbDictionary[@"status"] integerValue];
                self.hbName = [userHbDictionary stringForKey:@"name"];
                self.cost = [NSString stringWithFormat:@"%.2f", [userHbDictionary numberForKey:@"cost"].floatValue / 100];
                self.imageUrl = [userHbDictionary stringForKey:@"img"];
                startInterval = [userHbDictionary[@"userUseStartTime"] doubleValue] / 1000;
                endInterval = [userHbDictionary[@"userUseEndTime"] doubleValue] / 1000;
            }
            else {
                self.hbStatus = [hbDictionary[@"status"] integerValue];
                self.hbName = [hbDictionary stringForKey:@"name"];
                self.cost = [NSString stringWithFormat:@"%.0f", [hbDictionary numberForKey:@"cost"].floatValue / 100];
                self.imageUrl = [hbDictionary stringForKey:@"img"];
                startInterval = [hbDictionary[@"startTime"] doubleValue] / 1000;
                endInterval = [hbDictionary[@"endTime"] doubleValue] / 1000;
            }
        }else{
            self.hbId = [dictionary numberForKey:@"id"];
            self.price = [dictionary stringForKey:@"price"];
            self.hbStatus = [dictionary[@"status"] integerValue];
            self.hbName = [dictionary stringForKey:@"name"];
            self.cost = [NSString stringWithFormat:@"%.2f", [dictionary numberForKey:@"cost"].floatValue / 100];
            self.imageUrl = [dictionary stringForKey:@"img"];
            self.describe = [dictionary stringForKey:@"title"];
            self.ruleDesc = [dictionary stringForKey:@"ruleDesc"];
            startInterval = [dictionary[@"startTime"] doubleValue] / 1000;
            endInterval = [dictionary[@"endTime"] doubleValue] / 1000;
        }
        self.startTime = [NSDate timestampToYear:startInterval];
        self.endTime = [NSDate timestampToYear:endInterval];
        self.userStartTime = [NSDate timestampToYear:startInterval];
        self.userEndTime = [NSDate timestampToYear:endInterval];
        
        self.qrCode = [dictionary stringForKey:@"myScanUseHongbaoUrl"];
        self.serialNumber = [dictionary stringForKey:@"hongbaoCode"];
        self.longitude = [shopDictionary[@"lon"] doubleValue];
        self.latitude = [shopDictionary[@"lat"] doubleValue];
        self.address = [shopDictionary stringForKey:@"address"];
        self.phoneNum = [shopDictionary stringForKey:@"mobile"];
        self.shopName = [shopDictionary stringForKey:@"name"];
        self.moveState = [NSString stringWithFormat:@"%@ 至 %@", self.startTime, self.endTime];
        [self setupHbStatusImageName];
        [self setupHbRuleDesc:self.ruleDesc];

        self.stock = 9999;
    }
    return self;
}
- (void)setupHbRuleDesc:(NSString*)ruleDesc
{
    NSArray* array = [NSStrUtil jsonObjecyWithString:ruleDesc];
    NSArray* ruleDesces = [array firstObject][@"descs"];
    NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithCapacity:ruleDesces.count];
    for (NSInteger i = 0; i < ruleDesces.count; i++) {
        NSString* rule = [NSString stringWithFormat:@"%@.%@", @(i + 1), ruleDesces[i]];
        [mutableArray addObject:rule];
    }
    self.rules = [[NSArray alloc] initWithArray:mutableArray];
}
- (void)setupHbStatusImageName
{
    switch (self.hbStatus) {
    case HbIntroModelStatusUnuse: {
        self.hbStatusImageName = @"";
    } break;
    case HbIntroModelStatusUsed: {
        self.hbStatusImageName = @"hb_detail_status_12.png";
    } break;
    case HbIntroModelStatusExpired: {
        self.hbStatusImageName = @"hb_detail_status_04.png";
    } break;
    case HbIntroModelStatusClosed: {
        self.hbStatusImageName = @"hb_detail_status_11.png";
    } break;
    case HbIntroModelStatusDonated: {
        self.hbStatusImageName = @"hb_detail_status_14.png";
    } break;

    default:
        break;
    }
}

@end
