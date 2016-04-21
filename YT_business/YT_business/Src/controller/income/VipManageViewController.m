#import "VipManageViewController.h"
#import "UIViewController+Helper.h"
#import "UIBarButtonItem+Addition.h"
#import "RESideMenu.h"
#import "MBProgressHUD+Add.h"
#import "VipManageTableCell.h"
#import "VipManageDistributeView.h"
#import "UIImage+HBClass.h"
#import "DistributeKindViewController.h"
#import "DistributeMoneyViewController.h"
#import "DistributeNoticeViewController.h"
#import "KindHbDetailViewController.h"
#import "MoneyHbDetailViewController.h"
#import "YTVipManageModel.h"
#import "VipShowTextView.h"
#import "HbEmptyView.h"


static NSString* CellIdentifier = @"VipManageCellIdentifier";

@interface VipManageViewController () <UITableViewDelegate,
    UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* distributeBtn;
@property (nonatomic, strong) VipManageDistributeView* distributeView;
@property (nonatomic, strong) HbEmptyView* emptyView;
@property (nonatomic, strong) NSMutableArray* dataArray;

@end

@implementation VipManageViewController
#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"会员管理";
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
    self.requestParas = @{@"shopId" : [YTUsr usr].shop.shopId,
                          @"pageSize" : @(20),
                           @"pageNum" : @(currPage),
                           isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = getPublishListURL;
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
    YTVipManageModel* manageModel = (YTVipManageModel*)parserObject;
    if (!operation.isLoadingMore) {
        self.dataArray = [NSMutableArray arrayWithArray:manageModel.manageSet.records];
    }
    else {
        [self.dataArray addObjectsFromArray:manageModel.manageSet.records];
    }
    [self.tableView reloadData];
    self.emptyView.hidden = self.dataArray.count > 0;
    if (manageModel.manageSet.totalCount > _dataArray.count) {
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
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    VipManageTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (indexPath.section < _dataArray.count) {
        YTVipManage *vipManage = _dataArray[indexPath.section];
         [cell configVipManageCellWithModel:vipManage];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section > _dataArray.count) {
        return;
    }
            YTVipManage *vipManage = _dataArray[indexPath.section];
    if (vipManage.hongbaoLx == YTDistributeHongbaoTypeXjhb) {
        KindHbDetailViewController *kindHbDetailVC = [[KindHbDetailViewController alloc] init];
        kindHbDetailVC.vipManage = vipManage;
        [self.navigationController pushViewController:kindHbDetailVC animated:YES];
    }
    else if (vipManage.hongbaoLx == YTDistributeHongbaoTypeNotice) {
            [VipShowTextView showText:vipManage.content];
    }
    else {
        MoneyHbDetailViewController *moneyHbDetailVC = [[MoneyHbDetailViewController alloc] init];
        moneyHbDetailVC.vipManage = vipManage;
        [self.navigationController pushViewController:moneyHbDetailVC animated:YES];
    }
}

#pragma mark - Event response
- (void)distributePush:(id)sender
{
    if (!_distributeView) {
        _distributeView = [[VipManageDistributeView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, CGRectGetHeight(self.view.bounds) - 50)];
        [self.view insertSubview:_distributeView belowSubview:_distributeBtn];
        
        __weak __typeof(self)weakSelf = self;
        _distributeView.selectBlock = ^(NSInteger selectIndex){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (selectIndex == 0) {
                DistributeKindViewController *distributeKindVC = [[DistributeKindViewController alloc] init];
                [strongSelf.navigationController pushViewController:distributeKindVC animated:YES];
            }else if (selectIndex == 1) {
                DistributeMoneyViewController *distributeMoneyVC = [[DistributeMoneyViewController alloc] init];
                 [strongSelf.navigationController pushViewController:distributeMoneyVC animated:YES];
            }else{
                DistributeNoticeViewController *distributeNoticeVC = [[DistributeNoticeViewController alloc] init];
                [strongSelf.navigationController pushViewController:distributeNoticeVC animated:YES];
            }
        };
    }
    if (_distributeView.isShow) {
        [_distributeView dismiss];
    }
    else {
        [_distributeView show];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
     [self.view addSubview:self.emptyView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.distributeBtn];
    [self setExtraCellLineHidden:self.tableView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-50);
    }];
    [_distributeBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(_tableView.bottom);
        make.left.and.bottom.right.mas_equalTo(self.view);
    }];
    
     wSelf(wSelf);
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
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.rowHeight = 100;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[VipManageTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (UIButton*)distributeBtn
{
    if (!_distributeBtn) {
        _distributeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _distributeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_distributeBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_distributeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_distributeBtn setTitle:@"发布推送" forState:UIControlStateNormal];
        [_distributeBtn addTarget:self action:@selector(distributePush:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _distributeBtn;
}
- (HbEmptyView*)emptyView
{
    if (!_emptyView) {
        _emptyView = [[HbEmptyView alloc] init];
        _emptyView.iconImageView.image = [UIImage imageNamed:@"hb_emptu_icon.png"];
        _emptyView.titleLabel.text = @"您还没有给您的会员发过福利哦";
        _emptyView.displayArrow = YES;
        _emptyView.hidden = YES;
        NSString* description = @"赶紧发个红包试试吧!";
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:description];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(4, 2)];
        _emptyView.descriptionLabel.attributedText = str;
    }
    return _emptyView;
}

@end
