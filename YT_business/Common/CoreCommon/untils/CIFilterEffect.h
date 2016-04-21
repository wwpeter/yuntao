//
//  CIFilterEffect.h
//  YT_business
//
//  Created by chun.chen on 15/7/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIFilterEffect : NSObject
@property (nonatomic, strong, readonly) UIImage *qrCodeImage;

- (instancetype)initWithQRCodeString:(NSString *)string width:(CGFloat)width;
@end
