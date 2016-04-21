//
//  ZHQShopDeatilModel.h
//  YT_business
//
//  Created by 郑海清 on 15/6/12.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleHbModel.h"
#import "YTBaseModel.h"

@interface ZHQShopDetailModel : YTBaseModel

@property (strong, nonatomic) NSURL *backImgUrl; //背景图片
@property (strong, nonatomic) NSMutableArray *cleckImgs;//图片列表
@property (strong, nonatomic) NSString *shopName;//商铺名称
@property (strong, nonatomic) NSNumber *shopStyle;//商铺状态
@property (strong, nonatomic) NSNumber *level;//等级
@property (strong, nonatomic) NSNumber *equalPrice;//人均消费
@property (strong, nonatomic) NSString *shopAddress;//商铺地址
@property (strong, nonatomic) NSNumber *shopPhone;//联系电话
@property (strong, nonatomic) NSDate *startDate;//开始时间
@property (strong, nonatomic) NSDate *endDate;//结束时间
@property (strong, nonatomic) NSString *parkMsg;//停车信息
@property (strong, nonatomic) NSMutableArray *hbList;//红包列表


- (instancetype)initWithShopDetailDictionary:(NSDictionary *)dictionary;

@end
