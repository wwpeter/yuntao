//
//  YTNotifyModel.h
//  YT_business
//
//  Created by chun.chen on 15/7/2.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTNotifyMessage <NSObject>
@end
@interface YTNotifyMessage : YTBaseModel
@property (nonatomic,copy) NSString *notifyId;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *notifyMessage;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval sendTime;
@property (nonatomic,copy) NSString *type;
@end

@interface YTNotifySet : YTBaseModel
@property (nonatomic,assign) int totalPage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,strong) NSArray<YTNotifyMessage> *records;
@end

@interface YTNotifyModel : YTBaseModel
@property (nonatomic,strong) YTNotifySet *notifySet;
@end
