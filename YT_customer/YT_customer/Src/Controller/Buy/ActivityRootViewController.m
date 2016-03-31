#import "ActivityRootViewController.h"
#import "UIViewController+Helper.h"
#import "SVPullToRefresh.h"
#import "YTActivityModel.h"
#import "OutWebViewController.h"
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "UserMationMange.h"
#import "ActivityRootTableCell.h"
#import "MBProgressHUD+Add.h"
#import "YTNetworkMange.h"
#import "UserLoginHeloper.h"

static NSString* CellIdentifier = @"ActivityRootCellIdentifier";

@interface ActivityRootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, copy) NSArray* dataArr;
@property (nonatomic, assign) BOOL didUploadLocation;
@end

@implementation ActivityRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializePageSubviews];
    [self.tableView triggerPullToRefresh];
}

#pragma mark -fetchDataWithIsLoadingMore
- (void)uploadUserLocation
{
    __weak typeof(self) weakSelf = self;
    [[UserMationMange sharedInstance] uploadUserLocationBlock:^(CLLocation* currentLocation, INTULocationStatus status) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.didUploadLocation) {
            return;
        }
        [strongSelf fetchDataWithIsLoadingMore:NO currentLocation:currentLocation];
        strongSelf.didUploadLocation = YES;
    }];
}
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    if (currentLocation.coordinate.latitude != 0) {
        [self fetchDataWithIsLoadingMore:isLoadingMore currentLocation:currentLocation];
    }
    else {
        self.didUploadLocation = NO;
        [self uploadUserLocation];
    }
}
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore currentLocation:(CLLocation*)currentLocation
{
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.requestParas = @{ @"lat" : latitude,
        @"lon" : longitude };
    self.requestURL = YC_Request_Activity;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel *)parserObject
              errorMessage:(NSString*)errorMessage {
    if (!request.isLoadingMore) {
        [self.tableView.pullToRefreshView stopAnimating];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    } if (errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
        return;
    } if (parserObject.success) {
        YTActivityModel *activityModel = (YTActivityModel *)parserObject;
        _dataArr = [[NSArray alloc] initWithArray:activityModel.activites];
        self.tableView.showsInfiniteScrolling = NO;

        [self.tableView reloadData];
    } else {
    }
}

#pragma mark -tableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return _dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    ActivityRootTableCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_dataArr.count > indexPath.section) {
        YTActivity *activity = _dataArr[indexPath.section];
        [cell configCellWithActivity:activity];
    }
    return cell;
}

#pragma mark -cell选择的点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTActivity *activity = _dataArr[indexPath.section];
    if ([UserLoginHeloper sharedMange].realyLogin) {
        [self toWebView:activity.url];
    }
    else {
        __weak typeof(self) weakSelf = self;
        [self checkUserDidRealyLoginSuccess:^(BOOL isLogin) {
            if (isLogin) {
                [weakSelf toWebView:activity.url];
            }
        } failure:NULL];
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

- (void)checkUserDidRealyLoginSuccess:(void (^)(BOOL isLogin))success
                              failure:(void (^)(NSString* errorMessage))failure
{
    NSDictionary* parameters = @{};
    __weak typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UserIsLogin
        parameters:parameters
        success:^(id responseData) {
            BOOL isLogin = [responseData[@"data"] boolValue];
            [UserLoginHeloper sharedMange].realyLogin = isLogin;
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!isLogin) {
                [strongSelf userLogin];
            }
            if (success) {
                success(isLogin);
            }
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD showMessag:errorMessage toView:self.view];
        }];
}

#pragma mark - Page subviews
- (void)initializePageSubviews {
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
}

#pragma mark - Getters & Setters
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.rowHeight = 200;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [_tableView registerClass:[ActivityRootTableCell class] forCellReuseIdentifier:CellIdentifier];
        __weak __typeof(self) weakSelf = self;
        [_tableView addPullToRefreshWithActionHandler:^{
            [weakSelf fetchDataWithIsLoadingMore:NO];
        }];
        _tableView.showsInfiniteScrolling = NO;
    }
    return _tableView;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
