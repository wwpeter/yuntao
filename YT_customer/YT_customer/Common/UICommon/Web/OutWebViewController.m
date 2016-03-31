#import "OutWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "YCApi.h"
#import <UIWebView+AFNetworking.h>
#import "YTNetworkMange.h"
#import "UIBarButtonItem+Addition.h"

@interface OutWebViewController () <NJKWebViewProgressDelegate>
@property (strong, nonatomic) NJKWebViewProgressView* progressView;
@property (strong, nonatomic) NJKWebViewProgress* progressProxy;
@property (strong, nonatomic) UIBarButtonItem* backButtonItem;
@property (strong, nonatomic) UIBarButtonItem* closedButtonItem;
@end

@implementation OutWebViewController
- (instancetype)initWithURL:(NSString*)urlStr title:(NSString*)title isShowRight:(BOOL)showRight
{
    self = [super init];
    if (self) {
        self.urlStr = urlStr;
        self.navigationItem.title = title;
        self.showRight = showRight;
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _webView.delegate = nil;
    [_webView removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* bnorImage = [UIImage imageNamed:@"yt_navigation_backBtn_normal.png"];
    UIImage* bhiglImage = [UIImage imageNamed:@"yt_navigation_backBtn_high.png"];
    UIImage* cnorImage = [UIImage imageNamed:@"yt_navigation_closed_normal.png"];
    UIImage* chiglImage = [UIImage imageNamed:@"yt_navigation_closed_high.png"];

    self.backButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:bnorImage highlightImage:bhiglImage target:self action:@selector(didBackBarButtonItemAction:)];
    self.closedButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:cnorImage highlightImage:chiglImage target:self action:@selector(didClosedBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = self.backButtonItem;
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;

    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_urlStr]];
    NSData* cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:iYCUsercookiesKey];
    if ([cookiesdata length]) {
        NSArray* cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSDictionary* headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [req setAllHTTPHeaderFields:headers];
    }
    [_webView loadRequest:req];
//    [_webView loadRequest:req progress:NULL success:NULL failure:NULL];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [YCApi setupCookies];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.view endEditing:YES];
    //   [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [_progressView removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didBackBarButtonItemAction:(id)sender
{
    if (_webView.canGoBack) {
        [_webView goBack];
        if (self.navigationItem.leftBarButtonItems.count < 2) {
            self.navigationItem.leftBarButtonItems = @[ self.backButtonItem, self.closedButtonItem ];
        }
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didClosedBarButtonItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - NJKWebViewProgress Delegate
- (void)webViewProgress:(NJKWebViewProgress*)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    [YCApi saveCookiesWithUrl:request.URL];
    return YES;
}

@end
