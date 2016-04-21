//
//  IMBaseModel.h
//  iMei
//
//  Created by yandi on 15/3/20.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTBaseModel : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, assign) BOOL isLoadingMore;

- (NSDictionary *)modelKeyJSONKeyMapper;
- (instancetype)initWithJSONDict:(NSDictionary *)dict;
@end
