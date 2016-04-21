//
//  UITextField+YTLimit.m
//  YT_business
//
//  Created by chun.chen on 15/12/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "UITextField+YTLimit.h"

@implementation UITextField (YTLimit)
- (BOOL)validateNumberReplacementString:(NSString*)string
{
    NSRange foundPoint = [self.text rangeOfString:@"." options:NSCaseInsensitiveSearch];
    if (foundPoint.length > 0) {
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }
    else {
        if ([string isEqualToString:@"."] && (self.text.length == 0)) {
            self.text = @"0";
        }
    }
    return YES;
}
- (void)addTextValueChange
{
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField*)textField
{
    NSRange foundPoint = [textField.text rangeOfString:@"." options:NSCaseInsensitiveSearch];
    if (foundPoint.location == NSNotFound) {
        return;
    }
    NSArray* textArray = [textField.text componentsSeparatedByString:@"."];
    NSString* pointStr = [textArray lastObject];
    if (pointStr.length > 2) {
        pointStr = [pointStr substringToIndex:2];
    }
    textField.text = [NSString stringWithFormat:@"%@.%@", [textArray firstObject], pointStr];
}
@end
