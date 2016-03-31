#import "MoneyHbDetailViewController.h"
#import "UIViewController+Helper.h"
#import "MoneyHbDetailHeadView.h"
#import "MoneyHongbaoReceiveTableCell.h"
#import "UINavigationBar+Awesome.h"
#import "UIBarButtonItem+Addition.h"
#import "RGLrTextView.h"
#import "YTPublishListModel.h"
#import "UserMationMange.h"
#import "SVPullToRefresh.h"
#import "MBProgressHUD+Add.h"
#import "YTPsqptHbListModel.h"
#import "YTNoticeViewController.h"

#define NAVBAR_CHANGE_POINT 50

static NSString* CellIdentifier = @"MoneyHbDetailCellIdentifier";

@interface MoneyHbDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) MoneyHbDetailHeadView* headView;
@property (nonatomic, strong) UILabel* receiveLabel;
@end

@implementation MoneyHbDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"拼手气/普通红包详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"yt_navigation_backBtn_normal02.png"] highlightImage:[UIImage imageNamed:@"yt_navigation_backBtn_high02.png"] target:self action:@selector(didLeftBarButtonItemAction:)];

    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
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
        @"publishId" : self.publish.pId,
        @"pageNum" : @(currPage),
        isLoadingMoreKey : @(isLoadingMore)
    };
    self.requestURL = YC_Request_GetPsqptHbListByPublishId;
}
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
        if ([request.url isEqualToString:YC_Request_GetPsqptHbListByPublishId]) {
            YTPsqptHbListModel* psqptHbModel = (YTPsqptHbListModel*)parserObject;
            if (!request.isLoadingMore) {
                _dataArray = [[NSMutableArray alloc] initWithArray:psqptHbModel.psqptHbSet.records];
            }
            else {
                [_dataArray addObjectsFromArray:psqptHbModel.psqptHbSet.records];
            }
            if (psqptHbModel.psqptHbSet.totalCount > _dataArray.count) {
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
    UIView* sectionHeadView = [[UIView alloc] init];
    sectionHeadView.backgroundColor = CCCUIColorFromHex(0xf1f1f1);
    [sectionHeadView addSubview:self.receiveLabel];
    self.receiveLabel.text = [NSString stringWithFormat:@"已领取%@/%@个", @(self.getNum), @(self.publish.hongbaoNum)];
    return sectionHeadView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    MoneyHongbaoReceiveTableCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_dataArray.count > indexPath.row) {
        YTPsqptHb* psqpHb = _dataArray[indexPath.row];
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
    for (id viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[YTNoticeViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
            return;
        }
    }
    
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
        BOOL isFinish = self.getNum == self.publish.hongbaoNum && [self.publish.currUserReviceYN isEqualToString:@"N"] && self.amount == 0;
        _headView = [[MoneyHbDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, isFinish ? 250 : 350)];
        [_headView configHbDetailWithModel:self.publish];
        if (isFinish) {
            [_headView hideCostView];
            _headView.mesLabel.text = @"手慢了,红包已经被抢光了哦~";
        }
        else {
            _headView.costLabel.attributedText = [self costAttributedWithAmount:_amount];
        }
        _headView;
    });
    [self fetchDataWithIsLoadingMore:NO];
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
        __weak __typeof(self) weakSelf = self;
        [_tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf fetchDataWithIsLoadingMore:YES];
        }];
        _tableView.showsInfiniteScrolling = NO;
    }
    return _tableView;
}
- (UILabel*)receiveLabel
{
    if (!_receiveLabel) {
        _receiveLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kDeviceWidth - 30, 30)];
        _receiveLabel.textColor = CCCUIColorFromHex(0x666666);
        _receiveLabel.font = [UIFont systemFontOfSize:14];
        _receiveLabel.numberOfLines = 1;
    }
    return _receiveLabel;
}
- (NSAttributedString*)costAttributedWithAmount:(NSInteger)amount
{
    NSString* costValue =[NSString stringWithFormat:@"%.2f元", amount / 100.];
    
    NSMutableAttributedString* mutableAttributedStr =
    [[NSMutableAttributedString alloc]
     initWithString:costValue];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:14]
                                 range:NSMakeRange(costValue.length-1, 1)];
    return [[NSAttributedString alloc]
            initWithAttributedString:mutableAttributedStr];
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeAll;
}
#endif
@end
