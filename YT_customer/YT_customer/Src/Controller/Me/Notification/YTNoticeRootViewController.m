
#import "YTNoticeRootViewController.h"
#import "YTNoticeViewController.h"
#import "YTShopNoticeViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "CSearchStoreViewController.h"

@interface YTNoticeRootViewController () <ViewPagerDataSource, ViewPagerDelegate>
@property (nonatomic, copy) NSArray* classArray;
@end

@implementation YTNoticeRootViewController

#pragma mark - Life cycle
- (void)dealloc
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage* norImage = [UIImage imageNamed:@"yt_navigation_search_normal.png"];
    UIImage* higlImage = [UIImage imageNamed:@"yt_navigation_search_high.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:norImage highlightImage:higlImage target:self action:@selector(didSearchBarButtonItemAction:)];
    
    _classArray = @[ @"商户消息", @"系统消息" ];
    self.dataSource = self;
    self.delegate = self;
    [self reloadData];
}
#pragma mark - Navigation
- (void)didSearchBarButtonItemAction:(id)sender
{
    CSearchStoreViewController* searchStoreVC = [[CSearchStoreViewController alloc] init];
    searchStoreVC.searchResultModule = SearchResultModuleHb;
    searchStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchStoreVC animated:YES];
}
#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController*)viewPager
{
    return _classArray.count;
}
- (NSString*)viewPager:(ViewPagerController*)viewPager titleForTabAtIndex:(NSUInteger)index
{
    return _classArray[index];
}

- (UIViewController *)viewPager:(ViewPagerController*)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    if (index == 0) {
        YTShopNoticeViewController *shopNoticeVC = [[YTShopNoticeViewController alloc] init];
        return shopNoticeVC;
    }
    else {
        YTNoticeViewController* noticeVC = [[YTNoticeViewController alloc] init];
        return noticeVC;
    }
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController*)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
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
- (UIColor*)viewPager:(ViewPagerController*)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor*)color
{

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

@end
