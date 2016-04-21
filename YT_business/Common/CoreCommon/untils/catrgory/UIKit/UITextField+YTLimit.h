//
//  UITextField+YTLimit.h
//  YT_business
//
//  Created by chun.chen on 15/12/3.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YTLimit)
- (BOOL)validateNumberReplacementString:(NSString *)string;
- (void)addTextValueChange;
@end
