#import "StoreRootViewController.h"
#import "DOPDropDownMenu.h"
#import "UIViewController+Helper.h"
#import "CStoreTableCell.h"
#import "CStoreIntroModel.h"
#import "StoryBoardUtilities.h"
#import "SVPullToRefresh.h"
#import "StoreSortMange.h"
#import "MBProgressHUD+Add.h"
#import "YTNetworkMange.h"
#import "NSJSONSerialization+file.h"
#import "StoreCatModel.h"
#import "UserCityModel.h"
#import "UserMationMange.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ShopDetailViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "CSearchStoreViewController.h"
#import "UIViewController+ShopDetail.h"
#import "QRCodeReaderViewController.h"
#import "PayCodeViewController.h"
#import "ScanCodeHelper.h"
#import "OutWebViewController.h"
#import "PayViewController.h"
#import "UIAlertView+TTBlock.h"

static NSString* CellIdentifier = @"StoreRootCellIdentifier";

@interface StoreRootViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,QRCodeReaderDelegate>
//扫一扫
@property (strong, nonatomic) QRCodeReaderViewController* readerVC;
// 排序类型
@property (strong, nonatomic) NSArray* sorts;
// 筛选
@property (strong, nonatomic) NSArray* filters;
@property (strong, nonatomic) DOPDropDownMenu* menu;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSString* localCity;

// 区域Id
@property (strong, nonatomic) NSNumber* zoneId;
// 全部分类Id
@property (strong, nonatomic) NSNumber* parentId;
// 分类Id
@property (strong, nonatomic) NSNumber* catId;
// 排序
@property (strong, nonatomic) NSString* orderby;
// 城市
@property (strong, nonatomic) NSArray* citys;
// 分类
@property (strong, nonatomic) NSArray* cats;
//请求内容
@property (strong, nonatomic) NSMutableDictionary* muParameters;

@end

@implementation StoreRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeData];
    [self initializePageSubviews];

   // [self createNavigation];
    [self createMyNavigation];
}

- (void)createMyNavigation {
    
}

- (void)createNavigation {
   
    //查询按钮
    UIImage* norImage = [UIImage imageNamed:@"yt_navigation_search_normal.png"];
    UIImage* higlImage = [UIImage imageNamed:@"yt_navigation_search_high.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:norImage highlightImage:higlImage target:self action:@selector(didSearchBarButtonItemAction:)];
  
    UIImage *saoButton = [UIImage imageNamed:@"yt_navigation_scan.png"];
    UIImage *higImage = [UIImage imageNamed:@"yt_navigation_scan_high.png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:saoButton highlightImage:higImage target:self action:@selector(didSaoButtonItemAction:)];
}

#pragma mark - 扫一扫的方法
- (void)didSaoButtonItemAction:(UIButton *)button {
    _readerVC = [[QRCodeReaderViewController alloc] init];
    _readerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    _readerVC.hidesBottomBarWhenPushed = YES;
    _readerVC.navigationItem.title = @"扫一扫";
    _readerVC.delegate = self;
    __weak typeof(self) weakSelf = self;
    [_readerVC setCompletionWithBlock:^(NSString* resultAsString) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setupScanResultString:resultAsString formViewController:strongSelf.readerVC];
    }];
    [self.navigationController pushViewController:_readerVC animated:YES];

}

