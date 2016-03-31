#import "DeviceUtil.h"
#import "sys/utsname.h"
#import "UUIDUtil.h"
#import "ApplyUntil.h"

@implementation DeviceUtil
+ (BOOL)isIpadDevice
{
    NSRange range = [[self deviceModel] rangeOfString:@"iPad"];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}
+ (NSString *)deviceModel
{
    return [[UIDevice currentDevice] model];
}
+ (NSString *)deviceSystemName
{
    return [[UIDevice currentDevice] systemName];
}
+ (NSString *)deviceSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (NSString *)deviceUserAgent
{
    NSString *uaStr = [NSString stringWithFormat:@"appName/%@,appVersion/%@,systemName/%@,systemVersion/%@,deviceVersion/%@,width/%@,height/%@",@"YTUser",[ApplyUntil version],[self deviceSystemName],[self deviceSystemVersion],[self deviceVersion],@([[UIScreen mainScreen] currentMode].size.width),@([[UIScreen mainScreen] currentMode].size.height)];
    return uaStr;
}
+ (NSString *)devicesUUID
{
    // 获取UUID
    NSMutableDictionary *udic = (NSMutableDictionary *)[UUIDUtil load:YT_KEY_IDIC];
    NSString *uuid = udic[YT_KEY_UUID];
    if (!uuid)
    {
        uuid = [UUIDUtil uuid];
        NSMutableDictionary *udic = [NSMutableDictionary dictionary];
        udic[YT_KEY_UUID] = uuid;
        [UUIDUtil save:YT_KEY_IDIC data:udic];
    }
    
    return uuid;
}
/**
 *  需要#import "sys/utsname.h"
 *  更新地址:http://theiphonewiki.com/wiki/Models
 *
 *  @return 设备型号
 */
+ (NSString *)deviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5";
    
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2";
    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return deviceString;
}

@end
