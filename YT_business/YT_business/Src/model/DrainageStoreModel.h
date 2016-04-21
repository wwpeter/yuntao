//
//  DrainageStoreModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/9.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrainageStoreModel : NSObject
@property (strong, nonatomic) NSNumber *storeId;
@property (strong, nonatomic) NSString *storeName;      // 名称

@property (assign, nonatomic) NSInteger storeStatus;    // 红包状态
@property (assign, nonatomic) NSInteger throwsNum;      // 投入数量
@property (assign, nonatomic) NSInteger pullNum;        // 领取数量
@property (assign, nonatomic) NSInteger leadNum;        // 引导数量

- (instancetype)initWithDrainageStoreDictionary:(NSDictionary *)dictionary;

@end
