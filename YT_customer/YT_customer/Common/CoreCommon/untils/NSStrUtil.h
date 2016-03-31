#import <Foundation/Foundation.h>

@interface NSStrUtil : NSObject

// 是否为空
+ (BOOL) isEmptyOrNull:(NSString*) string;
// 不为空
+ (BOOL) notEmptyOrNull:(NSString*) string;
// 是否手机号
+ (BOOL)isValidateMobile:(NSString*)mobile;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

// node 格式
+ (NSString *)makeNode:(NSString*) str;
// 返回非空数据
+ (NSString *)makeBlank:(NSString*) str;
// 整理
+ (NSString *)trimString:(NSString *) str;
// 时间戳
+ (NSString *)generateTimestamp;
// 签名
+ (NSString *)signString:(NSArray*)array;
// 秒转时分秒
+ (NSString *)timeformatFromSeconds:(NSInteger)seconds;
// 数字转换
+ (NSString *)stringFromIntegerValue:(NSInteger)integerValue;
// 文字高度
+ (CGFloat) stringHeightWithString:(NSString *)string stringFont:(UIFont *)font textWidth:(CGFloat)width;
// 文字宽度
+ (CGFloat) stringWidthWithString:(NSString *)string stringFont:(UIFont *)font;
// 字数
+ (NSInteger)wordCount:(NSString*)s;
// 转化json
+ (id)jsonObjecyWithString:(NSString*)str;

// 转化数字 3为单位添加,
+ (NSString *)stringWithNumberDecimalFormat:(NSNumber *)number;

+ (NSString *)ytLoginMD5WithPhoneNumber:(NSString *)phoneNum password:(NSString *)psd;
// 判断是否为整形
+ (BOOL)isPureInt:(NSString*)string;
// 判断是否为浮点形
+ (BOOL)isPureFloat:(NSString*)string;
@end


@interface NSString (ImageWidth)
- (NSString *)imageStringWithWidth:(CGFloat)width;
- (NSURL *)imageUrlWithWidth:(CGFloat)width;
@end

@interface NSString (MyExtensions)
- (NSString *) md5;
- (NSString *) GetMD5;
@end

@interface NSData (MyExtensions)
- (NSString*)md5;
@end
