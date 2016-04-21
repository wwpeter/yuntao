
#import "VipIncomViewController.h"
#import "UIViewController+Helper.h"
#import "UIBarButtonItem+Addition.h"
#import "RESideMenu.h"
#import "VipIncomTableHeadView.h"
#import "VipIncomTableCell.h"
#import "YTVipIncomeModel.h"
#import "MBProgressHUD+Add.h"

static NSString* CellIdentifier = @"VipIncomCellIdentifier";

@interface VipIncomViewController () <UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) VipIncomTableHeadView* headView;
@property (nonatomic, copy) NSMutableArray* dataArray;
@end

@implementation VipIncomViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"会员收益";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
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
    self.requestURL = vipShopIndexURL;
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (!operation.isLoadingMore) {
        [self.tableView.pullToRefreshView stopAnimating];
    }
    else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
    
    if (!parserObject.success) {
        [MBProgressHUD showError:parserObject.message toView:self.view];
        return;
    }
    YTVipIncomeModel* incomeModel = (YTVipIncomeModel*)parserObject;
    if (!operation.isLoadingMore) {
        self.dataArray = [NSMutableArray arrayWithArray:incomeModel.incomeSet.page.records];
        self.headView.totalIncome = [NSString stringWithFormat:@"%.2f",incomeModel.incomeSet.totalAmount/100.];
        self.headView.yesterdayIncom = [NSString stringWithFormat:@"%.2f",incomeModel.incomeSet.yestodayAmount/100.];
    }
    else {
        [self.dataArray addObjectsFromArray:incomeModel.incomeSet.page.records];
    }
    [self.tableView reloadData];
    if (incomeModel.incomeSet.page.totalCount > _dataArray.count) {
        self.tableView.showsInfiniteScrolling = YES;
    }
    else {
        self.tableView.showsInfiniteScrolling = NO;
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
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    VipIncomTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section < _dataArray.count) {
        YTIncome* income = (YTIncome*)[_dataArray objectAtIndex:indexPath.section];
        [cell configIncomTableCellWithModel:income];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    wSelf(wSelf);
    [self setExtraCellLineHidden:self.tableView];
    
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
#pragma mark - Getters & Setters
- (VipIncomTableHeadView*)headView
{
    if (!_headView) {
        _headView = [[VipIncomTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 110)];
    }
    return _headView;
}
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 110, kDeviceWidth, KDeviceHeight - 110) style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[VipIncomTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
@end
