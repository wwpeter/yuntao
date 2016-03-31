//
//  YTNoticeModel.h
//  YT_customer
//
//  Created by chun.chen on 15/12/7.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTNotice
@end
@interface YTNotice : YTBaseModel
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,copy) NSString *extras;
@property (nonatomic,copy) NSString *noticeId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval sendTime;
@end

@interface YTNoticeSet : YTBaseModel
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) NSArray<YTNotice> *records;
@end

@interface YTNoticeModel : YTBaseModel
@property (nonatomic,strong) YTNoticeSet *noticeSet;
@end
