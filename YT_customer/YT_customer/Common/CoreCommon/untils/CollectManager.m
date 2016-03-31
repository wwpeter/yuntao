//
//  CollectManager.m
//  YT_customer
//
//  Created by mac on 16/2/1.
//  Copyright © 2016年 sairongpay. All rights reserved.
//

#import "CollectManager.h"

@implementation CollectManager
//单例保证数据库只被创建一次
+(instancetype)sharedInstance{
    static CollectManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[CollectManager alloc]init];
    });
    return manager;
}

//创建数据库
-(instancetype)init{
    if (self = [super init]) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"collect.db"];
        self.dataBase = [[FMDatabase alloc] initWithPath:dbPath];
        NSLog(@"%@",dbPath);
        if ([_dataBase open]) {
            NSLog(@"打开数据库成功");
            
            NSString *sql = @"create table if not exists shopInfo(shopID text)";
            if ([self.dataBase executeUpdate:sql]) {
                NSLog(@"创建表格成功");
            }
            
            [self.dataBase close];
        }
    }
    return self;
    
}

//出入一条数据
- (void)insertModel:(CollectModel *)model {
    if ([self.dataBase open]) {
        NSString *sql = @"insert into shopInfo values(?)";
        if ([self.dataBase executeUpdate:sql,model.shopID]) {
            NSLog(@"录入成功");
        }
        [self.dataBase close];
    }
}

//判断shopID 的这个是佛存在，
-(BOOL)isExistPeopleModelForImage:(NSString *)shopModel {
    if ([self.dataBase open]) {
        NSString *sql = @"select * from shopInfo where shopID = ?";
        if ([self.dataBase executeUpdate:sql,shopModel]) {
            return YES;
        }
        [self.dataBase close];
    }
    return NO;
}

//按照shopID进行删除
- (void)deleteModel:(CollectModel *)model {
    [self deleteModelForPeopleName:model.shopID];
}

//删除数据库中的成条数据
-(void)deleteModelForPeopleName:(NSString *)shopID{
    NSString *sql = @"delete from shopInfo where shopID = ?";
    if ([self.dataBase open]) {
        if ([self.dataBase executeUpdate:sql,shopID]) {
            NSLog(@"删除成功");
        }
        [self.dataBase close];
    }
}

//查询数据库中的数据，以便使用
- (NSMutableArray *)fetch {
    NSString *sql = @"select * from shopInfo";
    if ([self.dataBase open]) {
        FMResultSet *set = [self.dataBase executeQuery:sql];
        NSMutableArray *peopleModelArray = [NSMutableArray array];
        while ([set next]) {
            CollectModel *model = [[CollectModel alloc] init];
            model.shopID = [set stringForColumn:@"shopID"];
            
            [peopleModelArray addObject:model];
        }
        [self.dataBase close];
        return peopleModelArray;
    }
    return nil;
}

@end
