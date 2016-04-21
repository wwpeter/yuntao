

#import "HbStoreTableCell.h"
#import "YTHongbaoStoreModel.h"
#import "HBStoreListViewController.h"
#import "XLFormRowNavigationAccessoryView.h"
#import "UserMationMange.h"
#import "MBProgressHUD+Add.h"
#import "YTHongbaoStoreHelper.h"
#import "PromotionHbDetailViewController.h"
#import "PrEmptyView.h"

static NSString* CellIdentifier = @"HbStoreCellIdentifier";

@interface HBStoreListViewController () <UITableViewDataSource, UITableViewDelegate, HbStoreTableCellDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) PrEmptyView* emptyView;
@property (strong, nonatomic) XLFormRowNavigationAccessoryView* navigationAccessoryView;
@end

@implementation HBStoreListViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}
- (instancetype)initWithStoreViewControllerType:(HBStoreViewControllerType)controllerType
{
    self = [super init];
    if (self) {
        _controllerType = controllerType;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializePageSubviews];

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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    if (self.controllerType == HBStoreViewControllerTypeRecomm) {
        self.requestParas = @{ @"pageSize" : @(20),
            @"pageNum" : @(currPage),
            isLoadingMoreKey : @(isLoadingMore) };
        self.requestURL = recomentHongbaoURL;
    }
    else {
        CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
        NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
        self.requestParas = @{ @"pageSize" : @(20),
            @"pageNum" : @(currPage),
            @"lon" : longitude,
            @"lat" : latitude,
            isLoadingMoreKey : @(isLoadingMore) };
        self.requestURL = queryHongbaoListURL;
    }
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        YTHongbaoStoreModel* hongbaoStoreModel = (YTHongbaoStoreModel*)parserObject;
        if (!operation.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:hongbaoStoreModel.hongbaoStore.records];
            _emptyView.hidden = _dataArray.count == 0 ? NO : YES;
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
    HbStoreTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section < _dataArray.count) {
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YTUsrHongBao* hongbao = (YTUsrHongBao*)[_dataArray objectAtIndex:indexPath.section];
        for (YTUsrHongBao *selectHongbao in [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray) {
            if ([selectHongbao.hongbaoId isEqualToString:hongbao.hongbaoId]) {
                hongbao.buyNum = [NSNumber numberWithInteger:selectHongbao.buyNum.integerValue];
                break;
            }
        }
        [cell configHbStoreTableListModel:hongbao];
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
        PromotionHbDetailViewController *hbDetailVC = [[PromotionHbDetailViewController alloc] initWithHbId:hongbao.hongbaoId];
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
}
#pragma mark - HbStoreTableCellDelegate
- (void)hbStoreTableCell:(HbStoreTableCell*)cell textFieldShouldBeginEditing:(UITextField*)textField
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section < 2) {
        return;
    }
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height) - 125;
    [self.tableView setContentOffset:contentOffset animated:YES];
}
- (void)hbStoreTableCell:(HbStoreTableCell*)cell hbStoreModel:(YTUsrHongBao*)hbModel textFieldDidEndEditing:(UITextField*)textField
{
    [self setupTableCell:cell storeModelChange:hbModel];
}

- (void)hbStoreTableCell:(HbStoreTableCell*)cell didAddhbStoreModel:(YTUsrHongBao*)hbModel
{
    [self setupTableCell:cell storeModelChange:hbModel];
}
- (void)hbStoreTableCell:(HbStoreTableCell*)cell didMinushbStoreModel:(YTUsrHongBao*)hbModel
{
    [self setupTableCell:cell storeModelChange:hbModel];
}
- (void)hbStoreTableCellAskAction:(HbStoreTableCell *)cell
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉,您不能购买同行业红包" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
- (void)setupTableCell:(HbStoreTableCell*)cell storeModelChange:(YTUsrHongBao*)hbModel
{
    [self setupSelectHbModel:hbModel];
    if ([self.delegate respondsToSelector:@selector(hbStoreListViewControllerDidChangeStoreHbs:)]) {
        [self.delegate hbStoreListViewControllerDidChangeStoreHbs:self];
    }
}
#pragma mark - Public methods

#pragma mark - Private methods
- (void)setupSelectHbModel:(YTUsrHongBao*)usrHongbao
{
    BOOL isAtStoreModels = NO;
    for (NSInteger i = 0; i < [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray.count; i++) {
        YTUsrHongBao* hongbao = [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray[i];
        if (hongbao.hongbaoId.integerValue == usrHongbao.hongbaoId.integerValue) {
            isAtStoreModels = YES;
            if (usrHongbao.buyNum.integerValue > 0) {
                [[YTHongbaoStoreHelper hongbaoStoreHelper].hbArray replaceObjectAtIndex:i withObject:usrHongbao];
            }
            else {
                [[YTHongbaoStoreHelper hongbaoStoreHelper].hbArray removeObjectAtIndex:i];
            }
            break;
        }
    }
    if (!isAtStoreModels && usrHongbao.buyNum.integerValue > 0) {
        [[YTHongbaoStoreHelper hongbaoStoreHelper].hbArray addObject:usrHongbao];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    if (_controllerType == HBStoreViewControllerTypeRecomm) {
        [self.view addSubview:self.emptyView];
    }
    [self.view addSubview:self.tableView];
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
        _tableView.rowHeight = 125;
        [_tableView registerClass:[HbStoreTableCell class] forCellReuseIdentifier:CellIdentifier];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    }
    return _tableView;
}
- (PrEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[PrEmptyView alloc] initWithFrame:self.view.bounds];
        _emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _emptyView.displayArrow = YES;
        _emptyView.titleLabel.text = @"暂无推荐给您的红包 \n 请切换到附近挑选您想到的红包";
        _emptyView.iconImageView.image = [UIImage imageNamed:@"hb_emptu_icon.png"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

@end
