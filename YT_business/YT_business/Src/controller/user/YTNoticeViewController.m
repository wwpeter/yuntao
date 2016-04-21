#import "YTNoticeViewController.h"
#import "YTNoticeTableCell.h"
#import "YTNotifyModel.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+Helper.h"
#import "LeftSideDrawerHelper.h"
#import "RESideMenu.h"
#import "UIBarButtonItem+Addition.h"

static NSString* CellIdentifier = @"NoticeCellIdentifier";

@interface YTNoticeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableDictionary* offscreenCells;
@property (strong, nonatomic) NSMutableArray* dataArray;
@end

@implementation YTNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    _offscreenCells = [[NSMutableDictionary alloc] init];
    [self initializePageSubviews];
    [self.tableView triggerPullToRefresh];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
    } else {
        ++ currPage;
    }
    self.requestParas = @{@"pageSize":@(20),
                          @"pageNum":@(currPage),
                          isLoadingMoreKey:@(isLoadingMore)};
    self.requestURL = messageListURL;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
        YTNotifyModel *notifyModel = (YTNotifyModel *)parserObject;
        if (!operation.isLoadingMore) {
            _dataArray = [NSMutableArray arrayWithArray:notifyModel.notifySet.records];
        } else {
            [_dataArray addObjectsFromArray:notifyModel.notifySet.records];
        }
        [self.tableView reloadData];
        if (!operation.isLoadingMore) {
            [self.tableView.pullToRefreshView stopAnimating];
        } else {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
        if (notifyModel.notifySet.totalCount > _dataArray.count) {
            self.tableView.showsInfiniteScrolling = YES;
        } else {
            self.tableView.showsInfiniteScrolling = NO;
        }
    } else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
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
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* reuseIdentifier = CellIdentifier;
    YTNoticeTableCell* cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[YTNoticeTableCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }
    // 用indexPath对应的数据内容来配置cell，例如：
        YTNotifyMessage *notifMessage = _dataArray[indexPath.row];
        [cell configNoticeCellWithModel:notifMessage];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1.0f;
    
    return height;
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
    YTNoticeTableCell* cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    YTNotifyMessage *notifMessage = _dataArray[indexPath.row];
    [cell configNoticeCellWithModel:notifMessage];
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
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), KDeviceHeight) style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.estimatedRowHeight = 60.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YTNoticeTableCell class] forCellReuseIdentifier:CellIdentifier];
        __weak __typeof(self) weakSelf = self;
        [_tableView addYTPullToRefreshWithActionHandler:^{
            if (!weakSelf) {
                return;
            }
            [weakSelf fetchDataWithIsLoadingMore:NO];
        }];
        // loadingMore
        [_tableView addYTInfiniteScrollingWithActionHandler:^{
            if (!weakSelf) {
                return;
            }
            [weakSelf fetchDataWithIsLoadingMore:YES];
        }];
        _tableView.showsInfiniteScrolling = NO;
    }
    return _tableView;
}


@end
