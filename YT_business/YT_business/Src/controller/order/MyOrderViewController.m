#import "MyOrderViewController.h"
#import "MyOrderListViewController.h"
#import "RESideMenu.h"

@interface MyOrderViewController ()
<
ViewPagerDelegate,
ViewPagerDataSource
>
@property (nonatomic, strong) NSArray *classArray;
@end

@implementation MyOrderViewController

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"红包订单";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    _classArray = @[@"支付订单",@"退款订单"];
    _classArray = @[@"支付订单"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    self.dataSource = self;
    self.delegate = self;
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return _classArray.count;
}
- (NSString *)viewPager:(ViewPagerController *)viewPager titleForTabAtIndex:(NSUInteger)index
{
    return _classArray[index];
}
-(UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index{
    if (index == 0) {
        MyOrderListViewController *paymentOrderVC = [[MyOrderListViewController alloc] initWithOrderListVieType:MyOrderListViewTypePayment];
        return paymentOrderVC;
    } else {
        MyOrderListViewController *refundOrderVC = [[MyOrderListViewController alloc] initWithOrderListVieType:MyOrderListViewTypeRefund];
        return refundOrderVC;
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
#pragma mark - Navigation

/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
