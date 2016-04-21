//
//  YTBuyHongbaoIndexModel.h
//  YT_business
//
//  Created by chun.chen on 15/8/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTBuyHongbaoIndeDetail : YTBaseModel
@property (nonatomic,assign) NSInteger remainNum;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,assign) NSInteger userConsume;
@property (nonatomic,assign) NSInteger closed;
@property (nonatomic,assign) NSInteger ling;
@end

@interface YTBuyHongbaoIndexModel : YTBaseModel
@property (nonatomic,strong) YTBuyHongbaoIndeDetail *indexDetail;
@end
