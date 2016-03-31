#import "UIImage+HBClass.h"

@implementation UIImage (HBClass)
-(UIImage*) getLimitImage:(CGSize) size
{
    // 排错
    if(size.width==0||size.height==0)
        return self;
    CGSize imgSize=self.size;
    float scale=size.height/size.width;
    float imgScale=imgSize.height/imgSize.width;
    float width=0.0f,height=0.0f;
    if(imgScale<scale&&imgSize.width>size.width){
        width=size.width;
        height=width*imgScale;
    }else if(imgScale>scale&&imgSize.height>size.height){
        height=size.height;
        width=height/imgScale;
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage * image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage*) getClickImage:(CGSize) size
{
    // 排错
    if(size.width==0||size.height==0)
        return self;
    CGSize imgSize=self.size;
    UIImageOrientation  orientation=self.imageOrientation;
    CGRect rect;
    if(size.height>=imgSize.height&&size.width>=imgSize.width)
        return self;
    else if(size.height>=imgSize.height&&size.width<imgSize.width)
        rect=CGRectMake((imgSize.width-size.width)/2, 0, size.width, imgSize.height);
    else if(size.height<imgSize.height&&size.width>=imgSize.width)
        rect=CGRectMake(0, (imgSize.height-size.height)/2, imgSize.width, size.height);
    else
        rect=CGRectMake((imgSize.width-size.width)/2,(imgSize.height-size.height)/2, size.width, size.height);
    CGImageRef imgRef=CGImageCreateWithImageInRect(self.CGImage, rect);
    return [UIImage imageWithCGImage:imgRef scale:1 orientation:orientation];
}
#pragma mark - 修改尺寸
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 1.0);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
#pragma mark - 修改图片角度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
#pragma mark - 颜色 -> 图片
+ (UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
#pragma mark - 合并图片
- (UIImage *)addTwoImageToOne:(UIImage *) oneImg twoImage:(UIImage *) twoImg rect:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [oneImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGFloat twoX = (size.width - twoImg.size.width) / 2;
    CGFloat twoY = (size.height - twoImg.size.height) / 2;
    [twoImg drawInRect:CGRectMake(twoX, twoY, twoImg.size.width, twoImg.size.height)];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImg;
}
- (UIImage *)addTwoImageToOne:(UIImage *) oneImg twoImage:(UIImage *) twoImg

{
    
    UIGraphicsBeginImageContext(oneImg.size);
    
    [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
    
    [twoImg drawInRect:CGRectMake(0, 0, twoImg.size.width, twoImg.size.height)];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImg;
}
#pragma mark - 创建背景图片
+ (UIImage *)placeImage: (CGSize)size
{
    UIImage *placeImage = [[UIImage alloc]init];
    placeImage = [self createImageWithColor:CCCUIColorFromHex(0xE9E9E9)];
    UIImage *twoImage = [UIImage imageNamed:@"dk_place_01.png"];
    placeImage = [placeImage addTwoImageToOne:placeImage twoImage:twoImage rect:size];
    return placeImage;
}
+ (UIImage *)imageWithSex: (NSInteger)sex age:(NSInteger)age;
{
    UIImage *backImage = nil;
    NSString *imageName = @"";
    if (sex == 0) {
        imageName = age > 0 ? @"individualsexagebackground_madam.png" : @"usersex_madam.png";
    } else {
        imageName = age > 0 ? @"individualsexagebackground_man.png" : @"usersex_man.png";
    }
    backImage = [UIImage imageNamed:imageName];
    CGSize imageSize = backImage.size;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:backView.bounds];
    sexImageView.image = backImage;
    [backView addSubview:sexImageView];
    
    if (age > 0) {
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, imageSize.width-10, imageSize.height)];
        ageLabel.font = [UIFont systemFontOfSize:10];
        ageLabel.textColor = [UIColor whiteColor];
        ageLabel.textAlignment = NSTextAlignmentCenter;
        ageLabel.text = [NSString stringWithFormat:@"%@",@(age)];
        [backView addSubview:ageLabel];
    }
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0); //retina res
    [backView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
@end
