
#import "YTRegisterAddressSelViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "UserMationMange.h"
#import "SVPullToRefresh.h"
#import "YTRegisterHelper.h"
#import "YTVenderDefine.h"
#import "UIViewController+Helper.h"
#import "CCTextField.h"
#import "YTAddressSearchViewController.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"

@interface YTRegisterAddressSelViewController () <MAMapViewDelegate, AMapSearchDelegate,YTAddressSearchViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) MAMapView* mapView;
@property (strong, nonatomic) AMapSearchAPI* search;
@property (strong, nonatomic) UIImageView* annotationImageView;
@property (strong, nonatomic) UITableView* tableView;
//@property (strong, nonatomic) CCTextField* textField;
@property (strong, nonatomic) UIButton* userLocButton;

@property (strong, nonatomic) NSMutableArray* dataArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger selectIndex;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) AMapPOI* selectPoi;

@property (assign, nonatomic) BOOL didLocation;
@property (assign, nonatomic) BOOL didSearch;
@end

@implementation YTRegisterAddressSelViewController
#pragma mark - Utility

- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    [_mapView removeAnnotations:self.mapView.annotations];
    [_mapView removeOverlays:self.mapView.overlays];
    _mapView.delegate = nil;
    [_mapView removeFromSuperview];
}
- (void)clearSearch
{
    _search.delegate = nil;
}
- (void)dealloc
{
    [self clearMapView];
    [self clearSearch];
}

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [[NSMutableArray alloc] init];
    [self configurUIComponents];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -configurUIComponents
