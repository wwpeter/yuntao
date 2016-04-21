//
//  DrainageIntroModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/8.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrainageIntroModel : NSObject

@property (strong, nonatomic) NSNumber *hbId;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *hbName;     // 名称
@property (strong, nonatomic) NSString *cost;       // 价格

@property (assign, nonatomic) NSInteger hbStatus;    // 红包状态
@property (assign, nonatomic) NSInteger throwsNum;   // 投入数量
@property (assign, nonatomic) NSInteger pullNum;     // 领取数量
@property (assign, nonatomic) NSInteger leadNum;     //引导数量

@property (strong, nonatomic) NSString  *costStr;
@property (strong, nonatomic) NSString  *statusStr;

- (instancetype)initWithDrainageIntroDictionary:(NSDictionary *)dictionary;

@end
