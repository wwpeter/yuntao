#import "CDealRecordBlanceiewDetailViewController.h"
#import "CDealRecordTableCell.h"
#import "UIViewController+Helper.h"
#import "YTAccountDetailModel.h"


static NSString *CellIdentifier = @"DealRecordBlanceiewIdentifier";

@interface CDealRecordBlanceiewDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation CDealRecordBlanceiewDetailViewController

#pragma mark - Life cycle
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
    self.navigationItem.title = @"账单明细";
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore {
    int currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        currPage = 1;
    } else {
        ++ currPage;
    }
    self.requestParas = @{@"pageSize":@(20),
                          @"pageNum":@(currPage),
                          isLoadingMoreKey:@(isLoadingMore)};
    self.requestURL = accountDetailListURL;
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
        YTAccountDetailModel *accountModel = (YTAccountDetailModel *)parserObject;
        if (!operation.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:accountModel.accountDetailSet.records];
        } else {
            [_dataArray addObjectsFromArray:accountModel.accountDetailSet.records];
        }
        [self.tableView reloadData];
        if (accountModel.accountDetailSet.totalCount > _dataArray.count) {
            self.tableView.showsInfiniteScrolling = YES;
        } else {
            self.tableView.showsInfiniteScrolling = NO;
        }
    } else {
        
    }
    if (!operation.isLoadingMore) {
        [self.tableView.pullToRefreshView stopAnimating];
    } else {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDealRecordTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row < _dataArray.count) {
        YTAccountDetail *accountDetail = (YTAccountDetail *)[_dataArray objectAtIndex:indexPath.row];
        [cell configDealTableCellWithAccountDetailModel:accountDetail];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    return cell;
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    wSelf(wSelf);
    [self setExtraCellLineHidden:self.tableView];
    
    [self.tableView addYTPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [self.tableView addYTInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return ;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    self.tableView.showsInfiniteScrolling = NO;
    [self.tableView triggerPullToRefresh];
}
#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[CDealRecordTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}

@end
