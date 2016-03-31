#import "YTShopNoticeViewController.h"
#import "UIViewController+Helper.h"
#import "YTShopNoticeTableCell.h"
#import "YTNoticeViewController.h"
#import "KindHbDetailViewController.h"
#import "OpenHongbaoViewController.h"
#import "UserMationMange.h"
#import "SVPullToRefresh.h"
#import "YTXjswHbListModel.h"
#import "MBProgressHUD+Add.h"

static NSString* CellIdentifier = @"ShopNoticeCellIdentifier";

@interface YTShopNoticeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation YTShopNoticeViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:1];
    [self initializePageSubviews];
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
    NSNumber *userId = [[UserMationMange sharedInstance] userId];
    NSInteger currPage = [[self.requestParas objectForKey:@"pageNum"] integerValue];
    if (!isLoadingMore) {
        currPage = 1;
    }
    else {
        ++currPage;
    }
    self.requestParas = @{ @"pageSize" : @(20),
                           @"pageNum" : @(currPage),
                           @"userId" : userId,
                           isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = YC_Request_GetXjswHbList;
}
#pragma mark -override FetchData
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
        YTXjswHbListModel* listModel = (YTXjswHbListModel*)parserObject;
        if (!request.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:listModel.hbListSet.records];
        }
        else {
            [_dataArray addObjectsFromArray:listModel.hbListSet.records];
        }
        if (listModel.hbListSet.totalCount > _dataArray.count) {
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
    YTShopNoticeTableCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_dataArray.count > indexPath.row) {
        YTXjswHb *xjswHb = _dataArray[indexPath.row];
        [cell configShopNoticeCellWithModel:xjswHb];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTXjswHb *xjswHb = _dataArray[indexPath.row];
    YTNoticeViewController *noticeVC = [[YTNoticeViewController alloc] init];
    noticeVC.noticeType = YTNoticeViewControllerTypeShop;
    noticeVC.xjswHb = xjswHb;
    noticeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:noticeVC animated:YES];
}
#pragma mark - Event response

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
}
#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 86;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[YTShopNoticeTableCell class] forCellReuseIdentifier:CellIdentifier];
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
