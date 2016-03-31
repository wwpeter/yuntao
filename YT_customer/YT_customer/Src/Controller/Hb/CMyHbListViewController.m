
#import "CMyHbListViewController.h"
#import "ReceiveSuccessHeadView.h"
#import "HbIntroTableCell.h"
#import "UIImage+HBClass.h"
#import "HbIntroModel.h"
#import "CMyHbDetailViewController.h"
#import "StoryBoardUtilities.h"
#import "SVPullToRefresh.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"

static NSString *CellIdentifier = @"MyHbListCellIdentifier";

@interface CMyHbListViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;

@end

@implementation CMyHbListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"我的红包";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeData];
    self.tableView.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70;
    [self.tableView registerClass:[HbIntroTableCell class] forCellReuseIdentifier:CellIdentifier];
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];

    
    [self.tableView triggerPullToRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Data
- (void)insertRowAtTop
{
    NSDictionary* parameters = @{ @"pageNum" : @1,
                                  @"pageSize" : @20};
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_MyHongbaoList parameters:parameters success:^(id responseData) {
        id object = responseData[@"data"][@"records"];
        [weakSelf pullToRefreshViewWithObject:object];
    } failure:^(NSString *errorMessage) {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
        [MBProgressHUD showError:@"连接失败!" toView:self.view];
    }];
}
- (void)insertRowAtBottom
{
     NSDictionary* parameters = @{ @"pageNum" : @(_page),
                                   @"pageSize" : @20};
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_MyHongbaoList parameters:parameters success:^(id responseData) {
        id object = responseData[@"data"][@"records"];
        [weakSelf loadMoreViewWithObject:object];

    } failure:^(NSString *errorMessage) {
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)pullToRefreshViewWithObject:(id)object
{
    [self.dataArray removeAllObjects];
    self.page = 2;
    for (NSDictionary *dic in object) {
        HbIntroModel *hiModel = [[HbIntroModel alloc] initWithHbIntroDictionary:dic];
        [self.dataArray addObject:hiModel];
    }
    if (_dataArray.count >= 20) {
        __strong __typeof(self)strongSelf = self;
        [strongSelf.tableView addInfiniteScrollingWithActionHandler:^{
            [self insertRowAtBottom];
        }];
    }
    [self.tableView reloadData];
    [self.tableView.infiniteScrollingView beginScrollAnimating];
    [self.tableView.pullToRefreshView stopAnimating];
}
- (void)loadMoreViewWithObject:(id)object
{
    if ([object count] == 0) {
        [self.tableView.infiniteScrollingView endScrollAnimating];
    } else{
        self.page ++;
        for (NSDictionary *dic in object) {
            HbIntroModel *hiModel = [[HbIntroModel alloc] initWithHbIntroDictionary:dic];
            [self.dataArray addObject:hiModel];
        }
        [self.tableView reloadData];
    }
    [self.tableView.infiniteScrollingView stopAnimating];
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HbIntroTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    HbIntroModel *introModel = _dataArray[indexPath.section];
    [cell configHbIntroCellWithIntroModel:introModel];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     HbIntroModel *introModel = _dataArray[indexPath.section];
    CMyHbDetailViewController *hbDetailVC = [StoryBoardUtilities viewControllerForMainStoryboard:[CMyHbDetailViewController class]];
    hbDetailVC.hbId = introModel.hbId;
    hbDetailVC.hbtype = HbDetailTypeMyHb;
    [self.navigationController pushViewController:hbDetailVC animated:YES];
}

#pragma mark - Page subviews
- (void)initializeData
{
    _dataArray = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i<20; i++) {
//        HbIntroModel *hiModel = [[HbIntroModel alloc] initWithHbIntroDictionary:nil];
//        [_dataArray addObject:hiModel];
//    }
}


#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
