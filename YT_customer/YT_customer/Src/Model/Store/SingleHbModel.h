//
//  SingleHbModel.h
//  YT_business
//
//  Created by 郑海清 on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HbDetailModel;
@interface SingleHbModel : NSObject
@property (strong, nonatomic) NSNumber* hbId; //红包id
@property (strong, nonatomic) NSString* imageUrl; //红包图片地址
@property (strong, nonatomic) NSString* hbTitle; //红包名称
@property (strong, nonatomic) NSString* hbDetail; //红包描述
@property (strong, nonatomic) NSNumber* hbValue; //红包价值
@property (strong, nonatomic) NSNumber* hbPrice; //红包价格
@property (strong, nonatomic) NSNumber* hbNum; //红包总数量
@property (strong, nonatomic) NSNumber* hbRemain; //剩余红包数
@property (strong, nonatomic) NSNumber* wantRefundNum; //预计退款红包数
@property (strong, nonatomic) NSString* shopName; //红包所属商铺名称
@property (assign, nonatomic) BOOL didSelect;
@property (strong, nonatomic) HbDetailModel* hbDetailModel;
- (instancetype)initWithSingleHbDictionary:(NSDictionary*)dictionary;
@end
