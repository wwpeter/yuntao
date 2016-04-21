//
//  YTPsqptHbListModel.h
//  YT_business
//
//  Created by chun.chen on 15/12/11.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTPsqptHb <NSObject>
@end
@interface YTPsqptHb : YTBaseModel
@property (nonatomic, copy) NSString* pId;
@property (nonatomic, copy) NSString* img;
@property (nonatomic, assign) NSTimeInterval createdAt;
@property (nonatomic, assign) int money;
@property (nonatomic, assign) int hongbaoLx;
@property (nonatomic, assign) int hongbaoSum;
@property (nonatomic, assign) int totalSum;
@property (nonatomic, assign) int cost;
@property (nonatomic, copy) NSString* mobile;
@property (nonatomic, copy) NSString* overdueHours;
@property (nonatomic, copy) NSString* publishId;
@property (nonatomic, copy) NSString* readYN;
@property (nonatomic, copy) NSString* overdueYN;
@property (nonatomic, copy) NSString* receiveYN;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, assign) NSTimeInterval updatedAt;

@end

@interface YTPsqptHbSet : YTBaseModel
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, strong) NSArray<YTPsqptHb>* records;
@end

@interface YTPsqptHbListModel : YTBaseModel
@property (nonatomic, strong) YTPsqptHbSet* psqptHbSet;
@end
