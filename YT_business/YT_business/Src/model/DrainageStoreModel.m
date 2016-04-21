//
//  DrainageStoreModel.m
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "DrainageStoreModel.h"

@implementation DrainageStoreModel

- (instancetype)initWithDrainageStoreDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.storeName = @"名字名字名字";
        self.storeStatus = 1;
        
        self.throwsNum = 1111;
        self.pullNum = 1000;
        self.leadNum = 999;
    }
    return self;
}
@end
