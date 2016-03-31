//
//  YTAccountModel.h
//  YT_customer
//
//  Created by chun.chen on 15/12/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"


@interface YTAccount : YTBaseModel
@property (nonatomic, assign) NSInteger remain;
@property (nonatomic, assign) NSInteger total;
@end

@interface YTAccountModel : YTBaseModel
@property (nonatomic, strong)YTAccount *account;
@end
