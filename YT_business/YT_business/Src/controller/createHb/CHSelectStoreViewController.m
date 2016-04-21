#import "CHSelectStoreViewController.h"
#import "CHSearchStoreView.h"
#import "UIViewController+Helper.h"
#import "SVPullToRefresh.h"
#import "CHStoreTableCell.h"
#import "CHSearchResponseView.h"
#import "UserMationMange.h"
#import "MBProgressHUD+Add.h"
#import "YTQueryShopModel.h"
#import "YTQueryShopHelper.h"
#import "ShopDetailViewController.h"

static const NSInteger kSearchViewHeight = 50;

static NSString *CellIdentifier = @"SelectCellIdentifier";

@interface CHSelectStoreViewController ()<UITableViewDelegate,UITableViewDataSource,CHStoreTableCellDelegate,CHSearchStoreViewDelegate,CHSearchResponseViewDelegate>

@property (strong, nonatomic) CHSearchStoreView *searchView;
@property (strong, nonatomic) CHSearchResponseView *searchResponseView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end


@implementation CHSelectStoreViewController

@synthesize rowDescriptor = _rowDescriptor;

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择投放商户";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializeData];
    [self initializePageSubviews];

    [self setupFormStores];
    
    wSelf(wSelf);
    // refresh
    [_tableView addPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    _tableView.showsInfiniteScrolling = NO;
    [_tableView triggerPullToRefresh];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.rowDescriptor.value = [[NSMutableArray alloc] initWithArray:[YTQueryShopHelper queryShopHelper].shopArray];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore {
    int currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        currPage = 1;
    } else {
        ++ currPage;
    }
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.requestParas = @{@"pageSize":@(20),
                          @"pageNum":@(currPage),
                          @"lon" : longitude,
                          @"lat" : latitude,
                          isLoadingMoreKey:@(isLoadingMore)};
    self.requestURL = queryShopListURL;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
     if (parserObject.success) {
        YTQueryShopModel *queryShopModel = (YTQueryShopModel *)parserObject;
         if (!operation.isLoadingMore) {
             _dataArray = [NSMutableArray arrayWithArray:queryShopModel.shopSet.records];
         } else {
             [_dataArray addObjectsFromArray:queryShopModel.shopSet.records];
         }
         [self.tableView reloadData];
         if (!operation.isLoadingMore) {
             [self.tableView.pullToRefreshView stopAnimating];
         } else {
             [self.tableView.infiniteScrollingView stopAnimating];
         }
         if (_dataArray.count) {
             self.tableView.showsInfiniteScrolling = YES;
         } else {
             self.tableView.showsInfiniteScrolling = NO;
         }

     }else{
         [MBProgressHUD showError:parserObject.message toView:self.view];
     }
    
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHStoreTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    YTShop *shop = _dataArray[indexPath.row];
    shop.didSelect = NO;
    NSMutableArray *shopSelectArray = [YTQueryShopHelper queryShopHelper].shopArray;
    for (YTShop *selectShop in shopSelectArray) {
        if ([selectShop.shopId isEqualToString:shop.shopId]) {
            shop.didSelect = YES;
            break;
        }
    }
    [cell configStoreCellWithListModel:shop];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchView endEditing:YES];
     YTShop *shop = _dataArray[indexPath.row];
    ShopDetailViewController *shopDetailVC  = [[ShopDetailViewController alloc] initWithShopId:shop.shopId];
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}
#pragma mark - CHStoreTableCell delegate
- (void)storeTableCell:(CHStoreTableCell *)cell didSelectStore:(YTShop *)shop
{
    [self changeSelectShop:shop];
}
#pragma mark - CHSearchStoreView delegate
- (void)searchStoreView:(CHSearchStoreView *)view didRemoverItem:(StoreButton *)storeButton
{
    [self.tableView reloadData];
}

- (void)searchStoreView:(CHSearchStoreView *)view textFieldShouldBeginEditing:(UITextField *)textField
{
    _searchResponseView.hidden = NO;
}
- (void)searchStoreView:(CHSearchStoreView *)view textFieldShouldReturn:(UITextField *)textField
{
    _searchResponseView.keyword = textField.text;
    [_searchResponseView.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [_searchResponseView.tableView triggerPullToRefresh];
}
- (void)searchStoreView:(CHSearchStoreView *)view shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (range.location == 0) {
//        [_searchResponseView.dataArray removeAllObjects];
//        [_searchResponseView.tableView reloadData];
//    }
}
#pragma mark - CHSearchResponseView delegate
- (void)searchResponseView:(CHSearchResponseView *)view didSelectStore:(YTShop *)shop
{
    [self changeSelectShop:shop];
}
- (void)searchResponseViewDidSignTap:(CHSearchResponseView *)view
{
    _searchResponseView.hidden = YES;
    [self.view endEditing:YES];
}
- (void)searchResponseView:(CHSearchResponseView *)view didScroll:(UIScrollView *)scrollView
{
    [_searchView.searchField resignFirstResponder];
}
#pragma mark - Event response
#pragma mark - Private methods
- (void)changeSelectShop:(YTShop *)shop
{
    if (shop.didSelect) {
        [_searchView removeShop:shop];
    }
    else {
        NSInteger storeCount = [YTQueryShopHelper queryShopHelper].shopArray.count;
        if (storeCount < kMaxStoreCount) {
            [[YTQueryShopHelper queryShopHelper].shopArray addObject:shop];
            [_searchView addShopItem:shop];
            
        } else {
            [self showAlert:@"最多只能添加10个" title:@""];
            _searchResponseView.hidden = YES;
            return;
        }
        
    }
    _searchResponseView.hidden = YES;
    [self.tableView reloadData];
}
- (void)setupFormStores
{
    if ([YTQueryShopHelper queryShopHelper].shopArray.count > 0) {
        [_searchView addShopItems:[YTQueryShopHelper queryShopHelper].shopArray];
    }
}
#pragma mark - Notification Response
#pragma mark - Navigation
- (void)didLeftBarButtonItemAction:(id)sender
{
    
}
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchResponseView];
    [self setExtraCellLineHidden:self.tableView];
}
#pragma mark - Getters & Setters
- (CHSearchStoreView *)searchView
{
    if (!_searchView) {
        _searchView = [[CHSearchStoreView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kSearchViewHeight)];
        _searchView.delegate = self;
    }
    return _searchView;
}
- (CHSearchResponseView *)searchResponseView
{
    if (!_searchResponseView) {
        _searchResponseView = [[CHSearchResponseView alloc] initWithFrame:CGRectMake(0, kSearchViewHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-kSearchViewHeight-kNavigationFullHeight)];
        _searchResponseView.delegate = self;
        _searchResponseView.hidden = YES;
    }
    return _searchResponseView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchViewHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-kSearchViewHeight-kNavigationFullHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 86;
        [_tableView registerClass:[CHStoreTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}


- (void)initializeData
{
    _dataArray = [[NSMutableArray alloc] init];
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
