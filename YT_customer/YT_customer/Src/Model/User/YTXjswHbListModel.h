//
//  YTXjswHbListModel.h
//  YT_customer
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTHbShopModel.h"


@protocol YTXjswHb
@end

@interface YTXjswHb : YTBaseModel
@property (nonatomic,strong) NSNumber *xjId;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,assign) BOOL isSend;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic, copy) NSString *catName;
@property (nonatomic,strong) YTHbShopModel *shop;
@end


@interface YTXjswHbListSet : YTBaseModel
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) NSArray<YTXjswHb> *records;
@end


@interface YTXjswHbListModel : YTBaseModel
@property (nonatomic,strong) YTXjswHbListSet *hbListSet;
@end
