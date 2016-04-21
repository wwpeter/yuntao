#import "ViewController.h"
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "CreateHbViewController.h"
#import "AppDelegate.h"
@interface ViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIPageControl* pageControl;
@property (strong, nonatomic) UIButton* loginButton;
@property (strong, nonatomic) UIButton* assLoginButton;
@end

@implementation ViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLoginSucceedNotification:)
                                                 name:kUserLoginSuccessNotification
                                               object:nil];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userLogin:(id)sender
{
    YTLoginViewController* loginVC = [[YTLoginViewController alloc] init];

    if (sender == _assLoginButton) {
        loginVC.loginType = LoginViewTypeAsstanter;
    }
    else {
        loginVC.loginType = LoginViewTypeBusiness;
    }
    YTNavigationController* navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
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
    [self.view addSubview:self.assLoginButton];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:CCImageNamed(@"yt_introImgae_5_1.png")];
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:CCImageNamed(@"yt_introImgae_5_2.png")];
    UIImageView* imageView3 = [[UIImageView alloc] initWithImage:CCImageNamed(@"yt_introImgae_5_3.png")];
    UIImageView* imageView4 = [[UIImageView alloc] initWithImage:CCImageNamed(@"yt_introImgae_5_4.png")];
    if (iPhone4) {
        imageView.image = CCImageNamed(@"yt_introImgae_4_1.png");
        imageView2.image = CCImageNamed(@"yt_introImgae_4_2.png");
        imageView3.image = CCImageNamed(@"yt_introImgae_4_3.png");
        imageView4.image = CCImageNamed(@"yt_introImgae_4_4.png");
    }
    CGRect sRect = self.scrollView.bounds;

    imageView.frame = sRect;
    sRect.origin.x = CGRectGetWidth(sRect);
    imageView2.frame = sRect;
    sRect.origin.x = 2 * CGRectGetWidth(sRect);
    imageView3.frame = sRect;
    sRect.origin.x = 3 * CGRectGetWidth(sRect);
    imageView4.frame = sRect;
    [self.scrollView addSubview:imageView];
    [self.scrollView addSubview:imageView2];
    [self.scrollView addSubview:imageView3];
    [self.scrollView addSubview:imageView4];
}
#pragma mark - Notification Response
- (void)userLoginSucceedNotification:(NSNotification*)notification
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showBusinessDrawerViewController];
}

- (UIScrollView*)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * 4, CGRectGetHeight(self.view.bounds));
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.canCancelContentTouches = YES;
    }
    return _scrollView;
}
- (UIPageControl*)pageControl
{
    if (!_pageControl) {
        CGRect rect = self.view.bounds;
        rect.origin.y = rect.size.height - 40;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = 4;
        _pageControl.currentPage = 0;
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
- (UIButton*)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(15, CGRectGetHeight(self.view.bounds) - 100, (kDeviceWidth - 45) / 2, 40);
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 5;
        _loginButton.backgroundColor = [UIColor whiteColor];
        _loginButton.layer.borderWidth = 1;
        _loginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_loginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"店主登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (UIButton*)assLoginButton
{
    if (!_assLoginButton) {
        _assLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _assLoginButton.frame = CGRectMake((kDeviceWidth - 45) / 2 + 30, CGRectGetHeight(self.view.bounds) - 100, (kDeviceWidth - 45) / 2, 40);
        _assLoginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _assLoginButton.layer.masksToBounds = YES;
        _assLoginButton.layer.cornerRadius = 5;
        _assLoginButton.backgroundColor = [UIColor clearColor];
        _assLoginButton.layer.borderWidth = 1;
        _assLoginButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        [_assLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_assLoginButton setTitle:@"营业员登录" forState:UIControlStateNormal];
        [_assLoginButton addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _assLoginButton;
}
@end
