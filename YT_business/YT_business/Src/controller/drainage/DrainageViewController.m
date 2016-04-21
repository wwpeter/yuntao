
#import "YTDrainageModel.h"
#import "DrainageViewController.h"
#import "YTNavigationController.h"
#import "CreateHbViewController.h"
#import "HbEmptyView.h"
#import "DrainageIntroModel.h"
#import "DrainageTableCell.h"
#import "DrainageDetailViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "UserMationMange.h"
#import "MBProgressHUD+Add.h"
#import "YTUpdateShopInfoModel.h"
#import "VerifyCodeViewController.h"
#import "HbDetailViewController.h"
#import "RESideMenu.h"
#import "YTHttpClient.h"
#import "HbPaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "UIViewController+Helper.h"
#import "YTStatisticsHeadView.h"
#import "YTSellHongbaoIndexModel.h"

static NSString* CellIdentifier = @"DrainageCellIdentifier";

@interface DrainageViewController () <UITableViewDelegate,
    UITableViewDataSource, VerifyCodeViewControllerDelegate> {
    //hongbaoListURL
    UITableView* drainageTableView;
}

@property (strong, nonatomic) HbEmptyView* emptyView;
@property (strong, nonatomic) YTStatisticsHeadView* headView;
@property (strong, nonatomic) NSMutableArray* dataArray;
@end

@implementation DrainageViewController

#pragma mark - Life cycle
- (void)dealloc
{
    drainageTableView.delegate = nil;
    drainageTableView.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"我要引流";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* rightBarImage = [UIImage imageNamed:@"yt_navigation_scan.png"];
    UIImage* rightBarImageHigl = [UIImage imageNamed:@"yt_navigation_scan_high.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:rightBarImage highlightImage:rightBarImageHigl target:self action:@selector(didRightBarButtonItemAction:)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    self.dataArray = [[NSMutableArray alloc] init];
    [self initializePageSubviews];

    wSelf(wSelf);
    // refresh
    [drainageTableView addPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [drainageTableView addInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    drainageTableView.showsInfiniteScrolling = NO;
    [drainageTableView triggerPullToRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hbSoldOutNotification:)
                                                 name:kHbSoldOutNotification
                                               object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchIndexData
{
    self.requestParas = @{};
    self.requestURL = drainageHongbaoIndexURL;
}
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    int currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        [self fetchIndexData];
        currPage = 1;
    }
    else {
        ++currPage;
    }
    self.requestParas = @{ @"pageSize" : @(20),
        @"pageNum" : @(currPage),
        isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = drainageListURL;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:drainageHongbaoIndexURL]) {
            YTSellHongbaoIndexModel* sellHbIndexModel = (YTSellHongbaoIndexModel*)parserObject;
            _headView.leftOnView.upLabel.text = [NSString stringWithFormat:@"%@", @(sellHbIndexModel.indexDetail.count)];
            _headView.leftTwView.upLabel.text = [NSString stringWithFormat:@"%@", @(sellHbIndexModel.indexDetail.tou)];
            _headView.rightOnView.upLabel.text = [NSString stringWithFormat:@"%@", @(sellHbIndexModel.indexDetail.ling)];
            _headView.rightTwView.upLabel.text = [NSString stringWithFormat:@"%@", @(sellHbIndexModel.indexDetail.yin)];
        }
        else if ([operation.urlTag isEqualToString:drainageListURL]) {
            YTDrainageModel* drainageModel = (YTDrainageModel*)parserObject;
            if (!operation.isLoadingMore) {
                _dataArray = [NSMutableArray arrayWithArray:drainageModel.drainageSet.records];
            }
            else {
                [_dataArray addObjectsFromArray:drainageModel.drainageSet.records];
            }
            [drainageTableView reloadData];
            if (!operation.isLoadingMore) {
                [drainageTableView.pullToRefreshView stopAnimating];
            }
            else {
                [drainageTableView.infiniteScrollingView stopAnimating];
            }
            if (drainageModel.drainageSet.totalCount > _dataArray.count) {
                drainageTableView.showsInfiniteScrolling = YES;
            }
            else {
                drainageTableView.showsInfiniteScrolling = NO;
            }
            [self showEmptyView];
        }
        else {
            HbPaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbPaySuccessViewController class]];
            paySuccessVC.hideButton = YES;
            paySuccessVC.paySuccessTitle = @"验证成功";
            [self.navigationController pushViewController:paySuccessVC animated:YES];
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}

