#import "MeRootViewController.h"
#import "UserMationMange.h"
#import "YTUserSettingViewController.h"
#import "UINavigationBar+Awesome.h"
#import "YTNoticeRootViewController.h"
#import "ZHQHomeHeaderView.h"
#import "UIBarButtonItem+Addition.h"
#import "ZHQMeAccountViewController.h"
#import "CMyHbListViewController.h"
#import "YTNavigationController.h"
#import "YTLoginViewController.h"
#import "AppDelegate.h"
#import "ZHQMyConsumeViewController.h"
#import "DealRecordBlanceViewController.h"
#import "QRCodeReaderViewController.h"
#import "ScanCodeHelper.h"
#import "UIAlertView+TTBlock.h"
#import "PayViewController.h"
#import "PayCodeViewController.h"
#import "UIViewController+ShopDetail.h"
#import "OutWebViewController.h"

static NSString* CellIdentifier = @"homeMenuCellIdentifier";
#define NAVBAR_CHANGE_POINT 50

@interface MeRootViewController () <ZHQMyHeaderTapDelegate, QRCodeReaderDelegate>

@property (strong, nonatomic) ZHQHomeHeaderView* myHeaderView;
@property (strong, nonatomic) NSArray* menuArr;
@property (strong, nonatomic) UITableView* menuTable;
@property (strong, nonatomic) QRCodeReaderViewController* readerVC;
@end

@implementation MeRootViewController

#pragma mark - Life cycly
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
}

