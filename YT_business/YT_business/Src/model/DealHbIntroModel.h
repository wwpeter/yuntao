//
//  DealHbIntroModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/15.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealHbIntroModel : NSObject

@property (strong, nonatomic) NSNumber *hbId;
@property (strong, nonatomic) NSURL *imageUrl;
// 名称
@property (strong, nonatomic) NSString *hbName;
// 描述
@property (strong, nonatomic) NSString *describe;
// 价值
@property (strong, nonatomic) NSString *price;
// 价格
@property (strong, nonatomic) NSString *cost;
// 过期时间
@property (strong, nonatomic) NSString *pastTime;

// 剩余
@property (assign, nonatomic) NSInteger thanNum;
// 是否选择
@property (assign, nonatomic) BOOL  didSelect;

@property (strong, nonatomic) NSString *pastTimeStr;

- (instancetype)initWithDealHbIntroDictionary:(NSDictionary *)dictionary;

@end
