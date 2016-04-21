//
//  YTCategoryModel.h
//  YT_business
//
//  Created by yandi on 15/6/23.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"

@protocol YTCategory <NSObject>
@end
@interface YTCategory : YTBaseModel
@property (nonatomic,assign) int level;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,assign) BOOL hasSelected;
@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@end

@protocol YTCategorySet <NSObject>
@end
@interface YTCategorySet : YTBaseModel
@property (nonatomic,assign) int level;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,copy) NSString *parentId;
@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,assign) NSTimeInterval createdAt;
@property (nonatomic,assign) NSTimeInterval updatedAt;
@property (nonatomic,strong) NSArray<YTCategory> *children;
@end

@interface YTCategoryModel : YTBaseModel
@property (nonatomic,strong) NSArray<YTCategorySet> *categorys;
@end