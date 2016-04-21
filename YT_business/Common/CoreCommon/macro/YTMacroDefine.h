/////////////////////
//     全局定义     //
/////////////////////

// UUID
#define YT_KEY_IDIC            @"com.yuntao.idic"
#define YT_KEY_UUID            @"com.yuntao.uuid"

#define YT_WSSERVICE_KEY @" "


// 尺寸
#define kStatusHeight  [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavigationFullHeight  64
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5_Before (([[UIScreen mainScreen] currentMode].size.height < 1136) ? YES : NO)
#define iPhone6p_Later (([[UIScreen mainScreen] currentMode].size.height >= 2208) ? YES : NO)
#define iPhoneMultiple kDeviceWidth/320
#define kDeviceCurrentWidth [[UIScreen mainScreen] currentMode].size.width

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define CCImageNamed(name) ([UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]])

#define ArchiveFilePath(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:fileName]

// 颜色
#define CCCUIColorFromHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
#define CCColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define CCColorFromRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define YTDefaultRedColor CCCUIColorFromHex(0xff5c63)

// 图片
#define YTNavbackbarImage               [UIImage imageNamed:@"yt_navigation_background_01.png"]
#define YTlightGrayLineImage            [UIImage imageNamed:@"yt_grayline.png"]
#define YTlightGrayTopLineImage         [UIImage imageNamed:@"yt_grayline_03.png"]
#define YTlightGrayBottomLineImage      [UIImage imageNamed:@"yt_grayline_02.png"]

#define YTUserNormalImage              [UIImage imageNamed:@"userdefaultavatar.png"]
#define YTUserPlaceImage               [UIImage imageNamed:@"userplaceavatar.png"]

#define YTNormalPlaceImage              [UIImage imageNamed:@"yt_normalplaceImage.png"]


// Tools
#define wSelf(wSelf)  __weak typeof(self) wSelf = self
#define NOTIFICENTER  [NSNotificationCenter defaultCenter]
#define USERDEFAULT   [NSUserDefaults standardUserDefaults]

// Keys
#define loadingKey      @"loadingKey"
#define postingDataKey    @"postingDataKey"
#define isLoadingMoreKey  @"isLoadingMoreKey"

// swizzle_method
extern void swizzle_method(Class class,SEL originalSelector,SEL swizzledSelector);

// Url
#define hostURL @"http://biz.api.yuntaohongbao.com"
//#define hostURL @"http://test.biz.api.yuntaohongbao.com"
//#define hostURL @"http://demo.biz.api.yuntaohongbao.com"

// 登录
#define registerUploadPicURL @"biz/registerUploadPic"
// 登录
#define loginURL @"biz/login"
// 营业员登录
#define saleLoginURL @"sale/assLogin"
// 注册
#define registerURL @"biz/registe"
#define registerNewURL @"biz/registerNew"
// 重置密码验证码
#define sendSmsCodeForForgetPwdURL @"biz/sendSmsCodeForForgetPwd"
// 重置密码
#define updatePwdForForgetURL @"biz/updatePwdForForget"
// 重置密码验证码
#define saleSendSmsCodeForForgetPwdURL @"sale/sendSmsCodeForForgetPwd"
// 重置密码
#define saleUpdatePwdForForgetURL @"sale/updatePwdForForget"

// 手机验证码
#define sendRegCodeURL @"biz/regMobile"
// 用户信息
#define userInfoURL @"biz/userInfo"
// 发送修改手机号验证码
#define sendSmsForUpdateMobileURL @"biz/sendSmsForUpdateMobile"
// 修改手机号码
#define updateMobileURL @"biz/updateMobile"
// 修改密码
#define updatePassWordURL @"biz/updatePassWord"

// 意见反馈
#define suggestURL @"biz/suggest"

