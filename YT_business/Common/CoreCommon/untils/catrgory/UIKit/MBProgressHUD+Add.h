#import "MBProgressHUD.h"

static NSString *const kYTWaitingMessage  = @"请稍后...";

@interface MBProgressHUD (Add)
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)alertMessage:(NSString*)message autoDisappear:(BOOL)autoDisappear parentView:(UIView *)parentView afterDelay:(NSTimeInterval)delay font:(UIFont *)font mode:(NSInteger)mode animationType:(MBProgressHUDAnimation)animationType;
+ (void)alertRedMessage:(NSString *)text view:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view yOffset:(float)yOffset;

//+ (void)showLoadingAnimationImages:(NSString *)text  view:(UIView *)view;
//+ (void)showLittleLoadingAnimationImages:(NSString *)text  view:(UIView *)view;
@end
