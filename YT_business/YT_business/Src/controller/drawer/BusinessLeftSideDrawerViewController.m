#import "BusinessLeftSideDrawerViewController.h"
#import "DrainageViewController.h"
#import "HbStoreRootViewController.h"
#import "PromotionViewController.h"
#import "MyOrderViewController.h"
#import "CDealRecordViewController.h"
#import "UIViewController+Helper.h"
#import "LeftSideHeadView.h"
#import "LeftSideTableCell.h"
#import "LeftSideFootView.h"
#import "UIImageView+WebCache.h"
#import "StoreEditInfomationViewController.h"
#import "AppDelegate.h"
#import "YTUserSettingViewController.h"
#import "LeftSideDrawerHelper.h"
#import "AssistanterMangeViewController.h"
#import "RESideMenu.h"
#import "NSStrUtil.h"
#import "StoreWaiteAuditViewController.h"
#import "StoreAuditFailViewController.h"
#import "YTNoticeViewController.h"

static NSString* CellIdentifier = @"MyDeailCellIdentifier";

@interface BusinessLeftSideDrawerViewController () <UITableViewDelegate, UITableViewDataSource, LeftSideHeadViewDelegate, LeftSideFootViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSArray* dataArray;
@property (strong, nonatomic) NSArray* imageArray;
@property (strong, nonatomic) LeftSideHeadView* headView;
@property (strong, nonatomic) LeftSideFootView* footView;

@end

@implementation BusinessLeftSideDrawerViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeViewData];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    LeftSideTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    if ([YTUsr usr].type == LoginViewTypeBusiness) {
        if (indexPath.row == 2) {
            cell.displayLine = NO;
        }
        else {
            cell.displayLine = YES;
        }
    }
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* viewControllers = [LeftSideDrawerHelper sideDrawerHelper].viewControllers;
    if (indexPath.row >= viewControllers.count) {
        return;
    }
    YTNavigationController* nav;
    if ([YTUsr usr].shop.status == YTSHOPSTATUSINIT || [YTUsr usr].shop.status == YTSHOPSTATUSAUDIT_WAITMARK) {
        StoreWaiteAuditViewController* storeWaiteAuditVC = [[StoreWaiteAuditViewController alloc] init];
        nav = [[YTNavigationController alloc] initWithRootViewController:storeWaiteAuditVC];
    }
    else if ([YTUsr usr].shop.status == YTSHOPSTATUSAUDIT_NOT_PASS) {
        StoreAuditFailViewController* storeAuditFailVC = [[StoreAuditFailViewController alloc] init];
        nav = [[YTNavigationController alloc] initWithRootViewController:storeAuditFailVC];
    }
    else {
        if ([[viewControllers objectAtIndex:indexPath.row] isEqual:[NSNull null]]) {
            [[LeftSideDrawerHelper sideDrawerHelper] replaceNavigationControllerWithIndex:indexPath.row];
        }
        nav = viewControllers[indexPath.row];
    }
    if (self.sideMenuViewController.contentViewController != nav) {
        [self.sideMenuViewController setContentViewController:nav
                                                     animated:YES];
    }
    [self.sideMenuViewController hideMenuViewController];
}
#pragma mark - LeftSideHeadViewDelegate
- (void)leftSideHeadViewDidTap:(LeftSideHeadView*)view
{
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        return;
    }
    NSMutableArray* viewControllers = [LeftSideDrawerHelper sideDrawerHelper].viewControllers;
    if ([[viewControllers lastObject] isEqual:[NSNull null]]) {
        [[LeftSideDrawerHelper sideDrawerHelper] replaceNavigationControllerWithIndex:viewControllers.count - 1];
    }
    YTNavigationController* nav = [viewControllers lastObject];
    if (self.sideMenuViewController.contentViewController != nav) {
        [self.sideMenuViewController setContentViewController:nav
                                                     animated:YES];
    }
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark - LeftSideFootViewDelegate
- (void)leftSideFootViewDidTap:(UIButton*)tapButton
{
    if (tapButton == self.footView.leftButton) {
        //跳转消息
        YTNoticeViewController* center = [[YTNoticeViewController alloc] init];
        YTNavigationController* nav = [[YTNavigationController alloc] initWithRootViewController:center];
        if (self.sideMenuViewController.contentViewController != nav) {
            [self.sideMenuViewController setContentViewController:nav
                                                         animated:YES];
        }
        [self.sideMenuViewController hideMenuViewController];
    }
    else {
        //跳转设置
        YTUserSettingViewController* settingVC = [[YTUserSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        YTNavigationController* nav = [[YTNavigationController alloc] initWithRootViewController:settingVC];
        if (self.sideMenuViewController.contentViewController != nav) {
            [self.sideMenuViewController setContentViewController:nav
                                                         animated:YES];
        }
        [self.sideMenuViewController hideMenuViewController];
    }
}

#pragma mark - Page subviews
- (void)initializeViewData
{
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        self.dataArray = @[ @"收款", @"验证红包", @"消息", @"设置" ];
        self.imageArray = @[ @"yt_leftSideIcon_collection.png", @"yt_leftSideIcon_verify.png", @"yt_leftSideIcon_promotion.png", @"yt_leftSideIcon_store.png" ];
    }
    else {
        //        self.dataArray = @[ @"收款", @"我要引流", @"验证红包", @"我的促销", @"红包商城", @"红包订单", @"我的二维码" ,@"会员收益",@"会员管理",@"更多"];
        //        self.imageArray = @[ @"yt_leftSideIcon_collection.png", @"yt_leftSideIcon_drainage.png", @"yt_leftSideIcon_verify.png", @"yt_leftSideIcon_promotion.png", @"yt_leftSideIcon_store.png", @"yt_leftSideIcon_order.png", @"yt_leftSideIcon_code.png",@"yt_leftSideIcon_income.png",@"yt_leftSideIcon_mange.png",@"yt_leftSideIcon_more.png" ];
        self.dataArray = @[ @"我要引流", @"红包商城", @"会员收益", @"会员管理", @"更多" ];
        self.imageArray = @[ @"yt_leftSideIcon_drainage.png", @"yt_leftSideIcon_store.png", @"yt_leftSideIcon_income.png", @"yt_leftSideIcon_mange.png", @"yt_leftSideIcon_more.png" ];
    }
    if ([LeftSideDrawerHelper sideDrawerHelper].viewControllers.count == 0) {
        [[LeftSideDrawerHelper sideDrawerHelper] businessLeftViewContrllers];
    }
}
- (void)initializePageSubviews
{
    //    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLeftDefaultSideWidth, KDeviceHeight)];
    //    backImageView.image = CCImageNamed(@"yt_leftSide_background.png");
    //    [self.view addSubview:backImageView];

    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    self.headView = [[LeftSideHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 140)];
    self.headView.delegate = self;
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        self.headView.nameLabel.text = [YTUsr usr].userName;
    }
    else {
        self.headView.nameLabel.text = [YTUsr usr].shop.name;
    }

    [self.headView.headImageView setYTImageWithURL:[[YTUsr usr].shop.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"yt_businessUserPlace.png"]];
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        self.headView.arrowImageView.hidden = YES;
    }
    self.tableView.tableHeaderView = _headView;

    if ([YTUsr usr].type != LoginViewTypeAsstanter) {
        self.footView = [[LeftSideFootView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 55)];
        self.footView.delegate = self;
        self.tableView.tableFooterView = _footView;
    }
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftDefaultSideWidth, KDeviceHeight) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[LeftSideTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}

@end
