#import "BuyRootViewController.h"
#import "StoryBoardUtilities.h"
#import "SearchStoreHbViewController.h"
#import "QRCodeReaderViewController.h"
#import "OutWebViewController.h"
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "UserMationMange.h"
#import "ScanCodeHelper.h"
#import "UIViewController+Helper.h"
#import "UIAlertView+TTBlock.h"
#import "PayViewController.h"
#import "PayCodeViewController.h"
#import "YTCycleScrollView.h"
#import "MBProgressHUD+Add.h"
#import "YTActivityModel.h"
#import "UserLoginHeloper.h"
#import "UIViewController+ShopDetail.h"

@interface BuyRootViewController () <QRCodeReaderDelegate>

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) YTCycleScrollView* cycleScrollView;
@property (strong, nonatomic) UIButton* scanButton;
@property (strong, nonatomic) UIButton* payButton;
@property (strong, nonatomic) UIButton* codePayButton;
@property (strong, nonatomic) QRCodeReaderViewController* readerVC;
@property (assign, nonatomic) BOOL didUploadLocation;
@end

@implementation BuyRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self uploadUserLocation];
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.cycleScrollView timerStart];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cycleScrollView timerPause];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)handleRefresh:(id)sender
{
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    if (currentLocation.coordinate.latitude != 0) {
        [self fetchData:currentLocation];
    }else {
        self.didUploadLocation = NO;
        [self uploadUserLocation];
    }
}
- (void)uploadUserLocation
{
    __weak __typeof(self)weakSelf = self;
    [[UserMationMange sharedInstance] uploadUserLocationBlock:^(CLLocation* currentLocation,INTULocationStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.didUploadLocation) {
            return ;
        }
        [strongSelf fetchData:currentLocation];
        strongSelf.didUploadLocation = YES;
    }];
}
- (void)fetchData:(CLLocation *)currentLocation
{
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.requestParas = @{@"lat" : latitude,
                          @"lon" : longitude};
    self.requestURL = YC_Request_Activity;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel *)request result:(YTBaseModel *)parserObject
              errorMessage:(NSString *)errorMessage
{
     [self.refreshControl endRefreshing];
    if (parserObject.success) {
        YTActivityModel *activityModel = (YTActivityModel *)parserObject;
        self.cycleScrollView.imageURLsGroup = activityModel.activites;
        __weak __typeof(self)weakSelf = self;
        self.cycleScrollView.selectBlock = ^(NSInteger index){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
                YTActivity *activity = activityModel.activites[index];
            if ([UserLoginHeloper sharedMange].realyLogin) {
                [strongSelf toWebView:activity.url];
            }
            else {
                [strongSelf checkUserDidRealyLoginSuccess:^(BOOL isLogin) {
                    if (isLogin) {
                        [strongSelf toWebView:activity.url];
                    }
                } failure:NULL];
            }
        };
    }else{
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}
#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController*)reader didScanResult:(NSString*)result
{
    
}
#pragma mark - Event response
- (void)scanButtonClicked:(id)sender
{
    if ([[UserMationMange sharedInstance] userLogin]) {
        _readerVC = [[QRCodeReaderViewController alloc] init];
        _readerVC.modalPresentationStyle = UIModalPresentationFormSheet;
        _readerVC.hidesBottomBarWhenPushed = YES;
        _readerVC.navigationItem.title = @"扫一扫";
        _readerVC.delegate = self;
        __weak typeof(self) weakSelf = self;
        [_readerVC setCompletionWithBlock:^(NSString* resultAsString) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf setupScanResultString:resultAsString formViewController:strongSelf.readerVC];
        }];
        [self.navigationController pushViewController:_readerVC animated:YES];
    }
    else {
        [self userLogin];
    }
}
- (void)payButtonClicked:(id)sender
{
    if ([[UserMationMange sharedInstance] userLogin]) {
        SearchStoreHbViewController* searchStoreVC = [[SearchStoreHbViewController alloc] initWithStyle:UITableViewStylePlain];
        searchStoreVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchStoreVC animated:YES];
    }
    else {
        [self userLogin];
    }
}
- (void)codePayButtonClicked:(id)sender
{
    if ([[UserMationMange sharedInstance] userLogin]) {
        PayCodeViewController *payCodeVC = [[PayCodeViewController alloc] init];
        payCodeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payCodeVC animated:YES];
    }
    else {
        [self userLogin];
    }
}
#pragma mark - Private methods
- (void)toWebView:(NSString *)urlStr
{
    OutWebViewController* webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
    webVC.urlStr = urlStr;
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)setupScanResultString:(NSString*)string formViewController:(UIViewController *)formViewController
{
    ScanCodeHelper* scanCode = [[ScanCodeHelper alloc] initWithResultUrlString:string];
    if (!scanCode.isYtCode) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"此二维码未经官方认证" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        __weak typeof(self) weakSelf = self;
        [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (buttonIndex == 0) {
                [strongSelf.readerVC startScanning];
            }
        }];
        [alert show];
        return;
    }
    if (scanCode.openType == ScanCodeOpenTypeH5) {
        OutWebViewController* webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
        webVC.urlStr = string;
        [formViewController.navigationController pushViewController:webVC animated:YES];
    }
    else {
        PayViewController *payVC = [[PayViewController alloc] init];
        payVC.shopId = scanCode.shopId;
        payVC.mayChange = YES;
        [formViewController.navigationController pushViewController:payVC animated:YES];
    }
}
#pragma mark - Navigation

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.view.backgroundColor = CCCUIColorFromHex(0xeef8ff);
    [self.view addSubview:self.scrollView];
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UIView* contentView = [[UIView alloc] init];
    [self.scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    [contentView addSubview:self.cycleScrollView];
    [contentView addSubview:self.scanButton];
    [contentView addSubview:self.payButton];
    [contentView addSubview:self.codePayButton];

    CGFloat multiple = 15 * iPhoneMultiple;
    CGFloat topHeight = (iPhone4 || iPhone5)? 220 : 260;
    [_codePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topHeight);
        make.left.mas_equalTo(multiple);
        make.right.mas_equalTo(-multiple);
        make.height.mas_equalTo(49);
    }];
    [_payButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.and.height.mas_equalTo(_codePayButton);
        make.top.mas_equalTo(_codePayButton.bottom).offset(18);
    }];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.height.mas_equalTo(_codePayButton);
        make.top.mas_equalTo(_payButton.bottom).offset(18);
    }];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_scanButton.bottom).offset(64);
    }];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:self.refreshControl];
}
#pragma mark - Getters & Setters
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (YTCycleScrollView*)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [YTCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kDeviceWidth, 200) imageURLsGroup:nil];
    }
    return _cycleScrollView;
}
- (UIButton*)scanButton
{
    if (!_scanButton) {
        UIImage* normalImage = [[UIImage imageNamed:@"yt_buy_redlineButton_normal.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        UIImage* highImage = [[UIImage imageNamed:@"yt_buy_redlineButton_high.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _scanButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _scanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_scanButton setTitleColor:YTDefaultRedColor forState:UIControlStateNormal];
        [_scanButton setTitle:@"扫一扫买单" forState:UIControlStateNormal];
        [_scanButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_scanButton setBackgroundImage:highImage forState:UIControlStateHighlighted];
        [_scanButton setImage:[UIImage imageNamed:@"yt_scan_button_icon_red.png"] forState:UIControlStateNormal];
        [_scanButton setImage:[UIImage imageNamed:@"yt_scan_button_icon_red.png"] forState:UIControlStateHighlighted];
        [_scanButton addTarget:self action:@selector(scanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}
- (UIButton*)payButton
{
    if (!_payButton) {
        UIImage* normalImage = [[UIImage imageNamed:@"yt_buy_redlineButton_normal.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        UIImage* highImage = [[UIImage imageNamed:@"yt_buy_redlineButton_high.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _payButton.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
        _payButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_payButton setTitleColor:YTDefaultRedColor forState:UIControlStateNormal];
        [_payButton setTitle:@"快捷买单" forState:UIControlStateNormal];
        [_payButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_payButton setBackgroundImage:highImage forState:UIControlStateHighlighted];
        [_payButton setImage:[UIImage imageNamed:@"yt_ lightning_button_icon.png"] forState:UIControlStateNormal];
        [_payButton setImage:[UIImage imageNamed:@"yt_ lightning_button_icon.png"] forState:UIControlStateHighlighted];
        [_payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}
- (UIButton *)codePayButton
{
    if (!_codePayButton) {
        UIImage* normalImage = [[UIImage imageNamed:@"yt_buy_redButton_normal.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        UIImage* highImage = [[UIImage imageNamed:@"yt_buy_redButton_high.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        _codePayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codePayButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _codePayButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _codePayButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _codePayButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_codePayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codePayButton setTitle:@"二维码买单" forState:UIControlStateNormal];
        [_codePayButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_codePayButton setBackgroundImage:highImage forState:UIControlStateHighlighted];
        [_codePayButton setImage:[UIImage imageNamed:@"yt_code_button_icon_white.png"] forState:UIControlStateNormal];
        [_codePayButton setImage:[UIImage imageNamed:@"yt_code_button_icon_white.png"] forState:UIControlStateHighlighted];
        [_codePayButton addTarget:self action:@selector(codePayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codePayButton;
}
@end
