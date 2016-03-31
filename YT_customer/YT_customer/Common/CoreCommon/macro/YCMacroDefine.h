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

#define YTUserPlaceImage               [UIImage imageNamed:@"userplaceavatar.png"]
#define YTNormalPlaceImage             [UIImage imageNamed:@"hbPlaceImage.png"]
#define YT_Service_Number  @"4001177677"

// Tools
#define wSelf(wSelf)  __weak typeof(self) wSelf = self
#define NOTIFICENTER  [NSNotificationCenter defaultCenter]
#define USERDEFAULT   [NSUserDefaults standardUserDefaults]

// Keys
#define loadingKey      @"loadingKey"
#define postingDataKey    @"postingDataKey"
#define isLoadingMoreKey  @"isLoadingMoreKey"

// Notification
static NSString *const kUserLoginSuccessNotification        = @"userLoginSuccessNotification";
static NSString *const kUserLogOutNotification              = @"userLogOutNotification";

// 储存文件名
// 文件路径
static NSString *const kYCDataFileName                = @"YcData";

// 设置
static NSString *const iYCUsercookiesKey              = @"UsercookiesKey";
static NSString *const iYCUserCityKey                 = @"UserCityKey";
static NSString *const iYCUserIdKey                   = @"UserIdKey";
static NSString *const iYCUserAvatarKey               = @"UserAvatarKey";
static NSString *const iYCUserImageKey                = @"UserImageKey";
static NSString *const iYCUserMobileKey               = @"UserMobileKey";
static NSString *const iYCUserPayPwdKey               = @"UserPayPwdKey";
static NSString *const iYCUserVipShopIdKey               = @"UserVipShopIdKey";
static NSString *const iYCUserNameKey                 = @"UserNameKey";
static NSString *const iYCUserUpdateDateKey           = @"UserUpdateDateKey";
static NSString *const iYTUserCizyZoneEtagKey           = @"UserCizyZoneEtagKey";
static NSString *const iYTUserSelectBankDateKey           = @"UserSelectBankDateKey";
static NSString *const iYCUserTestKey                   = @"UserTestKey";

