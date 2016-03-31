
// 服务器地址
extern NSString* const YC_WSSERVICE_HTTP;
// 发送注册短信
extern NSString* const YC_Request_RegMobile;
// 注册
extern NSString* const YC_Request_Registe;
// 忘记密码发送注册短信
extern NSString* const YC_Request_SendSmsCodeForForgetPwd;
// 重置密码
extern NSString* const YC_Request_UpdatePwdForForget;
// 登录
extern NSString* const YC_Request_Login;
// 商户活动
extern NSString* const YC_Request_Activity;
// 商户类型
extern NSString* const YC_Request_Shopcat;
// 查找商户
extern NSString* const YC_Request_QueryShop;
// 商户详情
extern NSString* const YC_Request_ShopInfo;
// 红包搜索
extern NSString* const YC_Request_QueryHongbaoList;
// 我的红包列表
extern NSString* const YC_Request_MyHongbaoList;
// 我的红包详情
extern NSString* const YC_Request_MyHongbaoDetail;
// 红包详情
extern NSString* const YC_Request_HongbaoInfo;
extern NSString* const YC_Request_HongbaoDetail;
// 转赠红包
extern NSString* const YC_Request_GiveHongbao;
// 查看该店铺可领取的红包列表
extern NSString* const YC_Request_ReceiveAbleHongbaoList;
//上传个人头像
extern NSString* const YC_Request_UpdataAvatarImg;
//获取用户信息
extern NSString* const YC_Request_UserInfo;
//获取用户是否登录
extern NSString* const YC_Request_UserIsLogin;
//修改昵称
extern NSString* const YC_Request_UpdateUserInfo;
//修改密码
extern NSString* const YC_Request_UpdatePassWord;
//修改手机绑定验证码
extern NSString* const YC_Request_SendSmsForUpdateMobile;
//修改手机绑定
extern NSString* const YC_Request_UpdateMobile;
//发起支付宝付款
extern NSString* const YC_Request_Alipay;
//支付宝支付后反馈
extern NSString* const YC_Request_AlipayResult;
//发起微信付款
extern NSString* const YC_Request_Weixinpay;
//微信支付后反馈
extern NSString* const YC_Request_WeixinpayResult;
//扫一扫收款创建授权码
extern NSString* const YC_Request_CreateUserAuthCode;
//扫一扫收款查看授权码状态
extern NSString* const YC_Request_UserAuthCodeResult;
//设置消息是否推送
extern NSString* const YC_Request_SetCustomConfig;
//我的付款记录
extern NSString* const YC_Request_PayOrderPage;
//我的付款记录详情
extern NSString* const YC_Request_PayOrderDetail;
extern NSString* const YC_Request_PayOrderPage;
//领取红包
extern NSString* const YC_Request_ReceivePayedHongbao;
//我的消息列表
extern NSString* const YC_Request_MessageList;
//提交意见
extern NSString* const YC_Request_SubSuggeston;
//获取区域
extern NSString* const YC_Request_GetZoneList;

//会员获取商户发布信息汇总
extern NSString* const YC_Request_GetXjswHbList;
//会员获取发布信息列表
extern NSString* const YC_Request_GetPublishList;
//会员领取现金实物红包
extern NSString* const YC_Request_ChangeHbStatus;
//会员领取现金实物红包
extern NSString* const YC_Request_GetPsqptHbListByPublishId;
//会员读取信息
extern NSString* const YC_Request_ReadMessage;
//查询会员用户账户余额
extern NSString* const YC_Request_QueryMemberAcount;
//会员提现设置支付密码
extern NSString* const YC_Request_SetPayPasswd;
//会员手机话费充值
extern NSString* const YC_Request_MemberMobileCharge;
//提现
extern NSString* const YC_Request_MemberApplyBankCashout;
// 保存商户银行
extern NSString* const YC_Request_SaveBank;
// 商户银行列表
extern NSString* const YC_Request_MyBankList;
//会员账单明细清单列表
extern NSString* const YC_Request_MemberBillDetailList;
//会员余额支付
extern NSString* const YC_Request_MemberBalancePay;


#import <Foundation/Foundation.h>

@interface YCApi : NSObject
+ (NSString *)loginCookieName;
// 保存某个urlcookie
+ (void)saveCookiesWithUrlString:(NSString *)urlStr;
+ (void)saveCookiesWithUrl:(NSURL *)url;
// 获取cookie
+ (void)setupCookies;
// 指定删除登录cookie
+ (void)deleteLoginCookie;
// 指定删除某个cookie
+ (void)deleteCookieWithKey:(NSString *)key;
// 删除所有cookie
+ (void)deleteAllCookieWithKey;
@end
