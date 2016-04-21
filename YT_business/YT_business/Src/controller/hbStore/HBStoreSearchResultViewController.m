#import "HBStoreSearchResultViewController.h"
#import "UserMationMange.h"
#import "MBProgressHUD+Add.h"
#import "YTHongbaoStoreModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PromotionHbDetailViewController.h"
#import "HBStoreSearchResultCell.h"
#import "NSStrUtil.h"

static NSString* CellIdentifier = @"HbStoreSearchCellIdentifier";

@interface HBStoreSearchResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;

@end

@implementation HBStoreSearchResultViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"搜索结果";
    if ([NSStrUtil isEmptyOrNull:self.keyword]) {
        self.keyword = @"";
    }
    [self.view addSubview:self.tableView];

    wSelf(wSelf);
    // refresh
    [self.tableView addYTPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [self.tableView addYTInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    self.tableView.showsInfiniteScrolling = NO;
    [self.tableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    int currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        currPage = 1;
    }
    else {
        ++currPage;
    }

    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.requestParas = @{ @"pageSize" : @(20),
        @"pageNum" : @(currPage),
        @"lon" : longitude,
        @"lat" : latitude,
        @"kw" : _keyword,
        isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = queryHongbaoListURL;
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        YTHongbaoStoreModel* hongbaoStoreModel = (YTHongbaoStoreModel*)parserObject;
        if (!operation.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:hongbaoStoreModel.hongbaoStore.records];
        }
        else {
            [_dataArray addObjectsFromArray:hongbaoStoreModel.hongbaoStore.records];
        }
        [self.tableView reloadData];
        if (!operation.isLoadingMore) {
            [self.tableView.pullToRefreshView stopAnimating];
        }
        else {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
        if (hongbaoStoreModel.hongbaoStore.totalCount > _dataArray.count) {
            self.tableView.showsInfiniteScrolling = YES;
        }
        else {
            self.tableView.showsInfiniteScrolling = NO;
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
    if (_dataArray.count && _dataArray.count > 0) {
        return;
    }
}
#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HBStoreSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section < _dataArray.count) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YTUsrHongBao* hongbao = (YTUsrHongBao*)[_dataArray objectAtIndex:indexPath.section];
        [cell configHbStoreSearchResultModel:hongbao];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endEditing:YES];
    if (indexPath.section < _dataArray.count) {
        YTUsrHongBao* hongbao = (YTUsrHongBao*)[_dataArray objectAtIndex:indexPath.section];
        PromotionHbDetailViewController* hbDetailVC = [[PromotionHbDetailViewController alloc] initWithHbId:hongbao.hongbaoId];
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
}

#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 75;
        [_tableView registerClass:[HBStoreSearchResultCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}

@end
