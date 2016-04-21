//
//  CHStoreListModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHStoreListModel : NSObject

@property (strong, nonatomic) NSNumber *storeId;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *storeName;  // 名称
@property (strong, nonatomic) NSString *cost;       // 价格
@property (strong, nonatomic) NSString *address;    // 地址
@property (strong, nonatomic) NSString *sort;       // 类型

@property (assign, nonatomic) NSInteger distance;   // 距离
@property (assign, nonatomic) NSInteger rank;       // 级别

@property (strong, nonatomic) NSNumber *longitude;  // 经度
@property (strong, nonatomic) NSNumber *latitude;   // 纬度


@property (assign, nonatomic) BOOL  didSelect;       // 是否选择
@property (assign, nonatomic) NSInteger  selectAtIndex; // 被选择位置

@property (strong, nonatomic) NSString  *costStr;
@property (strong, nonatomic) NSString  *distanceStr;
@property (strong, nonatomic) NSMutableAttributedString *nameAttributed;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (instancetype)initWithStoreListDictionary:(NSDictionary *)dictionary;

@end
