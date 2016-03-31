#import "NSStrUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSStrUtil

+ (BOOL) isEmptyOrNull:(NSString*) string
{
    return ![self notEmptyOrNull:string];
    
}

+ (BOOL) notEmptyOrNull:(NSString*) string
{
    if([string isKindOfClass:[NSNull class]])
        return NO;
    if ([string isKindOfClass:[NSNumber class]]) {
        if (string != nil) {
            return  YES;
        }
        return NO;
    } else {
        string=[self trimString:string];
        if (string != nil && string.length > 0 && ![string isEqualToString:@"null"]&&![string isEqualToString:@"(null)"]&&![string isEqualToString:@"<null>"]&&![string isEqualToString:@" "]) {
            return  YES;
        }
        return NO;
    }
}

+ (NSString*) makeNode:(NSString*) str{
    return [[NSString alloc] initWithFormat:@"<node>%@</node>", str];
}
+ (NSString *)makeBlank:(NSString*) str
{
    if ([self isEmptyOrNull:str]) {
        return @"";
    }
    else {
        return str;
    }
}
+ (NSString *)trimString:(NSString *) str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (CGFloat) stringWidthWithString:(NSString *)string stringFont:(UIFont *)font
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}
+ (CGFloat) stringHeightWithString:(NSString *)string stringFont:(UIFont *)font textWidth:(CGFloat)width
{
    
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    CGSize labelSize = textRect.size;
    
    return labelSize.height;
}
/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString*)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString* MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString* CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString* CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString* CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSString* PHONE = @"^(1(3|5|8|4[57])\\d{8,9})|(0[1-9]\\d{9,10})$";
    /**
     29         * 电话类型：China
     30         */
    
    NSPredicate* regextestphone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONE];
    NSPredicate* regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate* regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate* regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate* regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphone evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark 秒转时分秒
+(NSString*)timeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%@",@(seconds/3600)];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%@",@((seconds%3600)/60)];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%@",@(seconds%60)];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}
#pragma mark 数字转换
+ (NSString *)stringFromIntegerValue:(NSInteger)integerValue
{
    NSString *numString = @"";
    if (integerValue < 1000) {
        numString = [NSString stringWithFormat:@"%@",@(integerValue)];
    } else {
        if (integerValue < 1000000) {
            CGFloat i = (CGFloat)integerValue/1000;
            numString = [NSString stringWithFormat:@"%.1fk",i];
        } else {
            CGFloat i = (CGFloat)integerValue/10000;
            numString = [NSString stringWithFormat:@"%.1fw",i];
        }
    }
    return numString;
}
#pragma mark 时间戳
+ (NSString *)generateTimestamp{
    return [NSString stringWithFormat:@"%ld", time(NULL)];
}
+ (NSString *)signString:(NSArray*)array
{
    NSArray *newarr = [array sortedArrayUsingFunction:nickNameSort context:NULL];
    NSString *str = [newarr componentsJoinedByString:@""];
    NSString *sign = [NSString stringWithFormat:@"%@%@%@",@"52163728",str,@"c4ca4238a0b923820dcc509a6f75849b"];
    sign = [sign lowercaseString];
    sign = [[sign GetMD5] uppercaseString] ;
    return sign;
}
+ (id)jsonObjecyWithString:(NSString*)str
{
    if ([self notEmptyOrNull:str]) {
        NSError* error = nil;
        NSData* postData = [str dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization
            JSONObjectWithData:postData
                       options:NSJSONReadingMutableLeaves
                         error:&error];

        if (jsonObject != nil && error == nil) {
            return jsonObject;
        }
    }
    return nil;
}
#pragma mark 数字转化
+ (NSString *)stringWithNumberDecimalFormat:(NSNumber *)number
{
    NSNumberFormatter *numFormat = [[NSNumberFormatter alloc] init];
    [numFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numFormat stringFromNumber:number];
}
#pragma mark是否为整形：

+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark 是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark 登录
+ (NSString *)ytLoginMD5WithPhoneNumber:(NSString *)phoneNum password:(NSString *)psd
{
//    NSString *str = [NSString stringWithFormat:@"%@_%@",phoneNum,psd];
    return [psd GetMD5];
}
#pragma mark 计算字符串长度
+ (NSInteger)wordCount:(NSString*)s
{
    NSInteger i,n=[s length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(NSInteger)ceilf((float)(a+b)/2.0);
}

/************** 计算颜色 ************************/
UIColor* colorFromHexRGB(NSString *inColorString){
    
    if ([NSStrUtil isEmptyOrNull:inColorString]) {
        return nil;
    }
    
    inColorString = [inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([NSStrUtil isEmptyOrNull:inColorString]) {
        return nil;
    }
    
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}
/************** A,B,C,D排序 ************************/
NSInteger nickNameSort(id user1, id user2, void *context)
{
    NSString *u1,*u2;
    //类型转换
    u1 = (NSString*)user1;
    u2 = (NSString*)user2;
    return  [u1 localizedCompare:u2];
}
@end

@implementation NSString (ImageWidth)

- (NSString *)imageStringWithWidth:(CGFloat)width
{
    return [NSString stringWithFormat:@"%@?imageView2/0/w/%@",self,@(width)];
}
- (NSURL *)imageUrlWithWidth:(CGFloat)width
{
    return [NSURL URLWithString:[self imageStringWithWidth:width]];
}
@end

@implementation NSString (MyExtensions)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (NSString *) GetMD5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString uppercaseString];
}

@end

@implementation NSData (MyExtensions)
- (NSString*)md5
{
    unsigned char result[16];
    CC_MD5( self.bytes, (CC_LONG)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

