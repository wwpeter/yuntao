//
//  YTCategoryModel.m
//  YT_business
//
//  Created by yandi on 15/6/23.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTCategoryModel.h"

@implementation YTCategory
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"categoryId":@"id"};
}
#pragma mark -NSCoding
- (id)initWithCoder:(NSCoder*)aDecoder
{
    [self setLevel:[aDecoder decodeIntForKey:@"level"]];
    [self setHasSelected:[aDecoder decodeBoolForKey:@"hasSelected"]];
    [self setIcon:[aDecoder decodeObjectForKey:@"icon"]];
    [self setName:[aDecoder decodeObjectForKey:@"name"]];
    [self setPath:[aDecoder decodeObjectForKey:@"path"]];
    [self setParentId:[aDecoder decodeObjectForKey:@"parentId"]];
    [self setCategoryId:[aDecoder decodeObjectForKey:@"categoryId"]];
    [self setCreatedAt:[aDecoder decodeDoubleForKey:@"createdAt"]];
    [self setUpdatedAt:[aDecoder decodeDoubleForKey:@"updatedAt"]];
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeInt:self.level forKey:@"level"];
    [aCoder encodeBool:self.hasSelected forKey:@"hasSelected"];
    [aCoder encodeDouble:self.createdAt forKey:@"createdAt"];
    [aCoder encodeDouble:self.updatedAt forKey:@"updatedAt"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.parentId forKey:@"parentId"];
    [aCoder encodeObject:self.categoryId forKey:@"categoryId"];
}
@end

@implementation YTCategorySet
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"categoryId":@"id"};
}
@end

@implementation YTCategoryModel
- (NSDictionary *)modelKeyJSONKeyMapper {
    return @{@"categorys":@"data"};
}
@end
