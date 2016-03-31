#import "HbRootViewController.h"
#import "CMyHbListViewController.h"
#import "QRCodeReaderViewController.h"
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "UserMationMange.h"
#import "ScanCodeHelper.h"
#import "UIViewController+Helper.h"
#import "OutWebViewController.h"
#import "ShopDetailViewController.h"
#import "UIAlertView+TTBlock.h"
#import "DOPDropDownMenu.h"
#import "UIBarButtonItem+Addition.h"
#import "StoreCatModel.h"
#import "UserCityModel.h"
#import "NSJSONSerialization+file.h"
#import "SVPullToRefresh.h"
#import "StoreSortMange.h"
#import "CSearchStoreViewController.h"
#import "HBRootTableCell.h"
#import "MBProgressHUD+Add.h"
#import "YTResultHbModel.h"
#import "CSearchHbDetailViewController.h"

static NSString* CellIdentifier = @"hbRootCellIdentifier";

@interface HbRootViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DOPDropDownMenu* menu;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSString* localCity;

// 区域Id
@property (strong, nonatomic) NSNumber* zoneId;
// 全部分类Id
@property (strong, nonatomic) NSNumber* pcatId;
// 分类Id
@property (strong, nonatomic) NSNumber* catId;
// 排序
@property (strong, nonatomic) NSString* orderby;
// 城市
@property (strong, nonatomic) NSArray* citys;
// 分类
@property (strong, nonatomic) NSArray* cats;

@end

@implementation HbRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeData];
    [self initializePageSubviews];
    UIImage* norImage = [UIImage imageNamed:@"yt_navigation_search_normal.png"];
    UIImage* higlImage = [UIImage imageNamed:@"yt_navigation_search_high.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:norImage highlightImage:higlImage target:self action:@selector(didSearchBarButtonItemAction:)];
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
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];

    NSInteger currPage = [[self.requestParas objectForKey:@"pageNum"] integerValue];
    if (!isLoadingMore) {
        currPage = 1;
    }
    else {
        ++currPage;
    }
    self.requestParas = @{ @"pageSize" : @(20),
        @"pageNum" : @(currPage),
        @"lon" : longitude,
        @"lat" : latitude,
        @"kw" : @"",
        @"pcatId" : self.pcatId,
        @"catId" : self.catId,
        @"zoneId" : self.zoneId,
        isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = YC_Request_QueryHongbaoList;
}
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel*)parserObject
              errorMessage:(NSString*)errorMessage;
{
    if (!request.isLoadingMore) {
        [self.tableView.pullToRefreshView stopAnimating];
    }
    else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    if (errorMessage) {
        [MBProgressHUD showError:errorMessage toView:self.view];
        return;
    }
    if (parserObject.success) {
        YTResultHbModel* hongbaoModel = (YTResultHbModel*)parserObject;
        if (!request.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:hongbaoModel.resultHbSet.records];
        }
        else {
            [_dataArray addObjectsFromArray:hongbaoModel.resultHbSet.records];
        }
        if (hongbaoModel.resultHbSet.totalCount > _dataArray.count) {
            self.tableView.showsInfiniteScrolling = YES;
        }
        else {
            self.tableView.showsInfiniteScrolling = NO;
        }
        [self.tableView reloadData];
    }
    else {
    }
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HBRootTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row < _dataArray.count) {
        YTResultHongbao* hongbao = (YTResultHongbao*)[_dataArray objectAtIndex:indexPath.row];
        [cell configHbIntroCellWithIntroModel:hongbao];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CSearchHbDetailViewController *hbDetailVC = [[CSearchHbDetailViewController alloc] init];
    YTResultHongbao* hongbao = (YTResultHongbao*)[_dataArray objectAtIndex:indexPath.row];
    hbDetailVC.hongbaoId = hongbao.hongbaoId;
    hbDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hbDetailVC animated:YES];
}
#pragma mark - DOPDropDownMenuDelegate
// menu总列数
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu*)menu
{
    return 2;
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
    else {
        return 0;
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
    else {
        return nil;
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
            self.pcatId = @0;
        }
        else {
            if (indexPath.item < 0) {
                return;
            }
            StoreCatModel* childCat = cat.childrens[indexPath.item];
            self.catId = childCat.catId;
            self.pcatId = childCat.parentId;
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
#pragma mark - Event response
- (void)useButtonClicked:(id)sender
{
    if ([[UserMationMange sharedInstance] userLogin]) {
        CMyHbListViewController* myHbListVC = [[CMyHbListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        myHbListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myHbListVC animated:YES];
    }
    else {
        [self userLogin];
    }
}

- (void)userLogin
{
    YTLoginViewController* loginVC = [[YTLoginViewController alloc] init];
    loginVC.loginType = LoginViewTypePhone;
    YTNavigationController* navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}
#pragma mark - Navigation
- (void)didSearchBarButtonItemAction:(id)sender
{
    CSearchStoreViewController* searchStoreVC = [[CSearchStoreViewController alloc] init];
    searchStoreVC.searchResultModule = SearchResultModuleHb;
    searchStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchStoreVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializeData
{
    self.localCity = @"";
    self.orderby = @"disnear";
    self.zoneId = @0;
    self.pcatId = @0;
    self.catId = @0;
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
}

- (void)initializePageSubviews
{
    self.view.backgroundColor = CCCUIColorFromHex(0xeef8ff);
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

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, CGRectGetHeight(self.view.bounds) - kNavigationFullHeight - CGRectGetHeight(self.tabBarController.tabBar.frame) - 44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 86;
        [_tableView registerClass:[HBRootTableCell class] forCellReuseIdentifier:CellIdentifier];
        //添加下拉刷新
        __weak __typeof(self) weakSelf = self;
        [_tableView addPullToRefreshWithActionHandler:^{
            [weakSelf fetchDataWithIsLoadingMore:NO];
        }];
        [_tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf fetchDataWithIsLoadingMore:YES];
        }];
        _tableView.showsInfiniteScrolling = NO;
    }
    return _tableView;
}

@end
