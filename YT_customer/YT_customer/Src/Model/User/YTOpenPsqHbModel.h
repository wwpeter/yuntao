//
//  YTOpenPsqHbModel.h
//  YT_customer
//
//  Created by chun.chen on 15/12/11.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTOpenPsqHb : YTBaseModel
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger getNum;
@property (nonatomic, assign) NSInteger hongbaoNum;
@property (nonatomic, copy) NSString* currUserReviceYN;
@end

@interface YTOpenPsqHbModel : YTBaseModel
@property (nonatomic, strong) YTOpenPsqHb* openPsqHb;
@end
