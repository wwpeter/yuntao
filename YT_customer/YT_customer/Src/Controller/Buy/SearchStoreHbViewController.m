#import "SearchStoreHbViewController.h"
#import "UIViewController+Helper.h"
#import "CStoreTableCell.h"
#import "CStoreIntroModel.h"
#import "CSearchTextView.h"
#import "SVPullToRefresh.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"
#import "UserMationMange.h"
#import "StoryBoardUtilities.h"
#import "UIViewController+ShopDetail.h"
#import "ShopDetailModel.h"
#import "EmptyDataEffect.h"

static NSString *CellIdentifier = @"SearchStoreHbCellIdentifier";

@interface SearchStoreHbViewController ()<CSearchTextViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) CSearchTextView *searchView;
@property (strong, nonatomic) NSMutableDictionary *mutableParameters;
@property (assign, nonatomic) BOOL didKeyboardShow;
@property (assign, nonatomic) BOOL noLocation;
@end

@implementation SearchStoreHbViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"商户";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    self.didKeyboardShow = NO;
    [self initializeData];
    self.tableView.rowHeight = 86;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.tableView registerClass:[CStoreTableCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.tableHeaderView = self.searchView;
    [self setExtraCellLineHidden:self.tableView];
    // 解决 iOS8中分割线不能置顶
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    if(currentLocation.coordinate.latitude != 0){
       [self.tableView triggerPullToRefresh];
    }else{
        self.noLocation = YES;
        [self showTableRefres:NO];
    }
}
- (void)showTableRefres:(BOOL)flag
{
    self.tableView.showsPullToRefresh = flag;
    self.tableView.showsInfiniteScrolling = flag;
    if (flag) {
        [self.tableView triggerPullToRefresh];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup data
- (void)insertRowAtTop
{
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.mutableParameters[@"lon"] = longitude;
    self.mutableParameters[@"lat"] = latitude;
    self.mutableParameters[@"pageNum"] = @(1);
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_QueryShop parameters:self.mutableParameters success:^(id responseData) {
        id object = responseData[@"data"][@"records"];
        [weakSelf pullToRefreshViewWithObject:object];
    } failure:^(NSString *errorMessage) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)insertRowAtBottom
{
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.mutableParameters[@"lon"] = longitude;
    self.mutableParameters[@"lat"] = latitude;
    self.mutableParameters[@"pageNum"] = @(_page);
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_QueryShop parameters:self.mutableParameters success:^(id responseData) {
        id object = responseData[@"data"][@"records"];
        [weakSelf loadMoreViewWithObject:object];
        
    } failure:^(NSString *errorMessage) {
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}

- (void)pullToRefreshViewWithObject:(id)object
{
    [self.dataArray removeAllObjects];
    self.page = 2;
    for (NSDictionary *dic in object) {
        CStoreIntroModel *hiModel = [[CStoreIntroModel alloc] initWithStoreIntroDictionary:dic];
        [self.dataArray addObject:hiModel];
    }
    [self.tableView reloadData];
    [self.tableView.infiniteScrollingView beginScrollAnimating];
    [self.tableView.pullToRefreshView stopAnimating];
}
- (void)loadMoreViewWithObject:(id)object
{
    if ([object count] == 0) {
        [self.tableView.infiniteScrollingView endScrollAnimating];
    } else{
        self.page ++;
        for (NSDictionary *dic in object) {
            CStoreIntroModel *hiModel = [[CStoreIntroModel alloc] initWithStoreIntroDictionary:dic];
            [self.dataArray addObject:hiModel];
        }
        [self.tableView reloadData];
    }
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CStoreTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CStoreIntroModel *introModel = _dataArray[indexPath.row];
    [cell configStoreCellWithModel:introModel];
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didKeyboardShow) {
        [self.searchView.searchField resignFirstResponder];
    }else{
        CStoreIntroModel *model = _dataArray[indexPath.row];
        [self showShopDetailWithShopId:model.storeId isPromotion:model.isPromotion];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchView endEditing:YES];
}
#pragma mark - CSearchTextViewDelegate
- (void)searchTextView:(CSearchTextView *)view textFieldDidBeginEditing:(UITextField *)textField
{
    self.didKeyboardShow = YES;
}
- (void)searchTextView:(CSearchTextView *)view textFieldShouldEndEditing:(UITextField *)textField
{
    self.didKeyboardShow = NO;
}
- (void)searchTextView:(CSearchTextView *)view textFieldShouldReturn:(UITextField *)textField
{
    self.mutableParameters[@"kw"] = textField.text;
    [self.tableView triggerPullToRefresh];
    [textField resignFirstResponder];
}
#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString*)titleForEmptyDataSet:(UIScrollView*)scrollView
{
    return [EmptyDataEffect titleForEmptyDataEffectType:EmptyDataEffectTypeLocationError];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [EmptyDataEffect imageForEmptyDataEffectType:EmptyDataEffectTypeLocationError];
}
- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [EmptyDataEffect buttonTitleForEmptyDataEffectType:EmptyDataEffectTypeLocationError];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [EmptyDataEffect buttonBackgroundImageForState:state effectType:EmptyDataEffectTypeLocationError];
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 20;
}
- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    __weak __typeof(self)weakSelf = self;
    [[UserMationMange sharedInstance] uploadUserLocationBlock:^(CLLocation* currentLocation,INTULocationStatus status) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:strongSelf.view animated:YES];
        if (status == INTULocationStatusSuccess) {
            [strongSelf showTableRefres:YES];
            strongSelf.noLocation = NO;
        }
    }];
}
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    [self.searchView.searchField resignFirstResponder];
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView*)scrollView
{
    return _noLocation;
}
//- (CGPoint)offsetForEmptyDataSet:(UIScrollView*)scrollView
//{
//    return CGPointMake(0, CGRectGetHeight(self.tableView.bounds)/2);
//}
#pragma mark - Page subviews
- (void)initializeData
{
    self.page = 1;
    self.mutableParameters = [[NSMutableDictionary alloc] init];
    self.mutableParameters[@"pageNum"] = @(_page);
    self.mutableParameters[@"zoneId"] = @0;
    self.mutableParameters[@"pcatId"] = @0;
    self.mutableParameters[@"catId"] = @0;
    self.mutableParameters[@"orderby"] = @"disnear";
    self.mutableParameters[@"radius"] = @5000;
    self.mutableParameters[@"kw"] = @"";
}

#pragma mark - Getters & Setters
- (CSearchTextView *)searchView
{
    if (!_searchView) {
        _searchView = [[CSearchTextView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
        _searchView.delegate = self;
    }
    return _searchView;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
