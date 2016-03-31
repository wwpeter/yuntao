#import "YTLoginRootViewController.h"
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "AppDelegate.h"
#import "UIImage+HBClass.h"

@interface YTLoginRootViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *strollButton;
@end

@implementation YTLoginRootViewController

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginSucceedNotification:)
                                                 name:kUserLoginSuccessNotification
                                               object:nil];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loginButtonClicked:(id)sender
{
    YTLoginViewController *loginVC = [[YTLoginViewController alloc] init];
    loginVC.loginType = LoginViewTypePhone;
    YTNavigationController *navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}
- (void)strollButtonClicked:(id)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate showUserTabBarViewController];
}
#pragma mark - Notification Response
- (void)userLoginSucceedNotification:(NSNotification*)notification
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate showUserTabBarViewController];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.strollButton];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:CCImageNamed(@"yc_introimage_5_1.png")];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:CCImageNamed(@"yc_introimage_5_2.png")];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:CCImageNamed(@"yc_introimage_5_3.png")];
    if (iPhone4) {
        imageView.image = CCImageNamed(@"yc_introimage_4_1.png");
        imageView2.image = CCImageNamed(@"yc_introimage_4_2.png");
        imageView3.image = CCImageNamed(@"yc_introimage_4_3.png");

    }
    CGRect sRect = self.scrollView.bounds;
    
    imageView.frame = sRect;
    sRect.origin.x = CGRectGetWidth(sRect);
    imageView2.frame = sRect;
    sRect.origin.x = 2*CGRectGetWidth(sRect);
    imageView3.frame = sRect;
    [self.scrollView addSubview:imageView];
    [self.scrollView addSubview:imageView2];
    [self.scrollView addSubview:imageView3];
}

#pragma mark - Getters & Setters
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds)*3, CGRectGetHeight(self.view.bounds));
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.canCancelContentTouches = YES;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        CGRect rect = self.view.bounds;
        rect.origin.y = rect.size.height - 40;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = YTDefaultRedColor;
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(15, CGRectGetHeight(self.view.bounds)-85, (kDeviceWidth-45)/2, 40);
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 5;
        [_loginButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (UIButton *)strollButton
{
    if (!_strollButton) {
        _strollButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _strollButton.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-15-(kDeviceWidth-45)/2, CGRectGetHeight(self.view.bounds)-85, (kDeviceWidth-45)/2, 40);
        _strollButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _strollButton.layer.masksToBounds = YES;
        _strollButton.layer.cornerRadius = 5;
        _strollButton.layer.borderWidth = 1;
        _strollButton.layer.borderColor = [YTDefaultRedColor CGColor];
        [_strollButton setBackgroundImage:[UIImage createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_strollButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithWhite:0.8 alpha:0.8]] forState:UIControlStateHighlighted];
        [_strollButton setTitleColor:YTDefaultRedColor forState:UIControlStateNormal];
        [_strollButton setTitle:@"随便逛逛" forState:UIControlStateNormal];
        [_strollButton addTarget:self action:@selector(strollButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _strollButton;

}
@end
