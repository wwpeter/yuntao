
#import "ApplyUntil.h"
#import "CDealRecordBlanceiewController.h"
#import "CDealRecordCollecionViewController.h"
#import "CDealRecordDetailViewController.h"
#import "CDealRecordTableCell.h"
#import "CDealRecordTableHeadView.h"
#import "CDealRecordTableSectionHeadView.h"
#import "CDealRecordViewController.h"
#import "RESideMenu.h"
#import "UIBarButtonItem+Addition.h"
#import "UIViewController+Helper.h"
#import "YTTradeModel.h"

static NSString* CellIdentifier = @"DealRecordViewCellIdentifier";

@interface CDealRecordViewController () <UITableViewDelegate,
    UITableViewDataSource> {
    UITableView* tradeTableView;
}
@property (strong, nonatomic) NSMutableArray* dataArray;
@end

@implementation CDealRecordViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"收款";
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    }
    if ([YTUsr usr].type == LoginViewTypeBusiness) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账户余额" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    }

    CDealRecordTableHeadView* headView = [[CDealRecordTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 80)];
    [self.view addSubview:headView];
    // tradeTableView
    tradeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, kDeviceWidth, KDeviceHeight - 80) style:UITableViewStylePlain];
    tradeTableView.rowHeight = 70;
    tradeTableView.delegate = self;
    tradeTableView.dataSource = self;
    tradeTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tradeTableView];

    [tradeTableView registerClass:[CDealRecordTableCell class] forCellReuseIdentifier:CellIdentifier];

    wSelf(wSelf);
    headView.selectBlock = ^(NSInteger selectIndex) {
        YTPayType payType = selectIndex == 0 ? YTPayTypeZfb : YTPayTypeWechat;
        [wSelf toDealRecordCollecionViewControllerPayType:payType];
    };

    [self setExtraCellLineHidden:tradeTableView];

    [tradeTableView addYTPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [tradeTableView addYTInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    tradeTableView.showsInfiniteScrolling = NO;
    [tradeTableView triggerPullToRefresh];

    // checkUpdate
    //    [ApplyUntil checkVersionUpdate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    self.requestURL = [YTUsr usr].type == LoginViewTypeAsstanter ? saleTradeURL : tradeURL;
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        YTTradeModel* tradeModel = (YTTradeModel*)parserObject;
        if (!operation.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:tradeModel.tradeSet.records];
        }
        else {
            [_dataArray addObjectsFromArray:tradeModel.tradeSet.records];
        }
        [tradeTableView reloadData];
        if (tradeModel.tradeSet.totalCount > _dataArray.count) {
            tradeTableView.showsInfiniteScrolling = YES;
        }
        else {
            tradeTableView.showsInfiniteScrolling = NO;
        }
    }
    else {
    }
    if (!operation.isLoadingMore) {
        [tradeTableView.pullToRefreshView stopAnimating];
    }
    else {
        [tradeTableView.infiniteScrollingView stopAnimating];
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
    return 40;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    CDealRecordTableSectionHeadView* headView = [[CDealRecordTableSectionHeadView alloc] init];
    headView.titleLabel.text = @"订单记录";
    return headView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CDealRecordTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row < _dataArray.count) {
        YTTrade* trade = (YTTrade*)[_dataArray objectAtIndex:indexPath.row];
        [cell configDealTableCellWithIntroModel:trade];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < _dataArray.count) {
        YTTrade* trade = [_dataArray objectAtIndex:indexPath.row];
        CDealRecordDetailViewController* dealRecordDetailVC = [[CDealRecordDetailViewController alloc] init];
        dealRecordDetailVC.trade = trade;
        __weak __typeof(self) weakSelf = self;
        dealRecordDetailVC.refundBlock = ^() {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf fetchDataWithIsLoadingMore:NO];
        };
        [self.navigationController pushViewController:dealRecordDetailVC animated:YES];
    }
}
#pragma mark - Private methods
- (void)toDealRecordCollecionViewControllerPayType:(YTPayType)paytype
{
    CDealRecordCollecionViewController* dealRecordCollecionVC = [[CDealRecordCollecionViewController alloc] init];
    dealRecordCollecionVC.payType = paytype;
    [self.navigationController pushViewController:dealRecordCollecionVC animated:YES];
}

#pragma mark - Navigation
- (void)leftDrawerButtonPress:(id)sender
{
}
- (void)didRightBarButtonItemAction:(id)sender
{
    CDealRecordBlanceiewController* dealRecordBlanceieVC = [[CDealRecordBlanceiewController alloc] init];
    dealRecordBlanceieVC.navigationItem.title = @"账户余额";
    [self.navigationController pushViewController:dealRecordBlanceieVC animated:YES];
}
@end
