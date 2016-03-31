#import "KindHbDetailViewController.h"
#import "UIViewController+Helper.h"
#import "KindHongbaoTableCell.h"
#import "UIImage+HBClass.h"
#import "YTPublishListModel.h"
#import "UserMationMange.h"
#import "MBProgressHUD+Add.h"
#import "UIAlertView+TTBlock.h"
#import "CMyHbDetailViewController.h"
#import "StoryBoardUtilities.h"

static NSString* CellIdentifier = @"KindHbDetailCellIdentifier";

@interface KindHbDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* receiveBtn;
@property (nonatomic, strong) NSArray* dataArray;
@end

@implementation KindHbDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"现金/实物红包详情";
    self.dataArray = @[self.publish.hongbao];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel*)parserObject
              errorMessage:(NSString*)errorMessage;
{
    if (errorMessage) {
        [self showAlert:errorMessage title:@""];
        return;
    }
    if (parserObject.success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您已成功领取红包" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        __weak __typeof(self)weakSelf = self;
        [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [alert show];
    }
    else {
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView*)tableView
    heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    KindHongbaoTableCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    YTResultHongbao *hongbao = _dataArray[indexPath.section];
    [cell configKindHongbaoCellWithModel:hongbao];

    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CMyHbDetailViewController* hbDetailVC = [StoryBoardUtilities viewControllerForMainStoryboard:[CMyHbDetailViewController class]];
        hbDetailVC.hbId = self.publish.hongbao.hongbaoId;
        hbDetailVC.hbtype = HbDetailTypeShopHb;
    [self.navigationController pushViewController:hbDetailVC animated:YES];
}
#pragma mark - Event response
- (void)receiveButtonClicked:(id)sender
{
    NSNumber *userId = [[UserMationMange sharedInstance] userId];
    self.requestParas = @{@"userId" : userId,
                          @"publishId" : self.publish.pId,
                          loadingKey :@(YES)};
    self.requestURL = YC_Request_ChangeHbStatus;
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    _tableView.tableFooterView = ({
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 70)];
        [footerView addSubview:self.receiveBtn];
        footerView;
    });
    if ([self.publish.currUserReviceYN isEqualToString:@"Y"]){
        [self.receiveBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
//        [self.receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.receiveBtn setTitle:@"已领取" forState:UIControlStateNormal];
        self.receiveBtn.enabled = NO;
    }
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[KindHongbaoTableCell class]
            forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (UIButton*)receiveBtn
{
    if (!_receiveBtn) {
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveBtn.frame = CGRectMake(15, 15, CGRectGetWidth(self.view.bounds) - 30, 50);
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.layer.cornerRadius = 4;
        _receiveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_receiveBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xE63E4B)] forState:UIControlStateNormal];
        [_receiveBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xDA2F3C)] forState:UIControlStateHighlighted];
        [_receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_receiveBtn setTitle:@"确认领取" forState:UIControlStateNormal];
        [_receiveBtn addTarget:self action:@selector(receiveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _receiveBtn;
}

@end
