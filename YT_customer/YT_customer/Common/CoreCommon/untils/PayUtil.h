//
//  PayUtil.h
//  YT_customer
//
//  Created by 郑海清 on 15/6/18.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
typedef void (^WeChatPayBackBlock)(NSDictionary *);
@interface PayUtil : NSObject<WXApiDelegate>
@property (strong, nonatomic) NSString *payOrderId;
@property (strong, nonatomic) WeChatPayBackBlock block;
+(id)sharedPayUtil;
/**<支付宝支付*/
-(void)alipayOrder:(NSString *)params blackBlock:(void (^)(NSDictionary *))block;
/**<微信支付*/
-(void)weChatPayWithDictionary:(NSDictionary *)orderDic
                    payorderId:(NSNumber *)payOrderId
                    blackBlock:(void (^)(NSDictionary *))block;
@end
