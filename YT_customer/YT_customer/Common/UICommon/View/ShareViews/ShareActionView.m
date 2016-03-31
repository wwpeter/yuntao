#import "ShareActionView.h"
#import "SGGridMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "NSStrUtil.h"

@implementation ShareDataModel
- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"云淘红包";
        self.imgUrl = @"";
        self.url = @"http://hongbao.yuntaohongbao.com/download/user.html";
        self.shareText = @"";
    }
    return self;
}
- (instancetype)initWithTitle:(NSString*)title
                          url:(NSString*)url
                     imageUrl:(NSString*)imageUrl
                    shareText:(NSString*)sharetext
{
    self = [super init];
    if (self) {
        _title = title;
        _imgUrl = imageUrl;
        _url = url;
        _shareText = sharetext;
    }
    return self;
}
@end

@interface ShareActionView() <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;
// 点击背景取消
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation ShareActionView

+ (ShareActionView *)sharedActionView
{
    static ShareActionView *actionView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGRect rect = [[UIScreen mainScreen] bounds];
        actionView = [[ShareActionView alloc] initWithFrame:rect];
    });
    
    return actionView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menus = [NSMutableArray array];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)dealloc{
    [self removeGestureRecognizer:_tapGesture];
}
- (void)tapAction:(UITapGestureRecognizer *)tapGesture{
    CGPoint touchPoint = [tapGesture locationInView:self];
    //    if (self.menus.count > 1) {
    //        SGBaseMenu *menu = self.menus.lastObject;
    //        if (!CGRectContainsPoint(menu.frame, touchPoint)) {
    //            [menu removeFromSuperview];
    //            [self.menus removeLastObject];
    //        }
    //    }else{
    SGBaseMenu *menu = self.menus.lastObject;
    if (!CGRectContainsPoint(menu.frame, touchPoint)) {
        [[ShareActionView sharedActionView] dismissMenu:menu Animated:YES];
        [self.menus removeObject:menu];
    }
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isEqual:self.tapGesture]) {
        CGPoint p = [gestureRecognizer locationInView:self];
        SGBaseMenu *topMenu = self.menus.lastObject;
        if (CGRectContainsPoint(topMenu.frame, p)) {
            return NO;
        }
    }
    return YES;
}
#pragma mark -

- (void)setMenu:(UIView *)menu animation:(BOOL)animated{
    if (![self superview]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:self];
    }
    
    SGBaseMenu *topMenu = (SGBaseMenu *)menu;
    
    [self.menus makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.menus addObject:topMenu];
    [self addSubview:topMenu];
    [topMenu layoutIfNeeded];
    topMenu.frame = (CGRect){CGPointMake(0, self.bounds.size.height - topMenu.bounds.size.height), topMenu.bounds.size};
    
    if (animated && self.menus.count == 1) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.layer addAnimation:self.dimingAnimation forKey:@"diming"];
        [topMenu.layer addAnimation:self.showMenuAnimation forKey:@"showMenu"];
        [CATransaction commit];
    }
}

- (void)dismissMenu:(SGBaseMenu *)menu Animated:(BOOL)animated
{
    if ([self superview]) {
        [self.menus removeObject:menu];
        if (animated && self.menus.count == 0) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.2];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setCompletionBlock:^{
                [self removeFromSuperview];
                [menu removeFromSuperview];
            }];
            [self.layer addAnimation:self.lightingAnimation forKey:@"lighting"];
            [menu.layer addAnimation:self.dismissMenuAnimation forKey:@"dismissMenu"];
            [CATransaction commit];
        }else{
            [menu removeFromSuperview];
            
            SGBaseMenu *topMenu = self.menus.lastObject;
            [self addSubview:topMenu];
            [topMenu layoutIfNeeded];
            topMenu.frame = (CGRect){CGPointMake(0, self.bounds.size.height - topMenu.bounds.size.height), topMenu.bounds.size};
        }
    }
}

#pragma mark - Animation

- (CAAnimation *)dimingAnimation
{
    if (_dimingAnimation == nil) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _dimingAnimation = opacityAnimation;
    }
    return _dimingAnimation;
}

- (CAAnimation *)lightingAnimation
{
    if (_lightingAnimation == nil ) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        opacityAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        opacityAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [opacityAnimation setRemovedOnCompletion:NO];
        [opacityAnimation setFillMode:kCAFillModeBoth];
        _lightingAnimation = opacityAnimation;
    }
    return _lightingAnimation;
}

- (CAAnimation *)showMenuAnimation
{
    if (_showMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        CATransform3D to = CATransform3DIdentity;
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@0.9];
        [scaleAnimation setToValue:@1.0];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:50.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _showMenuAnimation = group;
    }
    return _showMenuAnimation;
}

- (CAAnimation *)dismissMenuAnimation
{
    if (_dismissMenuAnimation == nil) {
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D t = CATransform3DIdentity;
        t.m34 = 1 / -500.0f;
        CATransform3D from = CATransform3DIdentity;
        CATransform3D to = CATransform3DRotate(t, -30.0f * M_PI / 180.0f, 1, 0, 0);
        [rotateAnimation setFromValue:[NSValue valueWithCATransform3D:from]];
        [rotateAnimation setToValue:[NSValue valueWithCATransform3D:to]];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [scaleAnimation setFromValue:@1.0];
        [scaleAnimation setToValue:@0.9];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:50.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:@[rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeBoth];
        _dismissMenuAnimation = group;
    }
    return _dismissMenuAnimation;
}


