
NSString* const YC_WSSERVICE_HTTP = @"http://user.api.yuntaohongbao.com";
//NSString* const YC_WSSERVICE_HTTP = @"http://test.user.api.yuntaohongbao.com";
//NSString* const YC_WSSERVICE_HTTP = @"http://demo.user.api.yuntaohongbao.com";

NSString* const YC_Request_RegMobile = @"/m/regMobile";
NSString* const YC_Request_Registe = @"/m/registe";
NSString* const YC_Request_SendSmsCodeForForgetPwd = @"/m/sendSmsCodeForForgetPwd";
NSString* const YC_Request_UpdatePwdForForget = @"/m/updatePwdForForget";
NSString* const YC_Request_Login = @"/m/login";
NSString* const YC_Request_Activity = @"/m/activity";
NSString* const YC_Request_Shopcat = @"/m/getShopcat";
NSString* const YC_Request_QueryShop = @"/m/queryShop";
NSString* const YC_Request_MyHongbaoDetail = @"/m/myHongbaoDetail";
NSString* const YC_Request_HongbaoInfo = @"/m/hongbaoInfo";
NSString* const YC_Request_HongbaoDetail = @"/m/hongbaoDetail";
NSString* const YC_Request_GiveHongbao = @"/m/giveHongbao";
NSString* const YC_Request_QueryHongbaoList = @"/m/queryHongbaoList";
NSString* const YC_Request_MyHongbaoList = @"/m/myHongbaoList";
NSString* const YC_Request_ShopInfo = @"/m/shopInfo";
NSString* const YC_Request_ReceiveAbleHongbaoList = @"/m/receiveAbleHongbaoList";
NSString* const YC_Request_UpdataAvatarImg = @"/m/updateAvatarImg";
NSString* const YC_Request_UserInfo = @"/m/userInfo";
NSString* const YC_Request_UserIsLogin= @"/m/isLogin";
NSString* const YC_Request_UpdateUserInfo = @"/m/updateUserInfo";
NSString* const YC_Request_UpdatePassWord = @"/m/updatePassWord";
NSString* const YC_Request_SendSmsForUpdateMobile = @"/m/sendSmsForUpdateMobile";
NSString* const YC_Request_UpdateMobile = @"/m/updateMobile";
NSString* const YC_Request_Alipay = @"/m/alipay";
NSString* const YC_Request_AlipayResult = @"/m/alipayResult";
NSString* const YC_Request_Weixinpay = @"/m/weixinpay";
NSString* const YC_Request_WeixinpayResult = @"/m/weixinpayResult";
NSString* const YC_Request_CreateUserAuthCode = @"/m/createUserAuthCode";
NSString* const YC_Request_UserAuthCodeResult = @"/m/userAuthCodeResult";
NSString* const YC_Request_SetCustomConfig = @"/m/setCustomConfig";
NSString* const YC_Request_PayOrderPage = @"/m/payOrderPage";
NSString* const YC_Request_PayOrderDetail = @"/m/payOrderDetail";
NSString* const YC_Request_ReceivePayedHongbao = @"/m/receivePayedHongbao";
NSString* const YC_Request_MessageList = @"/m/messageList";
NSString* const YC_Request_SubSuggeston = @"/m/suggest";
NSString* const YC_Request_GetZoneList = @"/m/getZoneList";
NSString* const YC_Request_GetXjswHbList = @"/m/getTotalByUserId";
NSString* const YC_Request_GetPublishList = @"/m/getPublishList";
NSString* const YC_Request_ChangeHbStatus = @"/m/changeHbStatus";
NSString* const YC_Request_GetPsqptHbListByPublishId = @"/m/getPsqptHbListByPublishId";
NSString* const YC_Request_ReadMessage = @"/m/readMessage";
NSString* const YC_Request_QueryMemberAcount = @"/m/queryMemberAcount";
NSString* const YC_Request_SetPayPasswd = @"/m/setPayPasswd";
NSString* const YC_Request_MemberMobileCharge = @"/m/memberMobileCharge";
NSString* const YC_Request_MemberApplyBankCashout = @"/m/memberApplyBankCashout";
NSString* const YC_Request_SaveBank = @"/bank/saveBank";
NSString* const YC_Request_MyBankList = @"/bank/myBankList";
NSString* const YC_Request_MemberBillDetailList = @"/m/memberBillDetailList";
NSString* const YC_Request_MemberBalancePay = @"/m/memberBalancePay";//支付

#import "YCApi.h"

@implementation YCApi
+ (NSString *)loginCookieName
{
    return @"_login_id";
}

+ (void)saveCookiesWithUrlString:(NSString *)urlStr
{
    [self saveCookiesWithUrl:[NSURL URLWithString:urlStr]];
}
+ (void)saveCookiesWithUrl:(NSURL *)url
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: url];
    /********************cookie start******************************/
    //    for (NSHTTPCookie *cookie in cookies) {
    //        NSLog(@"cookie:\n%@", cookie);
    //        NSLog(@"cookie.value:\n%@",cookie.value);
    //    }
    /*******************cookie end*******************************/
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:iYCUsercookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setupCookies
{
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUsercookiesKey];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }  
    }
}
+ (void)deleteLoginCookie
{
    [self deleteCookieWithKey:[self loginCookieName]];
}
+ (void)deleteCookieWithKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:iYCUsercookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        if ([[cookie name] isEqualToString:key]) {
            [cookieJar deleteCookie:cookie];
        }
    }
}
+ (void)deleteAllCookieWithKey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:iYCUsercookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[cookieJar cookies]];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieJar deleteCookie:cookie];
    }
}
@end