- (void)initData {
    self.menuArr = @[ @[ @{ @"title" : @"账户余额",
                            @"image" : @"my_menu_account" } ],
                      
                      @[
                          @{ @"title" : @"我的红包",
                            @"image" : @"my_menu_hongbao" },
                         @{ @"title" : @"我的消费",
                            @"image" : @"my_menu_consumption" },
                         @{ @"title" : @"扫一扫买单",
                            @"image" : @"my_menu_scanbuy" },
                         @{ @"title" : @"二维码买单",
                            @"image" : @"my_menu_qrcodebuy" },
//                          @{ @"title" : @"我的收藏",
//                             @"image" : @"collection" }
                          ],
                      @[ @{ @"title" : @"设置",
                            @"image" : @"my_menu_shezhi" } ] ];
    [self setUp];
    // 登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogOutNotification:)
        name:kUserLogOutNotification
        object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self scrollViewDidScroll:self.menuTable];
    [self.myHeaderView updateuserInfomation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.menuArr.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* items = self.menuArr[section];
    return items.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary* item = self.menuArr[indexPath.section][indexPath.row];

    cell.imageView.image = [UIImage imageNamed:item[@"image"]];

    cell.textLabel.text = item[@"title"];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![[UserMationMange sharedInstance] userLogin]) {
        [self userLogin];
        return;
    }
    if (indexPath.section == 0) {
        DealRecordBlanceViewController* dealRecordBlanceVC = [[DealRecordBlanceViewController alloc] init];
        dealRecordBlanceVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dealRecordBlanceVC animated:YES];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CMyHbListViewController *myHbListVC = [[CMyHbListViewController alloc] initWithStyle:UITableViewStyleGrouped];
            myHbListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myHbListVC animated:YES];
        }
        else if (indexPath.row == 1) {
            ZHQMyConsumeViewController *conVC = [[ZHQMyConsumeViewController alloc] init];
            conVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:conVC animated:YES];
        }
        else if (indexPath.row == 2) {
            [self toScanBuyView];
        }
        else if (indexPath.row == 3) {
            PayCodeViewController* payCodeVC = [[PayCodeViewController alloc] init];
            payCodeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payCodeVC animated:YES];
        }
        else {
            return;
        }
    }
    else if (indexPath.section == 2) {
        YTUserSettingViewController* settingVC = [[YTUserSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    else {
        return;
    }
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    UIColor* color = [UIColor colorWithRed:248 / 255.0
                                     green:248 / 255.0
                                      blue:248 / 255.0
                                     alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64);
        [self.navigationController.navigationBar
         lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
        self.navigationItem.title = @"我的";
    }
    else {
        [self.navigationController.navigationBar
         lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
         [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        self.navigationItem.title = @"";
    }
}

#pragma mark - Notification Response
- (void)userLogOutNotification:(NSNotification*)notification
{
    [self.myHeaderView updateuserInfomation];
}
#pragma mark - Page subviews

- (void)setUp
{
    //self.view.backgroundColor = CCCUIColorFromHex(0xEEEEEE);
    self.navigationItem.rightBarButtonItem = [self rightBarButtonBar];
    [self.view addSubview:self.menuTable];
    self.menuTable.tableHeaderView = ({
        _myHeaderView = [[ZHQHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 192)];
        _myHeaderView.tapDelegate = self;
        [_myHeaderView updateuserInfomation];
        _myHeaderView;
    });
}
- (UIBarButtonItem *)rightBarButtonBar
{
    UIImage* image = [UIImage imageNamed:@"zhq_my_to_notify"];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tintColor = [UIColor clearColor];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toNotify:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* redImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, -2, 8, 8)];
    redImageView.backgroundColor = [UIColor redColor];
    redImageView.layer.masksToBounds = YES;
    redImageView.layer.cornerRadius = 4;
    [button addSubview:redImageView];
    UIBarButtonItem* buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonItem;
}
#pragma mark ZHQMyHeaderTapDelegate
- (void)toMyInfoTap:(id)sender
{
    //判断是否登录
    if ([[UserMationMange sharedInstance] userLogin]) {
        ZHQMeAccountViewController* accountVC = [[ZHQMeAccountViewController alloc] init];
        accountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountVC animated:YES];
    }
    else {
        [self userLogin];
    }
}
#pragma mark - QRCodeReader Delegate Methods
- (void)reader:(QRCodeReaderViewController*)reader didScanResult:(NSString*)result {
}

#pragma mark Private Methods
- (void)toScanBuyView
{
    _readerVC = [[QRCodeReaderViewController alloc] init];
    _readerVC.modalPresentationStyle = UIModalPresentationFormSheet;
    _readerVC.hidesBottomBarWhenPushed = YES;
    _readerVC.navigationItem.title = @"扫一扫";
    _readerVC.delegate = self;
    __weak typeof(self) weakSelf = self;
    [_readerVC setCompletionWithBlock:^(NSString* resultAsString) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setupScanResultString:resultAsString formViewController:strongSelf.readerVC];
    }];
    [self.navigationController pushViewController:_readerVC animated:YES];
}
- (void)userLogin
{
    YTLoginViewController* loginVC = [[YTLoginViewController alloc] init];
    loginVC.loginType = LoginViewTypePhone;
    YTNavigationController* navigationVC = [[YTNavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}
- (void)setupScanResultString:(NSString*)string formViewController:(UIViewController*)formViewController
{
    ScanCodeHelper* scanCode = [[ScanCodeHelper alloc] initWithResultUrlString:string];
    if (!scanCode.isYtCode) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"此二维码未经官方认证" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        __weak typeof(self) weakSelf = self;
        [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            if (buttonIndex == 0) {
                [strongSelf.readerVC startScanning];
            }
        }];
        [alert show];
        return;
    }
    if (scanCode.openType == ScanCodeOpenTypeH5) {
        OutWebViewController* webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
        webVC.urlStr = string;
        [formViewController.navigationController pushViewController:webVC animated:YES];
    }
    else {
        PayViewController* payVC = [[PayViewController alloc] init];
        payVC.shopId = scanCode.shopId;
        payVC.mayChange = YES;
        [formViewController.navigationController pushViewController:payVC animated:YES];
    }
}

#pragma mark - Getters && Setters
- (UITableView*)menuTable
{
    if (!_menuTable) {
        _menuTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _menuTable.delegate = self;
        _menuTable.dataSource = self;
        _menuTable.rowHeight = 45;
        [_menuTable registerClass:[UITableViewCell class]
            forCellReuseIdentifier:CellIdentifier];
        if ([_menuTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_menuTable setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_menuTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [_menuTable setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _menuTable;
}

#pragma mark - Navigation

- (void)toNotify:(id)sender
{
    if ([[UserMationMange sharedInstance] userLogin]) {
        //self.tabBarController.selectedIndex = 1;
        YTNoticeRootViewController* noticeVC = [[YTNoticeRootViewController alloc] init];
       // noticeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:noticeVC animated:YES];
    }
    else {
        [self userLogin];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
