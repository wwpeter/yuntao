//
//  YTVipManageModel.h
//  YT_business
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTTradeModel.h"

@protocol YTVipManage <NSObject>
@end
@interface YTVipManage : YTBaseModel
@property (nonatomic, copy) NSString* vipId;
@property (nonatomic, copy) NSString* shopId;
@property (nonatomic, assign) NSTimeInterval createdAt;
@property (nonatomic, assign) int publishType;
@property (nonatomic, assign) int hongbaoLx;
@property (nonatomic, assign) int totalNum;  /**< 发送人数*/
@property (nonatomic, assign) int readNum; /**< 已读数量*/
@property (nonatomic, assign) int getNum;  /**< 领取数量*/
@property (nonatomic, assign) int hongbaoNum;  /**< 红包数量*/
@property (nonatomic, assign) int hongbaoSum;
@property (nonatomic, assign) int totalSum;
@property (nonatomic, assign) int cost;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, copy) NSString* hongbaoId;
@property (nonatomic, copy) NSString* effectYN;
@property (nonatomic, assign) NSTimeInterval updatedAt;
@property (nonatomic, strong) YTUsrHongBao *hongbao;

- (NSAttributedString*)sendAttributedString;
- (NSAttributedString*)nameAttributedString;
@end

@interface YTVipManageSet : YTBaseModel
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, strong) NSArray<YTVipManage>* records;
@end

@interface YTVipManageModel : YTBaseModel
@property (nonatomic, strong) YTVipManageSet* manageSet;
@end
