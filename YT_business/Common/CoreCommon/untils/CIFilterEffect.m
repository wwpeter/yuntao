//
//  CIFilterEffect.m
//  YT_business
//
//  Created by chun.chen on 15/7/6.
//  Copyright (c) 2015年 chun.chen. All rights reserved.
//

#import "CIFilterEffect.h"

@implementation CIFilterEffect
- (instancetype)initWithQRCodeString:(NSString *)string width:(CGFloat)width
{
    self = [super init];
    if (self)
    {
        CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        
        [filter setDefaults];
        
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        [filter setValue:data forKey:@"inputMessage"];
        
        CIImage *outputImage = [filter outputImage];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:outputImage
                                           fromRect:[outputImage extent]];
        
        UIImage *image = [UIImage imageWithCGImage:cgImage
                                             scale:1.0
                                       orientation:UIImageOrientationUp];
        
        // 不失真的放大
        UIImage *resized = [self resizeImage:image
                                 withQuality:kCGInterpolationNone
                                        rate:5.0];
        
        // 缩放到固定的宽度(高度与宽度一致)
        _qrCodeImage = [self scaleWithFixedWidth:width image:resized];
        
        CGImageRelease(cgImage);
    }
    return self;
}
- (UIImage *)scaleWithFixedWidth:(CGFloat)width image:(UIImage *)image
{
    float newHeight = image.size.height * (width / image.size.width);
    CGSize size = CGSizeMake(width, newHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}
- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

@end