- (void)setupScanResultString:(NSString*)string formViewController:(UIViewController*)formViewController
{
    ScanCodeHelper *scanCode = [[ScanCodeHelper alloc] initWithResultUrlString:string];
    if (!scanCode.isYtCode) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"此二维码未经官方认证" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        __weak typeof(self) weakSelf = self;
        [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
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
        PayViewController* payVC = [[PayViewController alloc] init];
        payVC.shopId = scanCode.shopId;
        payVC.mayChange = YES;
        [formViewController.navigationController pushViewController:payVC animated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self steupCityFiltrate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup data
- (void)insertRowAtTop
{
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    //    NSNumber* latitude = @30.30293573;
    //    NSNumber* longitude = @120.09576366;
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:@{ @"pageNum" : @1,
        @"lon" : longitude,
        @"lat" : latitude,
        @"orderby" : self.orderby,
        @"radius" : @2000,
        @"pageSize" : @20 }];
    if (self.zoneId) {
        [parameters setObject:self.zoneId forKey:@"zoneId"];
    }
    if (self.catId) {
        [parameters setObject:self.catId forKey:@"catId"];
    }
    if (self.parentId) {
        [parameters setObject:self.parentId forKey:@"pcatId"];
    }
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_QueryShop
        parameters:parameters
        success:^(id responseData) {
            id object = responseData[@"data"][@"records"];
            [weakSelf pullToRefreshViewWithObject:object];
        }
        failure:^(NSString* errorMessage) {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [MBProgressHUD showError:errorMessage toView:self.view];
        }];
}
- (void)insertRowAtBottom
{
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc] initWithDictionary:@{ @"pageNum" : @(_page),
        @"lon" : longitude,
        @"lat" : latitude,
        @"orderby" : self.orderby,
        @"radius" : @2000,
        @"pageSize" : @20 }];
    if (self.zoneId) {
        [parameters setObject:self.zoneId forKey:@"zoneId"];
    }
    if (self.catId) {
        [parameters setObject:self.catId forKey:@"catId"];
    }
    if (self.parentId) {
        [parameters setObject:self.parentId forKey:@"pcatId"];
    }
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_QueryShop
        parameters:parameters
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
    [self.dataArray removeAllObjects];
    self.page = 2;
    for (NSDictionary* dic in object) {
        CStoreIntroModel* hiModel = [[CStoreIntroModel alloc] initWithStoreIntroDictionary:dic];
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
    }
    else {
        self.page++;
        for (NSDictionary* dic in object) {
            CStoreIntroModel* hiModel = [[CStoreIntroModel alloc] initWithStoreIntroDictionary:dic];
            [self.dataArray addObject:hiModel];
        }
        [self.tableView reloadData];
    }
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - Private Methods
- (void)changeParameter:(DOPIndexPath*)indexPath
{
    switch (indexPath.column) {
    case 0: {
        self.zoneId = _citys[indexPath.row][@"id"];
    } break;
    case 1: {
        StoreCatModel* cat = _cats[indexPath.row];
        if (indexPath.row == 0) {
            self.catId = cat.catId;
            self.parentId = @0;
        }
        else {
            if (indexPath.item < 0) {
                return;
            }
            StoreCatModel* childCat = cat.childrens[indexPath.item];
            self.catId = childCat.catId;
            self.parentId = childCat.parentId;
        }
    } break;
    case 2: {
        //            disnear:距离最近 pricelow:人均最低 pricehig:人均最高，默认为disnear
        if (indexPath.row == 0 && indexPath.row == 1) {
            self.orderby = @"disnear";
        }
        else if (indexPath.row == 2) {
            self.orderby = @"pricelow";
        }
        else if (indexPath.row == 3) {
            self.orderby = @"pricehig";
        }
        else {
            self.orderby = @"disnear";
        }
    } break;

    default:
        break;
    }
    [self.tableView triggerPullToRefresh];
}
- (void)steupCityFiltrate
{
    UserCityModel* cityModel = [[UserMationMange sharedInstance] userCityModel];
    if ([self.localCity isEqualToString:cityModel.city]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* array = [StoreSortMange storeSortAreaWithProvince:cityModel.province city:cityModel.city];
        NSDictionary* allPars = @{ @"id" : @0,
            @"name" : @"全部区域",
            @"next" : [NSArray new] };
        NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithArray:array];
        [mutableArray insertObject:allPars atIndex:0];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.localCity = cityModel.city;
            self.citys = [[NSArray alloc] initWithArray:mutableArray];
            [self.menu selectDefalutIndexPath];
        });
    });
}
#pragma mark - DOPDropDownMenuDelegate
// menu总列数
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu*)menu
{
    return 3;
}
// 每列下拉数
- (NSInteger)menu:(DOPDropDownMenu*)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.citys.count;
    }
    else if (column == 1) {
        return self.cats.count;
    }
    else if (column == 2) {
        return self.sorts.count;
    }
    else {
        return self.filters.count;
    }
}
// 每列下拉标题
- (NSString*)menu:(DOPDropDownMenu*)menu titleForRowAtIndexPath:(DOPIndexPath*)indexPath
{
    if (indexPath.column == 0) {
        return self.citys[indexPath.row][@"name"];
    }
    else if (indexPath.column == 1) {
        StoreCatModel* catModel = self.cats[indexPath.row];
        return catModel.name;
    }
    else if (indexPath.column == 2) {
        return self.sorts[indexPath.row];
    }
    else {
        return self.filters[indexPath.row];
    }
}
// 每列右边items 数量
- (NSInteger)menu:(DOPDropDownMenu*)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        return [self.citys[row][@"next"] count];
    }
    else if (column == 1) {
        StoreCatModel* catModel = self.cats[row];
        return [catModel.childrens count];
    }
    return 0;
}
// 每列右边items 标题
- (NSString*)menu:(DOPDropDownMenu*)menu titleForItemsInRowAtIndexPath:(DOPIndexPath*)indexPath
{
    if (indexPath.column == 0) {
        return self.citys[indexPath.row][@"next"][indexPath.item][@"name"];
    }
    else if (indexPath.column == 1) {
        StoreCatModel* catModel = [self.cats[indexPath.row] childrens][indexPath.item];
        return catModel.name;
    }
    return nil;
}
- (void)menu:(DOPDropDownMenu*)menu didSelectRowAtIndexPath:(DOPIndexPath*)indexPath
{
    NSLog(@"indexPath.column = %@ row = %@ item = %@", @(indexPath.column), @(indexPath.row), @(indexPath.item));
    [self changeParameter:indexPath];
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
    CStoreTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CStoreIntroModel* introModel = _dataArray[indexPath.row];
    [cell configStoreCellWithModel:introModel];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CStoreIntroModel* introModel = _dataArray[indexPath.row];
    [self showShopDetailWithShopId:introModel.storeId isPromotion:introModel.isPromotion];
}
#pragma mark -DZNEmptyDataSetSource
- (NSAttributedString*)titleForEmptyDataSet:(UIScrollView*)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"该区域暂无商户~" attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:18] }];
}
#pragma mark - Navigation
- (void)didSearchBarButtonItemAction:(id)sender
{
    CSearchStoreViewController* searchStoreVC = [[CSearchStoreViewController alloc] init];
    searchStoreVC.searchResultModule = SearchResultModuleStore;
    searchStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchStoreVC animated:YES];
}

