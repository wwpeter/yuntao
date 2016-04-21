#import "YTAddressSearchViewController.h"
#import "SVPullToRefresh.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "NSStrUtil.h"
#import "UIScrollView+EmptyDataSet.h"
#import "YTVenderDefine.h"

static NSString* AddressSearchCellIdentifier = @"addressSearchCellIdentifier";

@interface YTAddressSearchViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,AMapSearchDelegate>

@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSMutableArray* dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL isShowEmpty;

@property (strong, nonatomic) AMapSearchAPI *poiSearch;

@end

@implementation YTAddressSearchViewController

#pragma mark - Life cycle
- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView.emptyDataSetDelegate = nil;
    _tableView.emptyDataSetSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"搜索地址";
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    self.dataArray = [[NSMutableArray alloc] init];
    self.poiSearch = [[AMapSearchAPI alloc] initWithSearchKey:kGaodeiMapKey Delegate:self];
    
    [self initializePageSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_dataArray.count == 0) {
        [self.searchBar becomeFirstResponder];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _poiSearch.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:AddressSearchCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AddressSearchCellIdentifier];
    }
    cell.tintColor = [UIColor redColor];
    AMapPOI *mapPoi = _dataArray[indexPath.row];
    cell.textLabel.text = mapPoi.name;
    cell.detailTextLabel.text = mapPoi.address;
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [_searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.accessoryType =  UITableViewCellAccessoryCheckmark;
    if (indexPath.row < _dataArray.count) {
        AMapPOI *mapPoi = _dataArray[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(addressSearchViewController:didSelectPoi:)]) {
            [_delegate addressSearchViewController:self didSelectPoi:mapPoi];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}
#pragma mark - AMapSearchDelegate
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    [self.activityIndicator stopAnimating];
    if (response.pois.count > 0) {
        self.tableView.showsInfiniteScrolling = YES;
        self.page ++;
        [self.dataArray addObjectsFromArray:response.pois];
    }else{
        self.isShowEmpty = YES;
    }
    [self.tableView.infiniteScrollingView stopAnimating];
    [self.tableView reloadData];
    
}
#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [self searchPoiByPage:1];
    [self.activityIndicator startAnimating];
}

- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString*)titleForEmptyDataSet:(UIScrollView*)scrollView
{
    
    return [[NSAttributedString alloc] initWithString:@"没有搜索结果"];
}


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView*)scrollView
{
    return _isShowEmpty;
}


#pragma mark - Private methods
- (void)insertRowAtBottom
{
    [self searchPoiByPage:self.page];
}
- (void)searchPoiByPage:(NSInteger)page
{
    if (page == 1) {
        self.page  = 1;
        [self.dataArray removeAllObjects];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType          = AMapSearchType_PlaceKeyword;
    request.keywords            = self.searchBar.text;
    //    request.types = @[@"010000",@"020000",@"030000",@"060000",@"070000",@"080000",@"090000",@"100000",@"110000",@"120000",@"140000",@"150000",@"160000",@"170000",@"180000",@"190000"];
    /* 按照距离排序. */
    //    request.sortrule            = 1;
    request.requireExtension    = YES;
    request.page = page;
    
    //发起POI搜索
    [self.poiSearch AMapPlaceSearch:request];
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initializePageSubviews
{
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.activityIndicator];
    self.tableView.showsInfiniteScrolling = NO;
    //添加下拉刷新
    __weak __typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}
#pragma mark - Getters & Setters
- (UISearchBar*)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.backgroundImage = nil;
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        //        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        if ([_searchBar respondsToSelector:@selector(barTintColor)]) {
            [_searchBar setBarTintColor:CCColorFromRGB(248, 248, 248)];
        }
    }
    return _searchBar;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, CGRectGetHeight(self.view.bounds)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0, 0, 32, 32);
        _activityIndicator.center = CGPointMake(self.view.bounds.size.width * 0.5, 100);
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

@end
