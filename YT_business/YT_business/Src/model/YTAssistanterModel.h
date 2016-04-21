//
//  YTAssistanterModel.h
//  YT_business
//
//  Created by chun.chen on 15/7/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTAssistanter <NSObject>
@end
@interface YTAssistanter : YTBaseModel

@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *assistanterId;
@property (nonatomic,copy) NSString *inviteUserId;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *shop;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *zoneId;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@end

@interface YTAssistanterModel : YTBaseModel
@property (nonatomic,strong) NSArray<YTAssistanter> *assistanters;
@end