#pragma mark -
+ (void)showGridMenuWithTitle:(NSString *)title
                   itemTitles:(NSArray *)itemTitles
                       images:(NSArray *)images
               selectedHandle:(SGMenuActionHandler)handler
{
    SGGridMenu *menu = [[SGGridMenu alloc] initWithTitle:title
                                              itemTitles:itemTitles
                                                  images:images];
    [menu triggerSelectedAction:^(NSInteger index){
        [[ShareActionView sharedActionView] dismissMenu:menu Animated:YES];
        if (handler) {
            handler(index,title);
        }
    }];
    [[ShareActionView sharedActionView] setMenu:menu animation:YES];
}

+ (void)showShareMenuWithSheetView:(UIViewController *)controller
                             title:(NSString *)title
                         shareData:(ShareDataModel *)shareData
                    selectedHandle:(SGMenuActionHandler)handler
{
    NSMutableArray *shareTitles = [[NSMutableArray alloc] initWithCapacity:6];
    NSMutableArray *shareNames = [[NSMutableArray alloc] initWithCapacity:6];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:6];
    if ([WXApi isWXAppInstalled]) {
//        [shareTitles addObject:@"微信朋友圈"];
        [shareTitles addObject:@"微信好友"];
//        [shareNames addObject:UMShareToWechatTimeline];
        [shareNames addObject:UMShareToWechatSession];
//        [images addObject:[UIImage imageNamed:@"shareicon_01.png"]];
        [images addObject:[UIImage imageNamed:@"shareicon_02.png"]];
    }

    if ([QQApiInterface isQQInstalled]) {
        [shareTitles addObject:@"QQ"];
//        [shareTitles addObject:@"QQ空间"];
        [shareNames addObject:UMShareToQQ];
//        [shareNames addObject:UMShareToQzone];
        [images addObject:[UIImage imageNamed:@"shareicon_04.png"]];
//        [images addObject:[UIImage imageNamed:@"shareicon_05.png"]];
    }
    [shareTitles addObject:@"短信"];
    [shareNames addObject:UMShareToSms];
    [images addObject:[UIImage imageNamed:@"shareicon_06.png"]];
    
    SGGridMenu *menu = [[SGGridMenu alloc] initWithTitle:title
                                              itemTitles:shareTitles
                                                  images:images];
    [menu triggerSelectedAction:^(NSInteger index){
        [[ShareActionView sharedActionView] dismissMenu:menu Animated:YES];
        if (index > 0) {
            [[ShareActionView sharedActionView] shareWithFormView:controller shareData:shareData plantNameIndex:shareNames[index-1]];
            if (handler) {
                handler(index,shareNames[index-1]);
            }
        }
    }];
    [[ShareActionView sharedActionView] setMenu:menu animation:YES];
}

#pragma mark - 分享
- (void)shareWithFormView:(UIViewController *)controller shareData:(ShareDataModel *)shareData plantNameIndex:(NSString *)platformName
{
    NSString *imgStr = shareData.imgUrl;
    if ([NSStrUtil isEmptyOrNull:imgStr]) {
        imgStr = @"http://res.yuntaohongbao.com/8F41D6CF4A79CE5E4CB7CEC2B2C111FF.png";
    }
    NSString *url = shareData.url;
    NSString *title = shareData.title;
    NSString *shareText = @"";
    NSString *desc = shareData.shareText;
    if (desc.length > 50) {
        shareText  = [desc substringToIndex:50];
        [shareText stringByAppendingString:@"..."];
    }
    else {
        shareText = desc;
    }
    if ([platformName isEqualToString:UMShareToSms]) {
        [self sendMessageView:[NSString stringWithFormat:@"%@ \n %@", title, url] formView:controller];
    } else {
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imgStr];
    UMSocialExtConfig* extConfig = [UMSocialData defaultData].extConfig;
    extConfig.title = title;
    extConfig.sinaData.shareText = extConfig.tencentData.shareText = extConfig.smsData.shareText = [NSString stringWithFormat:@"%@%@", shareText, url];
    extConfig.wechatSessionData.url = extConfig.wechatTimelineData.url = extConfig.qqData.url = extConfig.qzoneData.url = url;
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:nil socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName].snsClickHandler(controller, [UMSocialControllerService defaultControllerService], YES);
    }
}
#pragma mark - 信息委托
- (void)sendMessageView:(NSString*)content formView:(UIViewController *)formController
{
    if ([MFMessageComposeViewController canSendText]) {
        
        [[UINavigationBar appearanceWhenContainedIn:[MFMessageComposeViewController class], nil] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        MFMessageComposeViewController* controller = [[MFMessageComposeViewController alloc] init];
        //     controller.recipients = @[sendNumber];
        controller.body = content;
        controller.messageComposeDelegate = self;
        
        [formController presentViewController:controller animated:YES completion:nil];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不能发送短信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [controller dismissViewControllerAnimated:NO completion:nil]; //关键的一句   不能为YES
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
