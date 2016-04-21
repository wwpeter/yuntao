//
//  HbStoreListModel.h
//  YT_business
//
//  Created by chun.chen on 15/6/10.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HbStoreListModel : NSObject

@property (strong, nonatomic) NSNumber *hbId;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *hbName;        // 名称
@property (strong, nonatomic) NSString *price;          // 价值
@property (strong, nonatomic) NSString *describe;      // 描述
@property (strong, nonatomic) NSString *cost;          // 价格

@property (assign, nonatomic) NSInteger stock;         // 库存
@property (assign, nonatomic) NSInteger hbNumber;       // 输入数量

@property (strong, nonatomic) NSMutableAttributedString *costAttributed;
@property (strong, nonatomic) NSIndexPath *indexPath;

- (instancetype)initWithHbStoreListDictionary:(NSDictionary *)dictionary;

@end
