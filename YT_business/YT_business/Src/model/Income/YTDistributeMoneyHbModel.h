//
//  YTDistributeMoneyHbModel.h
//  YT_business
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTDistributeMoneyHbModel : YTBaseModel
@property (nonatomic, assign) NSInteger hongbaoType;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat cost;
@property (nonatomic, copy) NSString* content;

- (instancetype)initWithHongbaoType:(NSInteger)hongbaoType
                              count:(NSInteger)count
                            content:(NSString*)content;

- (instancetype)initWithHongbaoType:(NSInteger)hongbaoType
                              count:(NSInteger)count
                               cost:(CGFloat)cost
                            content:(NSString*)content;
@end
