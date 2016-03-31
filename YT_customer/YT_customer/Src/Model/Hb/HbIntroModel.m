//
//  HbIntroModel.m
//  YT_customer
//
//  Created by chun.chen on 15/6/13.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "HbIntroModel.h"
#import "NSDictionary+SafeAccess.h"
#import "NSDate+TimeInterval.h"
#import "NSDate+Utilities.h"

@implementation HbIntroModel
- (instancetype)initWithHbIntroDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.hbId = [dictionary numberForKey:@"id"];
        self.hongbaoId = [dictionary numberForKey:@"hongbaoId"];
        self.imageUrl = [dictionary stringForKey:@"img"];
        self.hbName = [dictionary stringForKey:@"name"];
        if (dictionary[@"shop"]) {
            self.shopName = dictionary[@"shop"][@"name"];
        }
        else
        {
            self.shopName = dictionary[@"hongbao"][@"shop"][@"name"];
        }
        
        self.describe = [dictionary stringForKey:@"title"];
        self.cost = [NSString stringWithFormat:@"%.0F",[dictionary numberForKey:@"cost"].floatValue / 100];
        self.hbStatus = [dictionary[@"status"] integerValue];
        self.thanNum = [dictionary[@"remainNum"] integerValue];
        self.userUseEndDate = [NSDate dateFormJavaTimestamp:[dictionary[@"userUseEndTime"] doubleValue]];
        self.hbStatus = [dictionary[@"status"] integerValue];
//        [self setupUserEndTimeString];
        [self setupHBstatusStr];
        [self setupHbStatusImageName];
    }
    return self;
}

- (void)setupUserEndTimeString
{
    NSDate *now = [NSDate new];
    if ([now isLaterThanDate:self.userUseEndDate]) {
        self.userUseEndDateStr = @"已失效";
    }else{
        NSInteger dd = [now daysAfterDate:self.userUseEndDate];
        if (dd < 0) {
            self.userUseEndDateStr = @"已失效";
        }else if (dd== 0) {
            self.userUseEndDateStr = @"即将失效";
        }else{
            self.userUseEndDateStr = [NSString stringWithFormat:@"%@天后失效",@(dd)];
        }
    }
}
- (void)setupHBstatusStr
{
    switch (_hbStatus) {
        case HbIntroModelStatusUnuse:
            self.userUseEndDateStr = @"未使用";
            break;
        case HbIntroModelStatusUsed:
            self.userUseEndDateStr = @"已使用";
            break;
        case HbIntroModelStatusExpired:
            self.userUseEndDateStr = @"已过期";
            break;
        case HbIntroModelStatusClosed:
            self.userUseEndDateStr = @"已关闭";
            break;
        case HbIntroModelStatusDonated:
            self.userUseEndDateStr = @"已转赠";
            break;
            
        default:
            break;
    }
}
- (void)setupHbStatusImageName
{
    switch (self.hbStatus) {
        case HbIntroModelStatusUnuse: {
            self.hbStatusImageName = @"";
        }
            break;
        case HbIntroModelStatusUsed: {
            self.hbStatusImageName = @"hb_status_01.png";
        }
            break;
        case HbIntroModelStatusExpired: {
            self.hbStatusImageName = @"hb_status_06.png";
        }
            break;
        case HbIntroModelStatusClosed: {
            self.hbStatusImageName = @"hb_status_09.png";
        }
            break;
        case HbIntroModelStatusDonated: {
            self.hbStatusImageName = @"hb_status_04.png";
        }
            break;
            
        default:
            break;
    }
}
@end