#pragma mark - Page subviews
- (void)initializeData
{
    self.localCity = @"";
    self.orderby = @"disnear";
    self.dataArray = [[NSMutableArray alloc] init];
    NSArray* cats = [NSJSONSerialization loadObjectFileName:kYCStoreCatDataFileName];
    if (cats.count > 0) {
        NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
        NSDictionary* allPars = @{ @"id" : @0,
            @"level" : @"1",
            @"name" : @"全部分类",
            @"children" : [NSArray new] };
        StoreCatModel* allCatModel = [[StoreCatModel alloc] initWithStoreCatDictionary:allPars];
        [mutableArray addObject:allCatModel];
        for (NSDictionary* dic in cats) {
            StoreCatModel* catModel = [[StoreCatModel alloc] initWithStoreCatDictionary:dic];
            [mutableArray addObject:catModel];
        }
        self.cats = [[NSArray alloc] initWithArray:mutableArray];
    }

    self.sorts = @[ @"智能排序", @"离我最近", @"人均最低", @"人均最高" ];
    self.filters = @[ @"不限", @"50元以下", @"50-100元", @"100元以上" ];
}
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    // 添加下拉菜单
    self.menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointZero andHeight:44];
    self.menu.delegate = self;
    self.menu.dataSource = self;
    [self.view addSubview:self.menu];
}

#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        //- CGRectGetHeight(self.tabBarController.tabBar.frame) 
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, CGRectGetHeight(self.view.bounds) - kNavigationFullHeight - 44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.rowHeight = 86;
        [_tableView registerClass:[CStoreTableCell class] forCellReuseIdentifier:CellIdentifier];
        // 解决 iOS8中分割线不能置顶
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        //添加下拉刷新
        __weak __typeof(self) weakSelf = self;
        [_tableView addPullToRefreshWithActionHandler:^{
            [weakSelf insertRowAtTop];
        }];
        [_tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf insertRowAtBottom];
        }];
    }
    return _tableView;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
