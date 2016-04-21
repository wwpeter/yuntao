
#import "YTPromotionModel.h"
#import "PromotionTableCell.h"
#import "StoryBoardUtilities.h"
#import "PromotionViewController.h"
#import "UIViewController+Helper.h"
#import "UIBarButtonItem+Addition.h"
#import "PromotionHbViewController.h"
#import "PromotionSettingViewController.h"
#import "MBProgressHUD+Add.h"
#import "YTPromotionSettingModel.h"
#import "RESideMenu.h"
#import "HbEmptyView.h"
#import "YTNavigationController.h"
#import "UIImage+HBClass.h"
#import "PromotionTableHeadView.h"
#import "YTBuyHongbaoIndexModel.h"

static NSString* CellIdentifier = @"PromotionViewCellIdentifier";

@interface PromotionViewController () <UITableViewDelegate,
    UITableViewDataSource> {
}

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) HbEmptyView* emptyView;
@property (strong, nonatomic) UIButton* buyMoreButton;

@property (strong, nonatomic) PromotionTableHeadView* headView;
@end

@implementation PromotionViewController

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"我的促销";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    UIImage* rightBarImage = [UIImage imageNamed:@"yt_navigation_setting.png"];
    UIImage* rightBarImageHigl = [UIImage imageNamed:@"yt_navigation_setting_high.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:rightBarImage highlightImage:rightBarImageHigl target:self action:@selector(rightDrawerButtonPress:)];
    self.dataArray = [[NSMutableArray alloc] init];
    [self initializePageSubviews];

    wSelf(wSelf);
    // refresh
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchDataWithIsLoadingMore:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchIndexData
{
    [self.headView startActivityAnimating];
    self.requestParas = @{};
    self.requestURL = buyHongbaoIndexURL;
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
    self.requestURL = buyedHongbaoURL;
}

#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:getPromoteSetURL]) {
        }
        else if ([operation.urlTag isEqualToString:buyHongbaoIndexURL]) {
            [self.headView stopActivityAnimating];
            YTBuyHongbaoIndexModel* buyHbIndexModel = (YTBuyHongbaoIndexModel*)parserObject;
            NSNumber* consumeNum = [NSNumber numberWithFloat:buyHbIndexModel.indexDetail.userConsume / 100.];
            self.headView.consumeLabel.text = [NSStrUtil stringWithNumberDecimalFormat:consumeNum];
            self.headView.statisticsView.leftOnView.upLabel.text = [NSString stringWithFormat:@"%@", @(buyHbIndexModel.indexDetail.num)];
            self.headView.statisticsView.leftTwView.upLabel.text = [NSString stringWithFormat:@"%@", @(buyHbIndexModel.indexDetail.ling)];
            self.headView.statisticsView.rightOnView.upLabel.text = [NSString stringWithFormat:@"%@", @(buyHbIndexModel.indexDetail.remainNum)];
            self.headView.statisticsView.rightTwView.upLabel.text = [NSString stringWithFormat:@"%@", @(buyHbIndexModel.indexDetail.closed)];
        }
        else {

            YTPromotionModel* promotionModel = (YTPromotionModel*)parserObject;
            if (!operation.isLoadingMore) {
                _dataArray = [NSMutableArray arrayWithArray:promotionModel.promotionHongbaoSet.records];
            }
            else {
                [_dataArray addObjectsFromArray:promotionModel.promotionHongbaoSet.records];
            }
            [self.tableView reloadData];
            if (!operation.isLoadingMore) {
                [self.tableView.pullToRefreshView stopAnimating];
            }
            else {
                [self.tableView.infiniteScrollingView stopAnimating];
            }
            if (promotionModel.promotionHongbaoSet.totalCount > _dataArray.count) {
                self.tableView.showsInfiniteScrolling = YES;
            }
            else {
                self.tableView.showsInfiniteScrolling = NO;
            }
            [self showEmptyView];
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
        if ([operation.urlTag isEqualToString:buyHongbaoIndexURL]) {
            [self.headView stopActivityAnimating];
        }
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
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    PromotionTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section < _dataArray.count) {
        YTPromotionHongbao* promotionHongbao = (YTPromotionHongbao*)[_dataArray objectAtIndex:indexPath.section];
        [cell configPromotionTableIntroModel:promotionHongbao];

        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }

    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section < _dataArray.count) {
        YTPromotionHongbao* promotionHongbao = [_dataArray objectAtIndex:indexPath.section];
        PromotionHbViewController* promotionHbVc = [StoryBoardUtilities viewControllerForMainStoryboard:[PromotionHbViewController class]];
        promotionHbVc.promotionHongbao = promotionHongbao;
        [self.navigationController pushViewController:promotionHbVc animated:YES];
    }
}

#pragma mark - Cell delegate
#pragma mark - Event response
- (void)buyMoreButtonClicked:(id)sender
{
    [self showContentViewControllerAtIndex:3];
}

#pragma mark - Public methods
#pragma mark - Private methods
- (void)showEmptyView
{
    if (self.dataArray.count == 0) {
        self.emptyView.hidden = NO;
        self.buyMoreButton.hidden = NO;
    }
    else {
        self.buyMoreButton.hidden = YES;
        self.emptyView.hidden = YES;
    }
}
#pragma mark - Notification Response
#pragma mark - Navigation

- (void)rightDrawerButtonPress:(id)sender
{
    PromotionSettingViewController* settingVC = [[PromotionSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.emptyView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.buyMoreButton];
    [self setExtraCellLineHidden:self.tableView];

    [_emptyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    [_buyMoreButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsZero);
    }];
    //    self.tableView.tableHeaderView = self.yellowHeadView;
    self.tableView.tableHeaderView = ({
        _headView = [[PromotionTableHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 190)];
        _headView.statisticsView.leftOnView.downLabel.text = @"购买数";
        _headView.statisticsView.leftTwView.downLabel.text = @"发放数";
        _headView.statisticsView.rightOnView.downLabel.text = @"剩余数";
        _headView.statisticsView.rightTwView.downLabel.text = @"过期数";
        _headView;
    });
}

#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 120;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[PromotionTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (HbEmptyView*)emptyView
{
    if (!_emptyView) {
        _emptyView = [[HbEmptyView alloc] init];

        //        _emptyView.iconImageView.image = [UIImage imageNamed:@"hb_emptu_icon.png"];
        _emptyView.iconImageView.image = [UIImage new];
        _emptyView.titleLabel.text = @"您还没有促销红包";
        _emptyView.displayArrow = YES;
        NSString* description = @"点击这里购买红包吧!";
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:description];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 2)];
        _emptyView.descriptionLabel.attributedText = str;
    }
    return _emptyView;
}
- (UIButton*)buyMoreButton
{
    if (!_buyMoreButton) {
        _buyMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyMoreButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_buyMoreButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_buyMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyMoreButton setTitle:@"购买红包" forState:UIControlStateNormal];
        [_buyMoreButton addTarget:self action:@selector(buyMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyMoreButton;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
