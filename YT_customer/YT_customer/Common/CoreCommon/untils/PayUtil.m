//
//  PayUtil.m
//  YT_customer
//
//  Created by 郑海清 on 15/6/18.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "PayUtil.h"
#import "YTNetworkMange.h"
#import "NSDictionary+SafeAccess.h"
static NSString* ALIPAYSCHEME = @"YCAliPayBack";
@implementation PayUtil

+ (id)sharedPayUtil
{
    static PayUtil* payUtil = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payUtil = [[self alloc] init];
    });
    return payUtil;
}

#pragma mark - 调用支付宝方法
- (void)alipayOrder:(NSString*)params blackBlock:(void (^)(NSDictionary*))block
{
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    //将签名成功字符串格式化为订单字符串,请严格按照该格式

    [[AlipaySDK defaultService] payOrder:params
                              fromScheme:ALIPAYSCHEME
                                callback:^(NSDictionary* resultDic) {
                                    if ([[resultDic numberForKey:@"resultStatus"] integerValue] == 9000) {
                                        [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_AlipayResult
                                            parameters:resultDic
                                            success:^(id responseData) {
                                                if (block) {
                                                    block(resultDic);
                                                }
                                            }
                                            failure:^(NSString* errorMessage){

                                            }];
                                    }

                                }];
}
#pragma mark - 调用微信支付
- (void)weChatPayWithDictionary:(NSDictionary*)orderDic
                     payorderId:(NSNumber*)payOrderId
                     blackBlock:(void (^)(NSDictionary*))block
{
    NSDictionary* dic = orderDic[@"unifiedOrderClientReqData"];
    NSMutableString* stamp = [dic objectForKey:@"timeStamp"];
    PayReq* req = [[PayReq alloc] init];
    req.openID = [dic objectForKey:@"appId"];
    req.partnerId = [dic objectForKey:@"partnerId"];
    req.prepayId = [dic objectForKey:@"prepayId"];
    req.nonceStr = [dic objectForKey:@"nonceStr"];
    req.timeStamp = stamp.intValue;
    req.package = [dic objectForKey:@"packageValue"];
    req.sign = [dic objectForKey:@"sign"];
    if (payOrderId) {
        _payOrderId = [NSString stringWithFormat:@"%@", payOrderId];
    }
    else if (orderDic[@"payOrder"][@"id"]) {
        _payOrderId = orderDic[@"payOrder"][@"id"];
    }
    else {
        _payOrderId = @"";
    }

    _block = block;
    [WXApi sendReq:req];
}

- (void)onReq:(BaseReq*)req
{
}
- (void)onResp:(BaseResp*)resp
{
    NSString* strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString* strTitle;

    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];

        switch (resp.errCode) {
        case WXSuccess: {
            strMsg = @"支付成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            __weak __typeof(self) weakSelf = self;
            [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_WeixinpayResult
                parameters:@{ @"payOrderId" : _payOrderId }
                success:^(id responseData) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    strongSelf.block(responseData);
                }
                failure:^(NSString* errorMessage){
                }];
            break;
        }
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode, resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode, resp.errStr);
            break;
        }
    }
}
@end
