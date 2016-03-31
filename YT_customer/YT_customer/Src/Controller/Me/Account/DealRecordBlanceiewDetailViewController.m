#import "DealRecordBlanceiewDetailViewController.h"
#import "DealRecordTableCell.h"
#import "UIViewController+Helper.h"
#import "YTAccountDetailModel.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD+Add.h"
#import "YTAccountDetailModel.h"

static NSString* CellIdentifier = @"DealRecordBlanceiewIdentifier";

@interface DealRecordBlanceiewDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation DealRecordBlanceiewDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"账单明细";
    [self initializePageSubviews];
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
    self.requestParas = @{ @"pageSize" : @(20),
        @"pageNum" : @(currPage),
        isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = YC_Request_MemberBillDetailList;
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel*)parserObject
              errorMessage:(NSString*)errorMessage
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
        YTAccountDetailModel* accountModel = (YTAccountDetailModel*)parserObject;
        if (!request.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:accountModel.accountDetailSet.records];
        }
        else {
            [_dataArray addObjectsFromArray:accountModel.accountDetailSet.records];
        }
        if (accountModel.accountDetailSet.totalCount > _dataArray.count) {
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
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    DealRecordTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row < _dataArray.count) {
        YTAccountDetail* accountDetail = (YTAccountDetail*)[_dataArray objectAtIndex:indexPath.row];
        [cell configDealTableCellWithAccountDetailModel:accountDetail];
    }
    return cell;
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    [self.tableView triggerPullToRefresh];
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[DealRecordTableCell class] forCellReuseIdentifier:CellIdentifier];
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
