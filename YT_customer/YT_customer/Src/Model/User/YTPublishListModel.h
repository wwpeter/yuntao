//
//  YTPublishListModel.h
//  YT_customer
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"
#import "YTResultHbModel.h"
#import "YTHbShopModel.h"

@protocol YTPublish
@end

@interface YTPublish : YTBaseModel
@property (nonatomic,copy) NSString *pId;
@property (nonatomic,assign) BOOL isSend;
@property (nonatomic,assign) NSInteger publishType;
@property (nonatomic,assign) NSInteger hongbaoLx;
@property (nonatomic,assign) NSInteger totalNum;
@property (nonatomic,assign) NSInteger readNum;
@property (nonatomic,assign) NSInteger getNum;
@property (nonatomic,assign) NSInteger hongbaoNum;
@property (nonatomic,assign) NSInteger hongbaoSum;
@property (nonatomic,assign) NSInteger totalSum;
@property (nonatomic, assign) NSInteger currUserReviceAmount;
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *hongbaoId;
@property (nonatomic, copy) NSString *effectYN;
@property (nonatomic, copy) NSString *currUserReviceYN;
@property (nonatomic, copy) NSString *currUserReadYN;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,strong) YTResultHongbao *hongbao;
@property (nonatomic,strong) YTHbShopModel *shop;

- (NSAttributedString*)nameAttributedString;

@end


@interface YTPublishSet : YTBaseModel
@property (nonatomic,assign) NSInteger pageNum;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,assign) NSInteger totalCount;
@property (nonatomic,strong) NSArray<YTPublish> *records;
@end

@interface YTPublishListModel : YTBaseModel
@property (nonatomic,strong) YTPublishSet *publishSet;
@end
