//
//  YTDrainageModel.h
//  YT_business
//
//  Created by yandi on 15/6/21.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol  YTDrainage <NSObject>
@end

@interface YTDrainage : YTBaseModel
@property (nonatomic,assign) int num;
@property (nonatomic,assign) int tou;
@property (nonatomic,assign) int yin;
@property (nonatomic,assign) int cost;
@property (nonatomic,assign) int ling;
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lon;
@property (nonatomic,assign) int price;
@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int remainNum;
@property (nonatomic,assign) int delStatus;
@property (nonatomic,assign) int createType;
@property (nonatomic,copy) NSString *ruleId;
@property (nonatomic,copy) NSString *ruleDesc;
@property (nonatomic,copy) NSString *creatorId;
@property (nonatomic,copy) NSString *offComment;
@property (nonatomic,copy) NSString *areaUserId;
@property (nonatomic,copy) NSString *cityUserId;
@property (nonatomic,copy) NSString *saleUserId;
@property (nonatomic,copy) NSString *drainageId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *createName;
@property (nonatomic,copy) NSString *auditComment;
@property (nonatomic,assign) NSTimeInterval endTime;
@property (nonatomic,copy) NSString *provinceUserId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,copy) NSString *sellerShopUserId;
@property (nonatomic,assign) NSTimeInterval startTime;
@end

@interface YTDrainageSet : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTDrainage> *records;
@end

@interface YTDrainageModel : YTBaseModel
@property (nonatomic,strong) YTDrainageSet *drainageSet;
@end
