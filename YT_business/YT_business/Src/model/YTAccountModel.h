//
//  YTAccountModel.h
//  YT_business
//
//  Created by chun.chen on 15/7/5.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseModel.h"


@interface YTAccount : YTBaseModel
@property (nonatomic, assign) NSInteger remain;
@property (nonatomic, assign) NSInteger total;
@end

@interface YTAccountModel : YTBaseModel
@property (nonatomic, strong)YTAccount *account;
@end