// 商户支付订单
#define tradeURL @"biz/myShopPayOrder"
// 账单明细
#define accountDetailListURL @"biz/accountDetailList"
// 营业员支付订单
#define saleTradeURL @"sale/myShopPayOrder"
// 引流统计
#define drainageHongbaoIndexURL @"biz/sellingHongbaoIndex"
// 引流红包列表
#define drainageListURL @"biz/sellerHongbaoList"
// 购买的红包
#define buyedHongbaoURL @"biz/shopBuyHongbaoList"
// 促销统计
#define buyHongbaoIndexURL @"biz/buyHongbaoIndex"
// 获取促销页设置
#define getPromoteSetURL @"biz/getPromoteSet"
// 可上下架红包列表
#define setBuyHongbaoStatusListURL @"biz/setBuyHongbaoStatusList"
// 设置促销页
#define savePromoteSetURL @"biz/savePromoteSet"
// 红包订单
#define orderHongbaoURL @"biz/shopOrderList"
// 创建红包
#define createHongbaoURL @"biz/createHongbao"
#define refundHongbaoURL @"biz/refundPageList"
// 推荐的红包
#define recomentHongbaoURL @"biz/recHongbaoList"
// 附近的红包
#define recomentHongbaoURL @"biz/recHongbaoList"
// 获取店铺分类
#define getShopCategoryURL @"biz/getShopcat"
// 我的出售红包详情
#define saleHongbaoDetailURL @"biz/mySellingHongbaoDetail"
// 城市匹配
#define cityMatchURL @"biz/cityMatch"
// 下架引流红包
#define stockHongbaoURL @"biz/stockHongbao"
// 确认红包
#define confirmHongbaoURL @"biz/confirmHongbao"
//// 商家找商家
//#define queryShopListURL         @"biz/queryShopList"
// 商家创建红包的时候找商家
#define queryShopListURL @"biz/queryExcludeShopList"
// 查找红包
#define queryHongbaoListURL @"biz/queryHongbaoList"
// 红包详情
#define hongbaoInfoURL @"biz/hongbaoInfo"
// 我的消息列表
#define messageListURL @"biz/messageList"

// 店铺详情
#define shopInfoURL @"biz/shopInfo"
// 修改主图
#define updateMasterImgURL @"biz/updateMasterImg"
// 增加环境图片
#define addHJImgURL @"biz/addHJImg"
// 删除环境图片
#define deleteHJImgURL @"biz/deleteHJImg"
// 修改店铺信息
#define updateShopInfoURL @"biz/updateShopInfo"
// 修改店铺营业执照
#define updateLicenseImgURL @"biz/updateLicenseImg"

// 支付宝购买红包
#define buyHongbaoUseAlipayURL @"biz/buyHongbaoUseAlipay"
//红包退款
#define refundPayHongbaoURL @"biz/refundHongbao"
// 继续付款支付宝订单
#define continueAlipayURL @"biz/continueAlipay"
// 支付宝付款购买的红包完成后回调
#define alipayResultURL @"biz/alipayResult"

// 支付宝商户收款入口
#define bizBarPayURL @"biz/barPay"
// 支付宝营业员付款
#define saleBarPayURL @"sale/barPay"
//商户当面付退款
#define bizBarCancelPayURL @"biz/cancelBarPay"
//营业员当面付退款
#define saleCancelPayURL @"sale/cancelBarPay"
//商户支付宝退款
#define refundToUserURL @"biz/refundToUser"
//商户退款
#define saleRefundToUserURL @"sale/cancelBarPay"

//微信商户扫码当面付
#define weiXinBarPayURL @"biz/weiXinBarPay"
//微信营业员扫码当面付
#define saleWeiXinBarPayURL @"sale/weiXinBarPay"
//微信商户撤销的微信当面付
#define cancelWeiXinBarPayURL @"biz/cancelWeiXinBarPay"
//微信营业员撤销的当面付
#define saleCancelWeiXinBarPayURL @"sale/cancelWeiXinBarPay"
//微信商家买红包
#define buyHongbaoUseWeiXinURL @"biz/buyHongbaoUseWeiXin"
//微信商家买红包结果
#define weiXinPayResultURL @"biz/weiXinPayResult"
// 继续付款支微信订单
#define continueWeixinURL @"biz/continueWeixin"

//云淘商户扫码当面付
#define scanUserAuthCodePayURL @"biz/scanUserAuthCodePay"
//云淘营业员扫码当面付
#define saleScanUserAuthCodePayURL @"sale/scanUserAuthCodePay"
//云淘商户扫码当面付轮询查看授权码状态
#define userAuthCodeResultURL @"biz/userAuthCodeResult"
//云淘营业员扫码当面付轮询查看授权码状态
#define saleUserAuthCodeResultURL @"sale/userAuthCodeResult"

