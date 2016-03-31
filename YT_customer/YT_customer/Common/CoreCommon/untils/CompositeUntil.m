//
//  CompositeUntil.m
//  YT_customer
//
//  Created by chun.chen on 15/11/11.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "CompositeUntil.h"

@implementation CompositeUntil
+ (BOOL)validateNumberTextField:(UITextField *)textField replacementString:(NSString *)string
{
    NSRange foundPoint =[textField.text rangeOfString:@"." options:NSCaseInsensitiveSearch];
    if (foundPoint.length > 0) {
        if ([string isEqualToString:@"."]) {
            return NO;
        }
    }else{
        if ([string isEqualToString:@"."] && (textField.text.length == 0)) {
            textField.text = @"0";
        }
    }
    return YES;
}
@end
