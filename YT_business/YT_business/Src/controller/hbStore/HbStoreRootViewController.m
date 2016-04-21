
#import "YTTradeModel.h"
#import "HbStoreStatsView.h"
#import "StoryBoardUtilities.h"
#import "UIBarButtonItem+Addition.h"
#import "HbStoreRootViewController.h"
#import "HBStoreListViewController.h"
#import "HbSelectListViewController.h"
#import "HbOrderConfirmViewController.h"
#import "YTHongbaoStoreHelper.h"
#import "YTOrderModel.h"
#import "RESideMenu.h"
#import "HBStoreSearchViewController.h"

@interface HbStoreRootViewController ()
<
ViewPagerDelegate,
ViewPagerDataSource,
HbStoreStatsViewDelegate,
HBStoreListViewControllerDelegate,
HbSelectListViewControllerDelegate
> {
}
@property (strong, nonatomic) NSArray *classArray;
@property (strong, nonatomic) HbStoreStatsView *statsView;
@property (strong, nonatomic) HBStoreListViewController *storeRecommVC;
@property (strong, nonatomic) HBStoreListViewController *storeNearbyVC;
@end


@implementation HbStoreRootViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [NOTIFICENTER removeObserver:self];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"红包商城";
        self.view.backgroundColor =  CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    UIImage *norImage = [UIImage imageNamed:@"yt_navigation_search_normal.png"];
    UIImage *higlImage = [UIImage imageNamed:@"yt_navigation_search_high.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:norImage highlightImage:higlImage target:self action:@selector(didSearchBarButtonItemAction:)];
    
    _classArray = @[@"推荐",@"附近"];
    self.dataSource = self;
    self.delegate = self;
    self.storeRecommVC = [[HBStoreListViewController alloc] initWithStoreViewControllerType:HBStoreViewControllerTypeRecomm];
    self.storeRecommVC.delegate = self;
    self.storeNearbyVC = [[HBStoreListViewController alloc] initWithStoreViewControllerType:HBStoreViewControllerTypeNearby];
    self.storeNearbyVC.delegate = self;
    [self initializePageSubviews];
    [NOTIFICENTER addObserver:self
                     selector:@selector(userHbStoreBuySuccessNotification:)
                         name:kHbStoreBuySuccessNotification
                       object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupShowStatsView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//     CGFloat movedRatio = (scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)) - 1;
//}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat pointX = targetContentOffset ->x;
    if (velocity.x<0 && (pointX == CGRectGetWidth(self.view.bounds))) {
        [self.sideMenuViewController presentLeftMenuViewController];
    }
}
#pragma mark - HBStoreListViewControllerDelegate
- (void)hbStoreListViewControllerDidChangeStoreHbs:(HBStoreListViewController *)viewController
{
    [self setupShowStatsView];
}
#pragma mark -HbSelectListViewControllerDelegate
- (void)hbSelectListViewControllerDidChangeStoreHbs:(HbSelectListViewController *)viewController
{
    [self setupShowStatsView];
}
- (void)setupShowStatsView {
    if ([YTHongbaoStoreHelper hongbaoStoreHelper].hbArray.count == 0 ) {
        self.statsView.hidden = YES;
        return;
    }
    self.statsView.hidden = NO;
    int countPrice = 0;
    int countNum = 0;
    for(YTUsrHongBao *hongbao in [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray) {
        countNum += hongbao.buyNum.integerValue;
        countPrice += (hongbao.buyNum.integerValue *hongbao.price);
    }
    self.statsView.badgeText = [NSString stringWithFormat:@"%d",countNum];
    self.statsView.cost = [NSString stringWithFormat:@"%.2f",countPrice/100.];
}
#pragma mark -HbStoreStatsViewDelegate
- (void)hbStoreStatsView:(HbStoreStatsView *)view clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        HbSelectListViewController *selectListVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbSelectListViewController class]];
        selectListVC.delegate = self;
        [self.navigationController pushViewController:selectListVC animated:YES];
    } else {
        NSDictionary *orderDic = [[YTHongbaoStoreHelper hongbaoStoreHelper] setupConfimOrder];
        HbOrderConfirmViewController *orderConfirmVC = [[HbOrderConfirmViewController alloc] init];
        YTOrderModel *orderModel = [[YTOrderModel alloc] initWithJSONDict:orderDic];
        orderConfirmVC.orderArray = [[NSArray alloc] initWithArray:orderModel.orderSet.records];
        [self.navigationController pushViewController:orderConfirmVC animated:YES];
    }
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _classArray.count;
}
- (NSString *)viewPager:(ViewPagerController *)viewPager titleForTabAtIndex:(NSUInteger)index
{
    return _classArray[index];
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    if (index == 0) {
        return self.storeRecommVC;
    } else {
        return self.storeNearbyVC;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth:
            return kDeviceWidth / _classArray.count;
        default:
            break;
    }
    
    return value;
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return YTDefaultRedColor;
        case ViewPagerTabsView:
            return [UIColor whiteColor];
        case ViewPagerContent:
            return [UIColor clearColor];
        default:
            return color;
    }
}
#pragma mark - Notification Response
- (void)userHbStoreBuySuccessNotification:(NSNotification*)notification
{
    [self setupShowStatsView];
}
#pragma mark - Navigation
- (void)didSearchBarButtonItemAction:(id)sender
{
    HBStoreSearchViewController *hbStoreSearchVC = [[HBStoreSearchViewController alloc] init];
    [self.navigationController pushViewController:hbStoreSearchVC animated:YES];
}

#pragma mark - Page subviews
- (void)initializePageSubviews {
    [self.view addSubview:self.statsView];
    [_statsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Getters & Setters
- (HbStoreStatsView *)statsView
{
    if (!_statsView) {
        _statsView = [[HbStoreStatsView alloc] init];
        _statsView.delegate = self;
        _statsView.hidden = YES;
    }
    return _statsView;
}

@end
