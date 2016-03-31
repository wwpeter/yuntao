
/*
 NSDate+TimeInterval.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import "NSDate+TimeInterval.h"

@implementation NSDate (TimeInterval)

static NSDateFormatter* dateFormatter;
+ (NSDate *)dateFormString:(NSString *)string
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:string];
}
+ (NSDate*)dateFormJavaTimestamp:(NSTimeInterval)secs
{
    NSDate* configData = [NSDate dateWithTimeIntervalSince1970:(secs / 1000)];
    return configData;
}
+ (NSDateComponents*)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDate* date1 = [[NSDate alloc] init];
    NSDate* date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];

    unsigned int unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;

    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString*)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents* components = [self.class componetsWithTimeInterval:timeInterval];

    if (components.hour > 0) {
        return [NSString stringWithFormat:@"%@:%@:%@", @(components.hour), @(components.minute), @(components.second)];
    }

    else {
        return [NSString stringWithFormat:@"%@:%@", @(components.minute), @(components.second)];
    }
}
+ (NSString*)timeDescriptionDateLine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    [dateFormatter setDateFormat:@"MM-dd hh:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}
+ (NSString*)timestampToTimeSting:(NSTimeInterval)timestamp dateFormar:(NSString*)format
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString* timeStr = [dateFormatter stringFromDate:confromTimesp];
    return timeStr;
}
+ (NSString*)timestampToYear:(NSTimeInterval)timestamp
{
    return [self timestampToTimeSting:timestamp dateFormar:@"yyyy-MM-dd"];
}
+ (NSString*)timestampToMonth:(NSTimeInterval)timestamp
{
    return [self timestampToTimeSting:timestamp dateFormar:@"MM/dd"];
}
+ (NSInteger)ageWithDate:(NSDate*)date
{
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
        components:NSYearCalendarUnit
          fromDate:date
            toDate:now
           options:0];
    NSInteger age = [ageComponents year];

    return age;
}
+ (NSString*)constellationWithDate:(NSDate*)date
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });

    NSString* returnString = @"";
    [dateFormatter setDateFormat:@"MM"];
    NSInteger i_month = 0;
    NSString* theMonth = [dateFormatter stringFromDate:date];
    if ([[theMonth substringToIndex:0] isEqualToString:@"0"]) {
        i_month = [[theMonth substringFromIndex:1] integerValue];
    }
    else {
        i_month = [theMonth integerValue];
    }

    [dateFormatter setDateFormat:@"dd"];
    NSInteger i_day = 0;
    NSString* theDay = [dateFormatter stringFromDate:date];
    if ([[theDay substringToIndex:0] isEqualToString:@"0"]) {
        i_day = [[theDay substringFromIndex:1] integerValue];
    }
    else {
        i_day = [theDay integerValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
    case 1:
        if (i_day >= 20 && i_day <= 31) {
            returnString = @"水瓶座";
        }
        if (i_day >= 1 && i_day <= 19) {
            returnString = @"摩羯座";
        }
        break;
    case 2:
        if (i_day >= 1 && i_day <= 18) {
            returnString = @"水瓶座";
        }
        if (i_day >= 19 && i_day <= 31) {
            returnString = @"双鱼座";
        }
        break;
    case 3:
        if (i_day >= 1 && i_day <= 20) {
            returnString = @"双鱼座";
        }
        if (i_day >= 21 && i_day <= 31) {
            returnString = @"白羊座";
        }
        break;
    case 4:
        if (i_day >= 1 && i_day <= 19) {
            returnString = @"白羊座";
        }
        if (i_day >= 20 && i_day <= 31) {
            returnString = @"金牛座";
        }
        break;
    case 5:
        if (i_day >= 1 && i_day <= 20) {
            returnString = @"金牛座";
        }
        if (i_day >= 21 && i_day <= 31) {
            returnString = @"双子座";
        }
        break;
    case 6:
        if (i_day >= 1 && i_day <= 21) {
            returnString = @"双子座";
        }
        if (i_day >= 22 && i_day <= 30) {
            returnString = @"巨蟹座";
        }
        break;
    case 7:
        if (i_day >= 1 && i_day <= 22) {
            returnString = @"巨蟹座";
        }
        if (i_day >= 23 && i_day <= 31) {
            returnString = @"狮子座";
        }
        break;
    case 8:
        if (i_day >= 1 && i_day <= 22) {
            returnString = @"狮子座";
        }
        if (i_day >= 23 && i_day <= 31) {
            returnString = @"处女座";
        }
        break;
    case 9:
        if (i_day >= 1 && i_day <= 22) {
            returnString = @"处女座";
        }
        if (i_day >= 23 && i_day <= 30) {
            returnString = @"天秤座";
        }
        break;
    case 10:
        if (i_day >= 1 && i_day <= 23) {
            returnString = @"天秤座";
        }
        if (i_day >= 24 && i_day <= 31) {
            returnString = @"天蝎座";
        }
        break;
    case 11:
        if (i_day >= 1 && i_day <= 21) {
            returnString = @"天蝎座";
        }
        if (i_day >= 22 && i_day <= 30) {
            returnString = @"射手座";
        }
        break;
    case 12:
        if (i_day >= 1 && i_day <= 21) {
            returnString = @"射手座";
        }
        if (i_day >= 22 && i_day <= 31) {
            returnString = @"摩羯座";
        }
        break;
    default:
        break;
    }
    return returnString;
}
@end
