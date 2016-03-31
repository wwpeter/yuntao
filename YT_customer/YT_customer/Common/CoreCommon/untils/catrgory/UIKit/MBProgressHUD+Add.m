#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    [self show:text icon:icon view:view afterDelay:1.5];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"mb_error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"mb_success.png" view:view];
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // xx秒之后再消失
    [hud hide:YES afterDelay:delay];
}


#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    return [self showMessag:message toView:view yOffset:0];
}
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view yOffset:(float)yOffset{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    hud.yOffset = yOffset;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
+ (void)alertMessage:(NSString*)message autoDisappear:(BOOL)autoDisappear parentView:(UIView *)parentView afterDelay:(NSTimeInterval)delay font:(UIFont *)font mode:(NSInteger)mode animationType:(MBProgressHUDAnimation)animationType
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    hud.animationType = animationType;
    hud.mode = mode;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
	hud.yOffset = 150.f;
    if (font) {
        hud.detailsLabelFont = font;
    }
    else {
         hud.detailsLabelFont = [UIFont systemFontOfSize:16];
    }
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}
+ (void)showLoadingAnimationImages:(NSString *)text  view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
//    hud.labelText = text;
    
//    hud.customView = [[YLImageView alloc]initWithImage:[YLGIFImage imageNamed:@"fishloadinggif@2x.gif"]];
//    hud.customView = [[YLImageView alloc]initWithImage:[YLGIFImage imageNamed:@"fishloadingpng@2x.png"]];
    /********************** UIImageView 动画 **********************************/
    
    //指定ImageView的大小
    UIImageView *loadingAnimation=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 79, 45)];
    
    //添加指定图片
    loadingAnimation.animationImages = @[[UIImage imageNamed:@"dk_loading01.png"],
                                [UIImage imageNamed:@"dk_loading02.png"],
                                [UIImage imageNamed:@"dk_loading03.png"],
                                [UIImage imageNamed:@"dk_loading04.png"],
                                [UIImage imageNamed:@"dk_loading05.png"],
                                [UIImage imageNamed:@"dk_loading06.png"],
                                [UIImage imageNamed:@"dk_loading07.png"],
                                [UIImage imageNamed:@"dk_loading08.png"],
                                [UIImage imageNamed:@"dk_loading09.png"],
                                [UIImage imageNamed:@"dk_loading10.png"],
                                [UIImage imageNamed:@"dk_loading11.png"]
                                ];
    
    
    //设定一轮播放时间
    loadingAnimation.animationDuration=2.0;
    
    //设置播放次数,0 不断重复
    loadingAnimation.animationRepeatCount=0;
    
    //开始播放动画
    [loadingAnimation startAnimating];
    
    hud.customView = loadingAnimation;
     /********************** UIImageView 动画 **********************************/

    hud.mode = MBProgressHUDModeCustomView;
    
    hud.color = [UIColor clearColor];
}
+ (void)showLittleLoadingAnimationImages:(NSString *)text  view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.labelColor = [UIColor blackColor];
    hud.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    hud.square = YES;

    UIImageView *loadingAnimation=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 73, 53)];
    loadingAnimation.animationImages = @[[UIImage imageNamed:@"dk_little_loading01.png"],
                                         [UIImage imageNamed:@"dk_little_loading02.png"],
                                         [UIImage imageNamed:@"dk_little_loading03.png"],
                                         [UIImage imageNamed:@"dk_little_loading04.png"],
                                         [UIImage imageNamed:@"dk_little_loading05.png"],
                                         [UIImage imageNamed:@"dk_little_loading06.png"],
                                         [UIImage imageNamed:@"dk_little_loading07.png"],
                                         [UIImage imageNamed:@"dk_little_loading08.png"],
                                         [UIImage imageNamed:@"dk_little_loading09.png"],
                                         [UIImage imageNamed:@"dk_little_loading10.png"],
                                         [UIImage imageNamed:@"dk_little_loading11.png"]
                                         ];
    loadingAnimation.animationDuration=2.0;
    loadingAnimation.animationRepeatCount=0;
    [loadingAnimation startAnimating];
    
    hud.customView = loadingAnimation;
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = CCCUIColorFromHex(0xf5f5f5);
    
}

+ (void)alertRedMessage:(NSString *)text view:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.color = CCCUIColorFromHex(0xF8425A);
    hud.cornerRadius = 3;
    hud.margin = 10;
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.detailsLabelText = text;
//    hud.yOffset = 160.f;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}
@end
