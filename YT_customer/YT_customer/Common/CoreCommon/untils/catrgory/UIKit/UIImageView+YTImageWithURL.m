//
//  UIImageView+YTImageWithURL.m
//  YT_customer
//
//  Created by chun.chen on 15/8/27.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "UIImageView+YTImageWithURL.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>
#import "NSStrUtil.h"

@implementation UIImageView (YTImageWithURL)
static char *imageLoaded;
- (void)setYTImageWithURL:(NSString *)imageStr placeHolderImage:(UIImage *)placeHolderImage {
    __weak typeof(self) wSelf = self;
    if ([NSStrUtil isEmptyOrNull:imageStr]) {
        self.image = placeHolderImage;
        return ;
    }
    
    [self sd_setImageWithURL:[NSURL URLWithString:imageStr]
            placeholderImage:placeHolderImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       BOOL isLoaded = [objc_getAssociatedObject(imageStr, &imageLoaded) boolValue];
                       if (!isLoaded) {
                           objc_setAssociatedObject(imageStr, &imageLoaded, @(1), OBJC_ASSOCIATION_RETAIN);
                       } else {
                           if (image) {
                               wSelf.image = image;
                           }
                       }
                   }];
}

@end
