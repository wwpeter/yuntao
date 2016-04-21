//
//  YTMessageModel.h
//  YT_business
//
//  Created by chun.chen on 15/11/13.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTMessageModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *message;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
@end
