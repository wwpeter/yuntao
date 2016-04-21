#import "CDealRecordViewController.h"
#import "LeftSideDrawerHelper.h"
#import "MyOrderViewController.h"
#import "PromotionViewController.h"
#import "RESideMenu.h"
#import "UIBarButtonItem+Addition.h"
#import "UIViewController+Helper.h"
#import "VerifyCodeRootViewController.h"
#import "YTMoreViewController.h"
#import "YTUserShopCodeViewController.h"

static NSString* CellIdentifier = @"homeMenuCellIdentifier";

@interface YTMoreViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray* dataArr;
@property (nonatomic, strong) UITableView* tableView;
@end

@implementation YTMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"更多";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    self.dataArr = @[ @{ @"title" : @"收款",
                         @"image" : @"yt_more_deal_icon.png" },
        @{ @"title" : @"我的促销",
            @"image" : @"yt_more_promation_icon.png" },
        @{ @"title" : @"验证红包",
            @"image" : @"yt_more_verify_icon.png" },
        @{ @"title" : @"红包订单",
            @"image" : @"yt_more_order_icon.png" },
        @{ @"title" : @"我的二维码",
            @"image" : @"yt_more_qrcode_icon.png" } ];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    ;
    return _dataArr.count;
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
    UITableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (_dataArr.count > indexPath.row) {
        NSDictionary* item = _dataArr[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:item[@"image"]];
        cell.textLabel.text = item[@"title"];
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        CDealRecordViewController* dealRecordVC = [[CDealRecordViewController alloc] init];
        [self.navigationController pushViewController:dealRecordVC animated:YES];
    }
    else if (indexPath.row == 1) {
        PromotionViewController* promotionVC = [[PromotionViewController alloc] init];
        [self.navigationController pushViewController:promotionVC animated:YES];
    }
    else if (indexPath.row == 2) {
        VerifyCodeRootViewController* verifyCodeRootVC = [[VerifyCodeRootViewController alloc] init];
        [self.navigationController pushViewController:verifyCodeRootVC animated:YES];
    }
    else if (indexPath.row == 3) {
        MyOrderViewController* myOrderVC = [[MyOrderViewController alloc] init];
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }
    else if (indexPath.row == 4) {
        YTUserShopCodeViewController* userShopCodeVC = [[YTUserShopCodeViewController alloc] init];
        [self.navigationController pushViewController:userShopCodeVC animated:YES];
    }
    else {
        return;
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
}
#pragma mark - Getters && Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        [_tableView registerClass:[UITableViewCell class]
            forCellReuseIdentifier:CellIdentifier];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _tableView;
}

@end
