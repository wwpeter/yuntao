//
//  MCModelFactory.h
//  MissCandy
//
//  Created by yandi on 15/3/19.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTModelFactory : NSObject
+ (YTBaseModel *)modelWithURL:(NSString *)url responseJson:(NSDictionary *)jsonDict;
@end
