#import "YTUserSettingViewController.h"
#import "UserMationMange.h"
#import "SDImageCache.h"
#import "UIViewController+Helper.h"
#import "UIImage+HBClass.h"
#import "UIActionSheet+TTBlock.h"
#import "AboutusViewController.h"
#import "YTNotificationRemindViewController.h"
#import "UserInfomationModel.h"
#import "YCApi.h"
#import "OutWebViewController.h"
#import "YTFeedBackViewController.h"
#import "UserLoginHeloper.h"

static NSString *const YT_Customer_FAQ = @"http://user.faq.yuntaohongbao.com";

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
    if ([YC_WSSERVICE_HTTP hasPrefix:@"http://test."]) {
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
    if (type == 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM", [self getCacheLeaght]];
    }else {
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
        YTNotificationRemindViewController *notificationVC = [[YTNotificationRemindViewController alloc] init];
        [self.navigationController pushViewController:notificationVC animated:YES];
    } break;
      case 2: {
        [self clearnCache];
        [tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationNone];
    } break;
    case 3: {
        AboutusViewController* aboutusVC = [[AboutusViewController alloc] init];
        [self.navigationController pushViewController:aboutusVC animated:YES];
    } break;
        case 4: {
            OutWebViewController *webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
            webVC.urlStr = YT_Customer_FAQ;
            [self.navigationController pushViewController:webVC animated:YES];
        } break;
        case 7:
        {
            YTFeedBackViewController *feedBackVC = [[YTFeedBackViewController alloc]init];
            [self.navigationController pushViewController:feedBackVC animated:YES];
        }
            break;
    default:
        break;
    }
}
#pragma mark - Evens respost
- (void)userLogout:(id)sender
{
    if (![[UserMationMange sharedInstance] userLogin]) {
        [self showAlert:@"您还未登陆哦~" title:@""];
        return;
    }
    //注销
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定退出此账号吗?" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles: nil];
    __weak __typeof(self)weakSelf = self;
    [sheet setCompletionBlock:^(UIActionSheet *alertView, NSInteger buttonIndex) {
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
    [UserInfomationModel removerUserDefaults];
    [YCApi deleteAllCookieWithKey];
    [UserLoginHeloper sharedMange].realyLogin = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogOutNotification
                                                        object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - Navigation

#pragma mark - Page subviews
- (void)initializeData
{
    self.dataArray = @[ @{ @"type" : @1,
                           @"title" : @"消息提醒",
                           @"image" : @"zhq_notify_icon" },
                        @{ @"type" : @2,
                           @"title" : @"清除缓存",
                           @"image" : @"zhq_clean_cache" },
                        @{ @"type" : @3,
                           @"title" : @"关于我们",
                           @"image" : @"zhq_about_us" } ,
                        @{ @"type" : @4,
                           @"title" : @"常见问题",
                           @"image" : @"yt_faq_icon" },
                        @{@"type" : @7,
                          @"title" : @"意见反馈/建议",
                          @"image" : @"zhq_sug_icon"}];
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
