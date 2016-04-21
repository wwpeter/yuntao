//
//  YTAccountDetailModel.h
//  YT_business
//
//  Created by chun.chen on 15/7/24.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTAccountDetail <NSObject>

@end

@interface YTAccountDetail : YTBaseModel

@property (nonatomic, copy) NSString* accountId;
@property (nonatomic, assign) int amount;
@property (nonatomic, assign) int lastAmount;
@property (nonatomic, assign) int totalAmount;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString* outerId;
@property (nonatomic, copy) NSString* shopId;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* titleImg;
@property (nonatomic, copy) NSString* typeDesc;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, assign) NSTimeInterval updatedAt;
@property (nonatomic, assign) NSTimeInterval createdAt;
@end

@interface YTAccountDetailSet : YTBaseModel
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, strong) NSArray<YTAccountDetail>* records;
@end

@interface YTAccountDetailModel : YTBaseModel
@property (nonatomic, strong) YTAccountDetailSet* accountDetailSet;
@end
