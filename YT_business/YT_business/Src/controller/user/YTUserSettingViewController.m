#import "YTUserSettingViewController.h"
#import "UserMationMange.h"
#import "SDImageCache.h"
#import "UIViewController+Helper.h"
#import "UIImage+HBClass.h"
#import "UIActionSheet+TTBlock.h"
#import "AboutusViewController.h"
#import "YTNotificationRemindViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "AppDelegate.h"
#import "LeftSideDrawerHelper.h"
#import "YTUserShopCodeViewController.h"
#import "OutWebViewController.h"
#import "RESideMenu.h"
#import "ApplyUntil.h"
#import "MBProgressHUD+Add.h"
#import "UIAlertView+TTBlock.h"
#import "YTFeedbackViewController.h"
#import "YTAccountSafeViewController.h"
#import "AssistanterMangeViewController.h"

static NSString* const YT_AppleID = @"1018504199";
static NSString* const YT_Business_FAQ = @"http://biz.faq.yuntaohongbao.com";
static NSString* CellIdentifier = @"UserSettingCellIdentifier";

@interface YTUserSettingViewController ()

@property (strong, nonatomic) NSArray* dataArray;
@end

@implementation YTUserSettingViewController

#pragma mark - Life cycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    if ([hostURL hasPrefix:@"http://test."]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"•" style:UIBarButtonItemStylePlain target:self action:nil];
    }
    
    [self initializeData];
    [self initializePageSubviews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

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
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    NSDictionary* item = _dataArray[indexPath.row];
    NSString* imageName = item[@"image"];
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.textLabel.text = item[@"title"];
    NSInteger type = [item[@"type"] integerValue];
    if (type == 3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", [self getCacheLeaght]];
    }
    else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* item = _dataArray[indexPath.row];
    NSInteger type = [item[@"type"] integerValue];
    switch (type) {
    case 1: {
        YTNotificationRemindViewController* notificationVC = [[YTNotificationRemindViewController alloc] init];
        [self.navigationController pushViewController:notificationVC animated:YES];
    } break;
    case 2: {
        YTAccountSafeViewController *accountSafeVC = [[YTAccountSafeViewController alloc] init];
        [self.navigationController pushViewController:accountSafeVC animated:YES];
    } break;
    case 3: {
        [self clearnCache];
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    } break;
    case 4: {
        AboutusViewController* aboutusVC = [[AboutusViewController alloc] init];
        [self.navigationController pushViewController:aboutusVC animated:YES];
    } break;
    case 5: {
//        YTUserShopCodeViewController* userShopCodeVC = [[YTUserShopCodeViewController alloc] init];
//        [self.navigationController pushViewController:userShopCodeVC animated:YES];
               AssistanterMangeViewController* assistanterMangeVC = [[AssistanterMangeViewController alloc] init];
        [self.navigationController pushViewController:assistanterMangeVC animated:YES];    } break;
    case 6: {
        OutWebViewController* webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
        webVC.urlStr = YT_Business_FAQ;
        [self.navigationController pushViewController:webVC animated:YES];
    } break;
    case 7: {
//        [ApplyUntil checkVersionUpdate:self.view];
    } break;
    case 8: {
        YTFeedbackViewController* feedbackVC = [[YTFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    } break;

    default:
        break;
    }
}
#pragma mark - Evens respost
- (void)userLogout:(id)sender
{
    //注销
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"确定注退出账号吗?" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil];
    __weak __typeof(self) weakSelf = self;
    [sheet setCompletionBlock:^(UIActionSheet* alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [weakSelf userDidLogOut];
        }
    }];
    [sheet showInView:self.view];
}
#pragma mark -Private Methods
//清除缓存
- (void)clearnCache
{
    float tmpSize = [self getCacheLeaght];
    NSString* clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)", tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)", tmpSize * 1024];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDImageCache sharedImageCache] clearDisk];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showAlert:[NSString stringWithFormat:@"清理缓存%@", clearCacheName] title:@"成功"];
        });
    });
}
- (CGFloat)getCacheLeaght
{
    NSNumber* a = [[NSNumber alloc] initWithInteger:[[SDImageCache sharedImageCache] getSize]];
    return a.floatValue / (1024.0 * 1024.0);
}
- (void)userDidLogOut
{
    [[YTUsr usr] doLoginOut];
    [LeftSideDrawerHelper sideDrawerHelper].viewControllers = [[NSMutableArray alloc] init];
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate showLoginRootView];
}

#pragma mark - Navigation

#pragma mark - Page subviews
- (void)initializeData
{
    NSArray *array = @[ @{ @"type" : @5,
                           @"title" : @"营业员管理",
                           @"image" : @"yt_assistant_icon" },
                        @{ @"type" : @1,
                           @"title" : @"消息提醒",
                           @"image" : @"zhq_notify_icon" },
                        @{ @"type" : @2,
                           @"title" : @"账户安全",
                           @"image" : @"zhq_safy_icon" },
                        @{ @"type" : @3,
                           @"title" : @"清除缓存",
                           @"image" : @"zhq_clean_cache" },
                        @{ @"type" : @4,
                           @"title" : @"关于我们",
                           @"image" : @"zhq_about_us" },
                        @{ @"type" : @6,
                           @"title" : @"常见问题",
                           @"image" : @"yt_faq_icon" },
                        //        @{ @"type" : @7,
                        //            @"title" : @"发现新版本",
                        //            @"image" : @"zhq_notify_icon" },
                        @{ @"type" : @8,
                           @"title" : @"问题反馈/留言/投诉",
                           @"image" : @"feedback_icon" } ];
    NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:array];
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        [mutableArr removeObjectAtIndex:0];
    }
    self.dataArray = [[NSArray alloc] initWithArray:mutableArr];
}
- (void)initializePageSubviews
{
    self.tableView.rowHeight = 50;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    self.tableView.tableFooterView = ({
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 52)];
        UIButton* quiteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quiteBtn.frame = headView.bounds;
        [quiteBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [quiteBtn addTarget:self action:@selector(userLogout:) forControlEvents:UIControlEventTouchUpInside];
        [quiteBtn setTitleColor:CCCUIColorFromHex(0x333333) forState:UIControlStateNormal];
        ;
        [quiteBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xFFFFFF)] forState:UIControlStateNormal];
        [headView addSubview:quiteBtn];
        UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
        line1.image = YTlightGrayTopLineImage;
        UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 51, kDeviceWidth, 1)];
        line2.image = YTlightGrayBottomLineImage;
        [headView addSubview:line1];
        [headView addSubview:line2];
        headView;
    });
}
@end
