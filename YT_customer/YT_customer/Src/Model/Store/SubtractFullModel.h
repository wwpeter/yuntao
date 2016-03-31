//
//  SubtractFullModel.h
//  YT_customer
//
//  Created by chun.chen on 15/10/31.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol SubtractFullRule <NSObject>
//
//@end

@class SubtractFullRule;

@interface SubtractFullModel : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSArray *rules;
@property (nonatomic, copy)NSString *startDateStr;
@property (nonatomic, copy)NSString *endDateStr;

- (instancetype)initWithSubtractFullDictionary:(NSDictionary*)dictionary;

@end


@interface SubtractFullRule : NSObject
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, assign) NSInteger subtractFull;
@property (nonatomic, assign) NSInteger subtractCur;
@property (nonatomic, assign) NSInteger subtractMax;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithSubtractRuleDictionary:(NSDictionary*)dictionary;

@end

@interface SubtractFullDes : NSObject
@property (nonatomic, copy) NSArray *other;
@property (nonatomic, copy) NSString *range;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end