#pragma mark - UITableViewDelegate
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
    return 10;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    DrainageTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section < _dataArray.count) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        YTDrainage* drainage = (YTDrainage*)[_dataArray objectAtIndex:indexPath.section];
        [cell configDrainageCellWithModel:drainage];
    }

    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section < _dataArray.count) {
        YTDrainage* drainage = (YTDrainage*)[_dataArray objectAtIndex:indexPath.section];
        if (drainage.status == YTDRAINAGESTATUS_PRECONFIRMSHOP) {
            //            HbDetailViewController *hbDetailVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbDetailViewController class]];
            //            hbDetailVC.drainageDetail = drainage.;
            //            [self.navigationController pushViewController:hbDetailVC animated:YES];
        }
        else {
        }
        DrainageDetailViewController* drainageDetailVC = (DrainageDetailViewController*)[StoryBoardUtilities viewControllerForMainStoryboard:[DrainageDetailViewController class]];
        drainageDetailVC.drainage = drainage;
        [self.navigationController pushViewController:drainageDetailVC animated:YES];
    }
}

#pragma mark - VerifyCodeViewControllerDelegate
- (void)verifyCodeViewController:(VerifyCodeViewController*)controller didverifyResult:(NSString*)result
{
    self.requestParas = @{ loadingKey : @(YES) };
    self.requestURL = result;
}
#pragma mark - Event response
- (void)createHongBao:(id)sender
{
    if ([YTUsr usr].shop.status == 1) {
        [self presentCreateHbViewController];
    }
    else {
        wSelf(wSelf);
        [[UserMationMange sharedInstance] updateUserShopInfpSuccess:^(NSObject* parserObject) {
            YTUpdateShopInfoModel* shopModel = (YTUpdateShopInfoModel*)parserObject;
            if (shopModel.shopInfo.shop.status == 1) {
                [wSelf presentCreateHbViewController];
            }
            else {
                [wSelf showAlert:@"您还未通过审核哦~" title:@""];
            }
        } failure:^(NSString* errMessage) {
            [MBProgressHUD showError:errMessage toView:self.view];
        }];
    }
}
#pragma mark - Private methods
- (void)showEmptyView
{
    if (self.dataArray.count == 0) {
        self.emptyView.hidden = NO;
    }
    else {
        self.emptyView.hidden = YES;
    }
}
- (void)presentCreateHbViewController
{
    UIStoryboard* stryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateHbViewController* createVC = [stryBoard instantiateViewControllerWithIdentifier:@"CreateHbViewController"];
    createVC.view.tintColor = [UIColor redColor];
    __weak typeof(self) wSelf = self;
    createVC.successBlock = ^{
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf->drainageTableView triggerPullToRefresh];
    };
    YTNavigationController* navigationVC = [[YTNavigationController alloc] initWithRootViewController:createVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}
#pragma mark - Notification Response
- (void)hbSoldOutNotification:(NSNotification*)notification
{
    [drainageTableView triggerPullToRefresh];
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    VerifyCodeViewController* veriyCodeVC = [[VerifyCodeViewController alloc] init];
    veriyCodeVC.delegate = self;
    [self.navigationController pushViewController:veriyCodeVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    drainageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    drainageTableView.rowHeight = 70;
    drainageTableView.delegate = self;
    drainageTableView.dataSource = self;
    drainageTableView.backgroundColor = [UIColor clearColor];
    drainageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    drainageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [drainageTableView registerClass:[DrainageTableCell class] forCellReuseIdentifier:CellIdentifier];
    drainageTableView.tableHeaderView = ({
        _headView = [[YTStatisticsHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
        _headView;
    });

    [self.view addSubview:self.emptyView];
    [self.view addSubview:drainageTableView];
    [self setExtraCellLineHidden:drainageTableView];

    UIButton* createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createBtn.backgroundColor = YTDefaultRedColor;
    createBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createBtn setTitle:@"创建红包" forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(createHongBao:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];

    [_emptyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [drainageTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-50);
    }];
    [createBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(drainageTableView.bottom);
        make.left.and.bottom.right.mas_equalTo(self.view);
    }];
}
#pragma mark - Getters & Setters

- (HbEmptyView*)emptyView
{
    if (!_emptyView) {
        _emptyView = [[HbEmptyView alloc] init];
        _emptyView.iconImageView.image = [UIImage imageNamed:@"hb_emptu_icon.png"];
        _emptyView.titleLabel.text = @"没有红包";
        _emptyView.displayArrow = YES;
        NSString* description = @"点击这里创建红包吧!";
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:description];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 2)];
        _emptyView.descriptionLabel.attributedText = str;
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
