//
//  YTEditAccountViewController.h
//  YT_business
//
//  Created by chun.chen on 15/7/23.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "YTBaseViewController.h"

@interface YTEditAccountViewController : YTBaseViewController

@property (nonatomic, copy) NSString *fieldText;
@property (nonatomic, copy) NSString *placeholder;
@property(nonatomic, assign) UIKeyboardType keyboardType;

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock;

@end
