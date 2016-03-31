//
//  YTCreateUserAuthModel.h
//  YT_customer
//
//  Created by chun.chen on 15/9/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "YTBaseModel.h"

@interface YTCreateUserAuthSet : YTBaseModel
@property (nonatomic,copy) NSString *authCode;
@property (nonatomic,copy) NSString *createToken;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,assign) NSTimeInterval lastTime;
@end


@interface YTCreateUserAuthModel : YTBaseModel
@property (nonatomic,strong) YTCreateUserAuthSet *userAuthSet;
@end
