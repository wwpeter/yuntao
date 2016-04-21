//
//  UIImageView+setIMImageWithURL.m
//  iMei
//
//  Created by yandi on 15/3/23.
//  Copyright (c) 2015年 OuerTech. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "UIImageView+setYTImageWithURL.h"

@implementation UIImageView (setYTImageWithURL)
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
                           wSelf.alpha = 0.;
                           objc_setAssociatedObject(imageStr, &imageLoaded, @(1), OBJC_ASSOCIATION_RETAIN);
                           [UIView animateWithDuration:.5 delay:0.
                                               options:UIViewAnimationOptionAllowUserInteraction
                                            animations:^{
                                                wSelf.alpha = 1.;
                                            } completion:NULL];
                       } else {
                           if (image) {
                               wSelf.image = image;
                           }
                       }
                   }];
}
@end
