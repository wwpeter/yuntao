#import "CSearchStoreResultViewController.h"
#import "UIViewController+Helper.h"
#import "CStoreTableCell.h"
#import "CStoreIntroModel.h"
#import "SVPullToRefresh.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"
#import "UserMationMange.h"
#import "StoryBoardUtilities.h"
#import "ShopDetailModel.h"
#import "EmptyDataEffect.h"
#import "ShopDetailViewController.h"
#import "YTResultHbModel.h"
#import "HBRootTableCell.h"
#import "CSearchHbDetailViewController.h"
#import "UIViewController+ShopDetail.h"

static NSString* StoreCellIdentifier = @"SearchStoreResultCellIdentifier";
static NSString* HBCellIdentifier = @"SearchHbResultCellIdentifier";

@interface CSearchStoreResultViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) NSMutableDictionary* mutableParameters;
@property (copy, nonatomic) NSString *requestUrl;
@property (assign, nonatomic) BOOL isShowEmpty;
@end

@implementation CSearchStoreResultViewController
#pragma mark - Life cycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeData];
    self.tableView.rowHeight = 86;
    //空数据
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.tableView registerClass:[CStoreTableCell class] forCellReuseIdentifier:StoreCellIdentifier];
    [self.tableView registerClass:[HBRootTableCell class] forCellReuseIdentifier:HBCellIdentifier];
    [self setExtraCellLineHidden:self.tableView];
    // 解决 iOS8中分割线不能置顶
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self insertRowAtTopData];
    __weak __typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}

#pragma mark - Setup data
- (void)insertRowAtTopData
{
    [MBProgressHUD showMessag:@"搜索中..." toView:self.view];
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.mutableParameters[@"lon"] = longitude;
    self.mutableParameters[@"lat"] = latitude;
    self.mutableParameters[@"pageNum"] = @(1);
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:self.requestUrl
        parameters:self.mutableParameters
        success:^(id responseData) {
            id object = responseData[@"data"][@"records"];
            [weakSelf pullToRefreshViewWithObject:object];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:weakSelf.view];
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
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:self.requestUrl
        parameters:self.mutableParameters
        success:^(id responseData) {
            id object = responseData[@"data"][@"records"];
            [weakSelf loadMoreViewWithObject:object];
        }
        failure:^(NSString* errorMessage) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            [MBProgressHUD showError:errorMessage toView:self.view];
        }];
}

- (void)pullToRefreshViewWithObject:(id)object
{
    self.isShowEmpty = YES;
    [self.dataArray removeAllObjects];
    self.page = 2;
    for (NSDictionary* dic in object) {
        if (self.searchResultModule == SearchResultModuleStore) {
            CStoreIntroModel* hiModel = [[CStoreIntroModel alloc] initWithStoreIntroDictionary:dic];
            [self.dataArray addObject:hiModel];
        }else{
            YTResultHongbao* hongbao = [[YTResultHongbao alloc] initWithDictionary:dic error:nil];
            [self.dataArray addObject:hongbao];
        }
    }
    [self.tableView reloadData];
    [self.tableView.infiniteScrollingView beginScrollAnimating];
}
- (void)loadMoreViewWithObject:(id)object
{
    if ([object count] == 0) {
        [self.tableView.infiniteScrollingView endScrollAnimating];
    }
    else {
        self.page++;
        for (NSDictionary* dic in object) {
            if (self.searchResultModule == SearchResultModuleStore) {
                CStoreIntroModel* hiModel = [[CStoreIntroModel alloc] initWithStoreIntroDictionary:dic];
                [self.dataArray addObject:hiModel];
            }else{
                YTResultHongbao* hongbao = [[YTResultHongbao alloc] initWithDictionary:dic error:nil];
                [self.dataArray addObject:hongbao];
            }
        }
        [self.tableView reloadData];
    }
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.searchResultModule == SearchResultModuleStore) {
        CStoreTableCell* cell = [tableView dequeueReusableCellWithIdentifier:StoreCellIdentifier];
        CStoreIntroModel* introModel = _dataArray[indexPath.row];
        [cell configStoreCellWithModel:introModel];
        
        return cell;
    }else{
        HBRootTableCell* cell = [tableView dequeueReusableCellWithIdentifier:HBCellIdentifier];
        YTResultHongbao* hongbao = [_dataArray objectAtIndex:indexPath.row];
        [cell configHbIntroCellWithIntroModel:hongbao];
        return cell;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchResultModule == SearchResultModuleStore) {
        CStoreIntroModel* introModel = _dataArray[indexPath.row];
        [self showShopDetailWithShopId:introModel.storeId isPromotion:introModel.isPromotion];
    }else {
        CSearchHbDetailViewController *hbDetailVC = [[CSearchHbDetailViewController alloc] init];
        YTResultHongbao* hongbao = (YTResultHongbao*)[_dataArray objectAtIndex:indexPath.row];
        hbDetailVC.hongbaoId = hongbao.hongbaoId;
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
}
#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString*)titleForEmptyDataSet:(UIScrollView*)scrollView
{
    return [EmptyDataEffect titleForEmptyDataEffectType:EmptyDataEffectTypeSearchStore];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView*)scrollView
{
    return _isShowEmpty;
}
#pragma mark - Page subviews
- (void)initializeData
{
    self.navigationItem.title = self.searchResultModule == SearchResultModuleStore ? @"商户" : @"红包";
    if (self.searchResultModule == SearchResultModuleStore) {
        self.navigationItem.title = @"商户";
        self.requestUrl = YC_Request_QueryShop;
    }else {
        self.navigationItem.title = @"红包";
        self.requestUrl = YC_Request_QueryHongbaoList;
    }
    self.dataArray = [[NSMutableArray alloc] init];
    self.page = 1;
    self.mutableParameters = [[NSMutableDictionary alloc] init];
    self.mutableParameters[@"pageNum"] = @(_page);
    self.mutableParameters[@"zoneId"] = @0;
    self.mutableParameters[@"pcatId"] = @0;
    self.mutableParameters[@"catId"] = @0;
    self.mutableParameters[@"orderby"] = @"disnear";
    self.mutableParameters[@"radius"] = @5000;
    self.mutableParameters[@"kw"] = self.keyword;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

@end
