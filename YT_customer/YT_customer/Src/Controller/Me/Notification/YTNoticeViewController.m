#import "YTNoticeViewController.h"
#import "UIViewController+Helper.h"
#import "YTNoticeTableCell.h"
#import "SVPullToRefresh.h"
#import "NSDate+TimeInterval.h"
#import "MBProgressHUD+Add.h"
#import "YTNoticeModel.h"
#import "YTPublishListModel.h"
#import "UserMationMange.h"
#import "KindHbDetailViewController.h"
#import "OpenHongbaoViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MoneyHbDetailViewController.h"
#import "YTXjswHbListModel.h"

static NSString* CellIdentifier = @"NoticeCellIdentifier";

@interface YTNoticeViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableDictionary* offscreenCells;
@property (strong, nonatomic) NSMutableArray* dataArray;
@end

@implementation YTNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"消息";
    _offscreenCells = [[NSMutableDictionary alloc] init];
    [self initializePageSubviews];
   
    if (self.noticeType == YTNoticeViewControllerTypeSystem) {
         [self.tableView triggerPullToRefresh];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_reset];
    if (self.noticeType == YTNoticeViewControllerTypeShop) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView triggerPullToRefresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    NSInteger currPage = [[self.requestParas objectForKey:@"pageNum"] integerValue];
    if (!isLoadingMore) {
        currPage = 1;
    }
    else {
        ++currPage;
    }
    if (self.noticeType == YTNoticeViewControllerTypeSystem) {
        self.requestParas = @{ @"pageSize" : @(20),
                               @"pageNum" : @(currPage),
                               isLoadingMoreKey : @(isLoadingMore)};
        self.requestURL = YC_Request_MessageList;
    }else{
        if (!self.xjswHb.shop.shopId) {
            return;
        }
        self.requestParas = @{@"shopId"  :self.xjswHb.shop.shopId,
                              @"pageSize" : @(20),
                               @"pageNum" : @(currPage),
                               isLoadingMoreKey : @(isLoadingMore)};
        self.requestURL = YC_Request_GetPublishList;
    }
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
        if ([request.url isEqualToString:YC_Request_MessageList]) {
            YTNoticeModel* noticeModel = (YTNoticeModel*)parserObject;
            if (!request.isLoadingMore) {
                _dataArray = [[NSMutableArray alloc] initWithArray:noticeModel.noticeSet.records];
            }
            else {
                [_dataArray addObjectsFromArray:noticeModel.noticeSet.records];
            }
            if (noticeModel.noticeSet.totalCount > _dataArray.count) {
                self.tableView.showsInfiniteScrolling = YES;
            }
            else {
                self.tableView.showsInfiniteScrolling = NO;
            }

        }else if ([request.url isEqualToString:YC_Request_GetPublishList]){
            YTPublishListModel* publishModel = (YTPublishListModel*)parserObject;
            if (!request.isLoadingMore) {
                _dataArray = [[NSMutableArray alloc] initWithArray:publishModel.publishSet.records];
            }
            else {
                [_dataArray addObjectsFromArray:publishModel.publishSet.records];
            }
            if (publishModel.publishSet.totalCount > _dataArray.count) {
                self.tableView.showsInfiniteScrolling = YES;
            }
            else {
                self.tableView.showsInfiniteScrolling = NO;
            }
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
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* reuseIdentifier = CellIdentifier;
    YTNoticeTableCell* cell = [self.offscreenCells objectForKey:reuseIdentifier];
    if (!cell) {
        cell = [[YTNoticeTableCell alloc] init];
        [self.offscreenCells setObject:cell forKey:reuseIdentifier];
    }

    // 用indexPath对应的数据内容来配置cell，例如：
    if (self.noticeType == YTNoticeViewControllerTypeSystem) {
        YTNotice *notice = _dataArray[indexPath.row];
        [cell configNoticeCellWithModel:notice];
    }else {
        YTPublish *publish = _dataArray[indexPath.row];
        [cell configNoticeCellWithPublishModel:publish];
    }
    
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
    if (self.noticeType == YTNoticeViewControllerTypeSystem) {
        YTNotice *notice = _dataArray[indexPath.row];
        [cell configNoticeCellWithModel:notice];
    }else {
        YTPublish *publish = _dataArray[indexPath.row];
        [cell configNoticeCellWithPublishModel:publish];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.noticeType == YTNoticeViewControllerTypeSystem) {
        return;
    }
    if (_dataArray.count < indexPath.row) {
        return;
    }
    YTPublish *publish = _dataArray[indexPath.row];
    if ([publish.currUserReadYN isEqualToString:@"N"]) {
        self.requestParas = @{@"publishId" : publish.pId};
        self.requestURL = YC_Request_ReadMessage;
    }
    if (publish.hongbaoLx == YTDistributeHongbaoTypeXjhb) {
        KindHbDetailViewController *kindHbDetailVC = [[KindHbDetailViewController alloc] init];
        kindHbDetailVC.publish = publish;
        [self.navigationController pushViewController:kindHbDetailVC animated:YES];
    }else if (publish.hongbaoLx == YTDistributeHongbaoTypePsqhb ||
              publish.hongbaoLx == YTDistributeHongbaoTypePthb) {
        if ([publish.currUserReviceYN isEqualToString:@"Y"] ||
            publish.getNum == publish.hongbaoNum) {
            MoneyHbDetailViewController* moneyHbDetailVC = [[MoneyHbDetailViewController alloc] init];
            moneyHbDetailVC.publish = publish;
            moneyHbDetailVC.getNum = publish.getNum;
            moneyHbDetailVC.amount = publish.currUserReviceAmount;
            [self.navigationController pushViewController:moneyHbDetailVC animated:YES];
        }else{
            OpenHongbaoViewController *openHongbaoVC = [[OpenHongbaoViewController alloc] init];
            openHongbaoVC.publish = publish;
            [self.navigationController pushViewController:openHongbaoVC animated:YES];
        }
    }
}

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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), KDeviceHeight) style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.estimatedRowHeight = 60.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YTNoticeTableCell class] forCellReuseIdentifier:CellIdentifier];
        __weak typeof(self) weakSelf = self;
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
