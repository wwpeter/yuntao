//
//  ZHQMeUserInfoModel.h
//  YT_customer
//
//  Created by 郑海清 on 15/6/14.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHQMeUserInfoModel : NSObject
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSURL *userIconUrl;
@property (strong, nonatomic) NSString *userNick;
@property (strong, nonatomic) NSNumber *userPhone;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) BOOL isLogin;

- (instancetype)initWithZHQMeUserInfoModelDictionary:(NSDictionary *)dictionary;

@end