- (void)configurUIComponents
{
    self.navigationItem.title = @"选择位置";
    
    UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    UIBarButtonItem* searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItems = @[ saveItem, searchItem ];

    [MAMapServices sharedServices].apiKey = kGaodeiMapKey;

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.annotationImageView];
        [self.view addSubview:self.userLocButton];
    [self.view addSubview:self.tableView];

    self.search = [[AMapSearchAPI alloc] initWithSearchKey:kGaodeiMapKey Delegate:self];
    __weak __typeof(self) weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    if (self.centerCoordinate.latitude != 0) {
        [self.mapView setCenterCoordinate:self.centerCoordinate animated:YES];
    }
}
- (void)insertRowAtBottom
{
    [self searchPoiByCenterCoordinate:self.coordinate page:self.page];
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
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"mapAddressCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.tintColor = [UIColor redColor];
    if (indexPath.row == _selectIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    AMapPOI* mapPoi = _dataArray[indexPath.row];
    cell.textLabel.text = mapPoi.name;
    cell.detailTextLabel.text = mapPoi.address;
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
    UITableViewCell* lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell* selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (indexPath.row < _dataArray.count) {
        self.selectPoi = _dataArray[indexPath.row];
    }
    _selectIndex = indexPath.row;
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
  
}
#pragma mark - YTAddressSearchViewControllerDelegate
- (void)addressSearchViewController:(YTAddressSearchViewController*)viewController didSelectPoi:(AMapPOI*)mapPoi
{
    self.didSearch = YES;
    self.selectPoi = mapPoi;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(mapPoi.location.latitude, mapPoi.location.longitude);
    [self.mapView setCenterCoordinate:coordinate animated:YES];
}
#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
         updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation) {
        if (self.didLocation) {
            return;
        }
        if (self.centerCoordinate.latitude == 0) {
             [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        }
       
        [self searchPoiByCenterCoordinate:userLocation.coordinate page:1];
        self.didLocation = YES;
    }
}
- (void)mapView:(MAMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.coordinate = mapView.centerCoordinate;
    [self searchPoiByCenterCoordinate:mapView.centerCoordinate page:1];
}
/*!
 @brief POI查询回调函数
 @param request 发起查询的查询选项(具体字段参考AMapPlaceSearchRequest类中的定义)
 @param response 查询结果(具体字段参考AMapPlaceSearchResponse类中的定义)
 */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest*)request response:(AMapPlaceSearchResponse*)response
{
     self.didSearch = NO;
    if (request.page == 1) {
        self.page = 1;
        self.selectIndex = 0;
        [self.dataArray removeAllObjects];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    self.page++;
    [self.dataArray addObjectsFromArray:response.pois];
    [self.tableView.infiniteScrollingView stopAnimating];
    [self.tableView reloadData];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Event response
- (void)userLocButtonClicked:(id)sender
{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}
#pragma mark - Private methods
- (void)searchPoiByCenterCoordinate:(CLLocationCoordinate2D)coordinate page:(NSInteger)page
{
    //构造AMapPlaceSearchRequest对象，配置关键字搜索参数
    AMapPlaceSearchRequest* request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType = AMapSearchType_PlaceAround;
    request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    /* 按照距离排序. */
    request.sortrule = 1;
    request.requireExtension = YES;
    request.page = page;
    if (self.didSearch) {
        request.keywords = self.selectPoi.name;
        request.types = @[];
    }
    else {
        request.keywords = @"";
        request.types = @[ @"010000", @"020000", @"030000", @"060000", @"070000", @"080000", @"090000", @"100000", @"110000", @"120000", @"140000", @"150000", @"160000", @"170000", @"180000", @"190000" ];
    }
    
    //发起POI搜索
    [self.search AMapPlaceSearch:request];
}
- (UIImage*)imagesNamedFromCustomBundle:(NSString*)imgName
{
    NSString* bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"AMap.bundle"];
    NSBundle* bundle = [NSBundle bundleWithPath:bundlePath];
    NSString* img_path = [bundle pathForResource:imgName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:img_path];
}
#pragma mark - Navigation
- (void)searchBarButtonItemAction:(id)sender
{
    YTAddressSearchViewController* addressSearchVC = [[YTAddressSearchViewController alloc] init];
    addressSearchVC.delegate = self;
    [self.navigationController pushViewController:addressSearchVC animated:YES];
}
- (void)didRightBarButtonItemAction:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showAlert:@"无法搜索到地址,请检查是否打开定位" title:@""];
        return;
    }
    if ([NSStrUtil isEmptyOrNull:self.selectPoi.address]) {
        [self showAlert:@"您还没有选择地址哦~" title:@""];
        return;
    }
    if (_dataArray.count > 0) {
        [YTRegisterHelper registerHelper].address = self.selectPoi.address;
        [YTRegisterHelper registerHelper].province = self.selectPoi.province;
        [YTRegisterHelper registerHelper].city = self.selectPoi.city;
        [YTRegisterHelper registerHelper].district = self.selectPoi.district;
        [YTRegisterHelper registerHelper].lat = self.selectPoi.location.latitude;
        [YTRegisterHelper registerHelper].lon = self.selectPoi.location.longitude;
        if ([self.delegate respondsToSelector:@selector(registerAddressSelViewController:didSelectPoi:)]) {
            [_delegate registerAddressSelViewController:self didSelectPoi:_selectPoi];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self showAlert:@"地址保存失败，请重试" title:@""];
        return;
    }
}
#pragma mark - Getters & Setters
- (MAMapView*)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, (KDeviceHeight - 64) / 2)];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeNone;
        [_mapView setZoomLevel:17 animated:YES];
        //    MACoordinateSpan span = MACoordinateSpanMake(0.05, 0.05);
        //    MACoordinateRegion region = MACoordinateRegionMake(location, span);
        //    [self.mapView setRegion:region animated:YES];

        //    UIImage *image = [UIImage imageNamed:@"MyBundle.bundle/img_collect_success"];
    }
    return _mapView;
}
- (UITableView*)tableView
{
    if (_tableView)
        return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + (KDeviceHeight - 64) / 2, kDeviceWidth, (KDeviceHeight - 64) / 2) style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    return _tableView;
}
- (UIImageView*)annotationImageView
{
    if (!_annotationImageView) {
        UIImage* annotationImage = [UIImage imageNamed:@"yt_redPin.png"];
        _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, annotationImage.size.width, annotationImage.size.height)];
        _annotationImageView.center = CGPointMake(self.view.center.x, (((KDeviceHeight - 64) / 2 - 44)) / 2 + 64+44);
        _annotationImageView.image = annotationImage;
    }
    return _annotationImageView;
}
//- (CCTextField*)textField
//{
//    if (!_textField) {
//        _textField = [[CCTextField alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
//        _textField.borderStyle = UITextBorderStyleNone;
//        _textField.font = [UIFont systemFontOfSize:15];
//        _textField.textColor = [UIColor blackColor];
//        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _textField.returnKeyType = UIReturnKeyDone;
//        _textField.enablesReturnKeyAutomatically = YES;
//        _textField.delegate = self;
//        _textField.placeholder = @"可直接输入地址";
//    }
//    return _textField;
//}
- (UIButton *)userLocButton
{
    if (!_userLocButton) {
        _userLocButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat by = 64 + ((KDeviceHeight - 64) / 2 - 44) -10;
        _userLocButton.frame = CGRectMake(15, by, 36, 36);
        [_userLocButton setImage:[UIImage imageNamed:@"yt_userLocation_normal.png"] forState:UIControlStateNormal];
        [_userLocButton addTarget:self action:@selector(userLocButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userLocButton;
}
-(AMapPOI *)selectPoi
{
    if (!_selectPoi) {
        _selectPoi = _dataArray[self.selectIndex];
    }
    return _selectPoi;
}
@end
