//
//  StoreCatModel.h
//  YT_customer
//
//  Created by chun.chen on 15/6/17.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreCatModel : NSObject

@property (nonatomic, strong) NSArray *childrens;   // 二级子类目

@property (nonatomic, strong) NSNumber *catId;
@property (nonatomic, strong) NSNumber *parentId;
@property (nonatomic, strong) NSString *path;       // 图片路径
@property (nonatomic, strong) NSString *name;       // 名称

@property (nonatomic, assign) NSInteger level;       // 级别

- (instancetype)initWithStoreCatDictionary:(NSDictionary *)dictionary;

@end