// 余额
#define queryAccountURL @"biz/queryAccount"
// 余额密码
#define steupPayPasswdURL @"biz/setPayPasswd"
// 充值
#define mobileChargeURL @"biz/mobileCharge"
// 提现
#define applyCashoutURL @"biz/applyCashout"

// 常用的银行
#define bankListURL @"bank/bankList"
// 保存商户银行
#define saveBankURL @"bank/saveBank"
// 商户银行列表
#define myBankListURL @"bank/myBankList"
// 提现
#define applyBankCashoutURL @"biz/applyBankCashout"

// 商家验证红包
#define scanUseHongbaoURL @"biz/scanUseHongbao"
// 营业员验证红包
#define saleScanUseHongbaoURL @"sale/scanUseHongbao"

// 会员收益
#define vipShopIndexURL @"biz/vipShopIndex"

// 商户查看营业员列表
#define shopSaleListURL @"biz/shopSaleList"
// 商户添加营业员
#define addShopSaleURL @"biz/addShopSale"
// 商户修改业务员表单页面
#define modifiedShopSaleURL @"biz/modifiedShopSale"
// 商家删除业务员
#define delSaleByIdURL @"biz/delSaleById"
// 获取区域
#define getZoneListURL @"m/getZoneList"

// 商户端获取已发布的信息(红包、通知)
#define getPublishListURL @"biz/getPublishList"
// 商户发布通知信息
#define saveNoticeURL @"biz/saveNotice"
// 获取商户可选择的现金/实物红包列表
#define toChooseXjswhbListURL @"biz/toChooseXjswhbList"
// 商户选择需要发布的红包并保存
#define saveChooseHbTempURL @"biz/saveChooseHbTemp"
// 提示补充库存后的再次提交
#define saveChoosedHbURL @"biz/saveChoosedHb"
// 获取商户会员人数
#define getMembersNumURL @"biz/getMembersNum"
// 获取红包领取人数
#define getPsqptHbListByPublishIdURL @"biz/getPsqptHbListByPublishId"

// 发布红包余额支付
#define yuerPayURL @"biz/yuerPay"
// 发布红包支付宝支付
#define publishAlipayURL @"biz/publishAlipay"
// 发布红包微信支付
#define publishWeixinpayURL @"biz/publishWeixinpay"
// 发布红包支付宝支付回调
#define publishAlipayResultURL @"biz/publishAlipayResult"
// 发布红包微信支付回调
#define publishWeixinpayResultURL @"biz/publishWeixinpayResult"


// 侧边栏宽度
static const CGFloat kLeftDefaultSideWidth = 240.0;

// Notification
static NSString *const kUserLoginSuccessNotification        = @"userLoginSuccessNotification";
static NSString *const kUserLogOutNotification              = @"userLogOutNotification";
static NSString *const kHbStoreBuySuccessNotification              = @"bbStoreBuySuccessNotification";
static NSString *const kHbSoldOutNotification              = @"bbStoreBuySuccessNotification";
static NSString *const kWechatPayRespNotification              = @"wechatPayRespNotification";

// 储存文件名
// 文件路径
static NSString *const iYTDataFileName                = @"YTData";
static NSString *const iYTImageFileName                = @"YTImage";

// 设置
static NSString *const iYTUsercookiesKey              = @"UsercookiesKey";
static NSString *const iYTUserIdKey                   = @"UserIdKey";
static NSString *const iYTUserAvatarKey               = @"UserAvatarKey";
static NSString *const iYTUserImageKey                = @"UserImageKey";
static NSString *const iYTUserMobileKey               = @"UserMobileKey";
static NSString *const iYTUserNameKey                 = @"UserNameKey";
static NSString *const iYTUserUpdateDateKey           = @"UserUpdateDateKey";
static NSString *const iYTUserSelectBankDateKey           = @"UserSelectBankDateKey";
static NSString *const iYTUserCizyZoneEtagKey           = @"UserCizyZoneEtagKey";

static NSString *const YT_Service_Number = @"4001177677";
