
#import "MoneyHbDetailViewController.h"
#import "UIViewController+Helper.h"
#import "MoneyHbDetailHeadView.h"
#import "YTLrTextView.h"
#import "MoneyHongbaoReceiveTableCell.h"
#import "UINavigationBar+Awesome.h"
#import "UIBarButtonItem+Addition.h"
#import "YTVipManageModel.h"
#import "YTPsqptHbListModel.h"
#import "MBProgressHUD+Add.h"

#define NAVBAR_CHANGE_POINT 50

static NSString* CellIdentifier = @"MoneyHbDetailCellIdentifier";

@interface MoneyHbDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) MoneyHbDetailHeadView* headView;
@end

@implementation MoneyHbDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"拼手气/普通红包详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"yt_navigation_backBtn_white_normal.png"] highlightImage:[UIImage imageNamed:@"yt_navigation_backBtn_high.png"] target:self action:@selector(didLeftBarButtonItemAction:)];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
        NSShadowAttributeName : [NSShadow new] }];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
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
    self.requestParas = @{
                          @"publishId" : self.vipManage.vipId,
                          @"pageNum" : @(currPage),
                          isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = getPsqptHbListByPublishIdURL;
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
    YTPsqptHbListModel* psqptHbModel = (YTPsqptHbListModel*)parserObject;
    if (!operation.isLoadingMore) {
        self.dataArray = [NSMutableArray arrayWithArray:psqptHbModel.psqptHbSet.records];
    }
    else {
        [self.dataArray addObjectsFromArray:psqptHbModel.psqptHbSet.records];
    }
    [self.tableView reloadData];
    if (psqptHbModel.psqptHbSet.totalCount > _dataArray.count) {
        self.tableView.showsInfiniteScrolling = YES;
    }
    else {
        self.tableView.showsInfiniteScrolling = NO;
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
    return 45;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    YTLrTextView* sectionHeadView = [[YTLrTextView alloc] init];
    sectionHeadView.backgroundColor = [UIColor hexFloatColor:@"f1f1f1"];
    sectionHeadView.leftLabel.text = [NSString stringWithFormat:@"%@/%@个红包共%.2f元",@(self.vipManage.getNum),@(self.vipManage.hongbaoNum),self.vipManage.totalSum/100.] ;
    if (self.vipManage.getNum == self.vipManage.hongbaoNum) {
        sectionHeadView.rightLabel.text = @"已领完";
    }else{
        sectionHeadView.rightLabel.text = [NSString stringWithFormat:@"剩余%@",@(self.vipManage.hongbaoNum-self.vipManage.getNum)];
    }
    
    return sectionHeadView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MoneyHongbaoReceiveTableCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_dataArray.count > indexPath.row) {
        YTPsqptHb *psqpHb = _dataArray[indexPath.row];
        [cell configKMoneyHongbaoReceiveCellWithModel:psqpHb];
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    UIColor* color = [UIColor colorWithRed:253.0 / 255.0 green:65.0 / 255.0 blue:77.0 / 255.0 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    }
    else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark - Navigation
- (void)didLeftBarButtonItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UIImage* bgImage = [UIImage imageNamed:@"yt_background_red.png"];
    UIView* redBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 260)];
    redBgView.layer.contents = (id)bgImage.CGImage;
    ;
    [self.view addSubview:redBgView];
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    _tableView.tableHeaderView = ({
        _headView = [[MoneyHbDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 255)];
        [_headView configHbDetailWithModel:self.vipManage];
        _headView;
    });
    
     [self fetchDataWithIsLoadingMore:NO];
    wSelf(wSelf);
    // loadingMore
    [self.tableView addYTInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    self.tableView.showsInfiniteScrolling = NO;
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[MoneyHongbaoReceiveTableCell class]
            forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeAll;
}
#endif

@end
