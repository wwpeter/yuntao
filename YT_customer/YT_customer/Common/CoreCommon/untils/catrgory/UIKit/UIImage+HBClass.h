

#import <UIKit/UIKit.h>

@interface UIImage (HBClass)

//按原图比例返回限定大小的图片 （未剪切）
- (UIImage*) getLimitImage:(CGSize) size;

// 按原图比例返回限定大小的图片（剪切）
- (UIImage*) getClickImage:(CGSize) size;

// 图片压缩
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

// 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName;

// 修改图片角度
- (UIImage *)fixOrientation:(UIImage *)aImage;

// 合并图片
- (UIImage *)addTwoImageToOne:(UIImage *) oneImg twoImage:(UIImage *) twoImg rect:(CGSize)size;

// 颜色 - 图片
+ (UIImage *)createImageWithColor: (UIColor *) color;

// 创建背景图片
+ (UIImage *)placeImage: (CGSize)size;

// 创建性别+年龄图片
+ (UIImage *)imageWithSex: (NSInteger)sex age:(NSInteger)age;


- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
@end
