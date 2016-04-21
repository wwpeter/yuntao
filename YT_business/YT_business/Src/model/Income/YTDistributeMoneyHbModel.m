//
//  YTDistributeMoneyHbModel.m
//  YT_business
//
//  Created by chun.chen on 15/12/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTDistributeMoneyHbModel.h"

@implementation YTDistributeMoneyHbModel

- (instancetype)initWithHongbaoType:(NSInteger)hongbaoType
                              count:(NSInteger)count
                            content:(NSString*)content
{
    return [self initWithHongbaoType:hongbaoType count:count cost:0 content:content];
}
- (instancetype)initWithHongbaoType:(NSInteger)hongbaoType
                              count:(NSInteger)count
                               cost:(CGFloat)cost
                            content:(NSString*)content
{
    self = [super init];
    if (self) {
        _hongbaoType = hongbaoType;
        _count = count;
        _cost = cost;
        _content = content;
    }
    return self;
}
@end
