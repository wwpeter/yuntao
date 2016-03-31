//
//  CIFilterEffect.h
//  YT_customer
//
//  Created by chun.chen on 15/6/18.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIFilterEffect : NSObject
@property (nonatomic, strong, readonly) UIImage *qrCodeImage;

- (instancetype)initWithQRCodeString:(NSString *)string width:(CGFloat)width;

@end
