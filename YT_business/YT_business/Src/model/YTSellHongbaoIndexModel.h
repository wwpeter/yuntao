//
//  YTSellHongbaoIndexModel.h
//  YT_business
//
//  Created by chun.chen on 15/8/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTSellHongbaoIndexDetail : YTBaseModel
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) NSInteger ling;
@property (nonatomic,assign) NSInteger tou;
@property (nonatomic,assign) NSInteger yin;
@end


@interface YTSellHongbaoIndexModel : YTBaseModel
@property (nonatomic,strong) YTSellHongbaoIndexDetail *indexDetail;
@end
