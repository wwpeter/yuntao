

#import "StoreCatModel.h"
#import "NSDictionary+SafeAccess.h"

@implementation StoreCatModel

- (instancetype)initWithStoreCatDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.catId = [dictionary numberForKey:@"id"];
        self.parentId = [dictionary numberForKey:@"parentId"];
        self.path = [dictionary stringForKey:@"path"];
        self.name = [dictionary stringForKey:@"name"];
        self.level = [dictionary[@"level"] integerValue];
        if (self.level == 1) {
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            [mutableArray addObject:[self allCatsName]];
            NSArray *childArray = [dictionary arrayForKey:@"children"];
            if (childArray.count > 0) {
                for (NSDictionary *chileDic in childArray) {
                    StoreCatModel *model = [[StoreCatModel alloc] initWithStoreCatDictionary:chileDic];
                    [mutableArray addObject:model];
                }
            }
            self.childrens = [[NSArray alloc] initWithArray:mutableArray];
        }
    }
    return self;
}
- (StoreCatModel *)allCatsName
{
    StoreCatModel *catModel = [[StoreCatModel alloc] init];
    catModel.catId = @0;
    catModel.parentId = self.catId;
    if ([self.name isEqualToString:@"全部分类"]) {
       catModel.name = @"全部";
    }else {
        catModel.name = [NSString stringWithFormat:@"全部%@",self.name];
    }
    catModel.level = 2;
    return catModel;
}
@end
