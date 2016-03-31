//
//  CollectManager.h
//  YT_customer
//
//  Created by mac on 16/2/1.
//  Copyright © 2016年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>
#import "CollectModel.h"

@interface CollectManager : NSObject

@property(nonatomic)FMDatabase *dataBase;

+(instancetype)sharedInstance;
-(void)insertModel:(CollectModel *)model;
-(void)deleteModel:(CollectModel *)model;
-(BOOL)isExistPeopleModelForImage:(NSString *)peopleModel;
-(NSMutableArray *)fetch;

@end
