//
//  NSString+Number.m
//  YT_business
//
//  Created by chun.chen on 15/8/4.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "NSString+Number.h"

@implementation NSString (Number)

- (CGFloat )ytFloatValue
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:self];
    return myNumber.floatValue;
}
@end
