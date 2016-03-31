#import "ShopSubtractRuleViewController.h"
#import "ShopSubtractRuleHeadView.h"
#import "UIView+DKAddition.h"
#import "ShopSubtractRuleSectionHeadView.h"
#import "ShopSubractDateTableCell.h"
#import "ShopDetailModel.h"
#import "SubtractFullModel.h"
#import "NSStrUtil.h"

static NSString* CellIdentifier = @"shopSubtractCellIdentifier";

@interface ShopSubtractRuleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ShopSubtractRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"优惠说明";
    [self.view addSubview:self.tableView];
    [self configTableHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configTableHeadView
{
    if (!self.shopDetail.fullAllRules || [NSStrUtil isEmptyOrNull:self.shopDetail.fullSubRuleDes.range]) {
        return;
    }
    self.tableView.tableHeaderView = ({
        ShopSubtractRuleHeadView *rangView = [[ShopSubtractRuleHeadView alloc] initWithRulesDesc:@[self.shopDetail.fullSubRuleDes.range] frame:CGRectMake(0, 15, kDeviceWidth, 0)];
        rangView.headView.title = @"适用范围";
        [rangView fitOptimumSize];
        
        ShopSubtractRuleHeadView *otherView = [[ShopSubtractRuleHeadView alloc] initWithRulesDesc:self.shopDetail.fullSubRuleDes.other frame:CGRectMake(0, rangView.dk_bottom+15, kDeviceWidth, 0)];
        [otherView fitOptimumSize];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, otherView.dk_bottom)];
        [view addSubview:rangView];
        [view addSubview:otherView];
        view;
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.shopDetail.fullAllRules.count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
    ShopSubtractRuleSectionHeadView *headView = [[ShopSubtractRuleSectionHeadView alloc] initWithFrame:CGRectMake(0, 15, kDeviceWidth, 45)];
    SubtractFullRule *fullRule = self.shopDetail.fullAllRules[section];
    [headView configSubtractRule:fullRule nowRule:self.shopDetail.nowSubtract];
    [view addSubview:headView];
    return view;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ShopSubractDateTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        SubtractFullRule *fullRule = self.shopDetail.fullAllRules[indexPath.section];
    [cell configShopSubtractDateRules:fullRule];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _tableView.estimatedRowHeight = 120.0;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.rowHeight = 120;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ShopSubractDateTableCell class] forCellReuseIdentifier:CellIdentifier];
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
