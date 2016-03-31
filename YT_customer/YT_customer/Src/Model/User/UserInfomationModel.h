//
//  UserInfomationModel.h
//  YT_customer
//
//  Created by chun.chen on 15/6/16.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfomationModel : NSObject

@property (nonatomic, strong) NSNumber *uid;            // userId
@property (nonatomic, strong) NSString *userAvatar;     // 头像地址
@property (nonatomic, strong) NSString *userMobile;     // 手机号
@property (nonatomic, strong) NSString *userName;       // 用户名
@property (nonatomic, strong) NSString *nickName;       // 昵称
@property (nonatomic, strong) NSString *realName;       // 真实姓名
@property (nonatomic, strong) NSString *sex;            // 性别
@property (nonatomic, strong) NSString *province;       // 省
@property (nonatomic, strong) NSString *city;           // 市
@property (nonatomic, strong) NSString *birthday;       // 生日
@property (nonatomic, strong) NSString *payPwd;       // 支付密码
@property (nonatomic, strong) NSString *vipShopId;       // 会员店铺Id
@property (nonatomic, assign) NSInteger age;            //年龄

- (instancetype)initWithUserDictionary:(NSDictionary *)dictionary;
- (void)saveUserDefaults;
+ (void)removerUserDefaults;

@end
