#import "PaySuccessViewController.h"
#import "HbSelectTableCell.h"
#import "YTYellowBackgroundView.h"
#import "HbIntroModel.h"
#import "UIViewController+Helper.h"
#import "PaySuccessModel.h"
#import "UIImage+HBClass.h"
#import "ReceiveHbSuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "HbIntroTableCell.h"
#import "CMyHbListViewController.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "UIAlertView+TTBlock.h"
#import "PayOrderHeadView.h"
#import "ZHQMyConsumeViewController.h"
#import "CMyHbDetailViewController.h"
#import "SingleHbModel.h"

static NSString* CellIdentifier = @"PaySuccessViewCellIdentifier";
static NSString* CellIdentifierForHad = @"PaySuccessViewCellIdentifierForHad";

@interface PaySuccessViewController () <UITableViewDelegate, UITableViewDataSource, HbSelectTableCellDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) NSMutableArray* selectHbArray;
@property (strong, nonatomic) PayOrderHeadView* payHeadView;
@property (strong, nonatomic) YTYellowBackgroundView* yellowHeadView;
@property (strong, nonatomic) UIButton* receiveButton;

@end

@implementation PaySuccessViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = CCCUIColorFromHex(0xEEEEEE);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_hiddenLeftBtn) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didRightButtonPre:)];
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"联系客服" style:UIBarButtonItemStylePlain target:self action:@selector(didCallServiceButtonPre:)];
    }
    [self initializeData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (_receiveType != NoReceive) {
        return _dataArray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_receiveType != NoReceive) {
        return 1;
    }

    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_receiveType != NoReceive) {
        return 15;
    }
    return 45;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{

    if (_receiveType != NoReceive || _dataArray.count == 0) {
        return [[UIView alloc] init];
    }

    UIView* sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 15 + 30)];
    [sectionHeadView addSubview:self.yellowHeadView];
    return sectionHeadView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (_receiveType != NoReceive) {
        HbIntroTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierForHad];
        //        cell.delegate = self;
        HbIntroModel* introModel = _dataArray[indexPath.section];
        [cell configHbIntroCellWithIntroModel:introModel];

        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else {
        HbSelectTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        HbIntroModel* introModel = _dataArray[indexPath.row];
        [cell configHbSelectCellWithIntroModel:introModel];
        if (_passArr) {
            [_passArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
                HbIntroModel* model = obj;
                if (model.hbId == introModel.hbId) {
                    [self setupSelectTableCell:cell atIndexPath:indexPath hbIntroModel:cell.introModel];
                }
            }];
        }
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CMyHbDetailViewController* hbDetailVC = [StoryBoardUtilities viewControllerForMainStoryboard:[CMyHbDetailViewController class]];
    if (_receiveType == NoReceive) {
        HbIntroModel* introModel = _dataArray[indexPath.row];
        hbDetailVC.hbId = introModel.hongbaoId;
        hbDetailVC.hbtype = HbDetailTypeShopHb;
    }
    else {
        HbIntroModel* introModel = _dataArray[indexPath.section];
        hbDetailVC.hbId = introModel.hbId;
        hbDetailVC.hbtype = HbDetailTypeMyHb;
    }
    [self.navigationController pushViewController:hbDetailVC animated:YES];
}
#pragma mark - HbSelectTableCellDelegate
- (void)hbSelectTableCell:(HbSelectTableCell*)cell didSelect:(HbIntroModel*)introModel
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    [self setupSelectTableCell:cell atIndexPath:indexPath hbIntroModel:introModel];
}
#pragma mark - Event response
- (void)receivButtonButtonClicked:(id)sender
{
    NSMutableDictionary* parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:self.orderId forKey:@"payOrderId"];
    for (int i = 0; i < _selectHbArray.count; i++) {
        HbIntroModel* hbIntroModel = _selectHbArray[i];
        [parameter setObject:hbIntroModel.hbId forKey:[NSString stringWithFormat:@"ids[%d]", i]];
    }
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_ReceivePayedHongbao
        parameters:parameter
        success:^(id responseData) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ReceiveHbSuccessViewController* receiveSuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[ReceiveHbSuccessViewController class]];
            receiveSuccessVC.receiveArr = _selectHbArray;
            [self.navigationController pushViewController:receiveSuccessVC animated:YES];
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:self.view];
        }];
}
- (void)inspectAllHb:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"退款请联系收款商家，如有疑问，拨打客服电话 %@", YT_Service_Number] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"联系客服", nil];
    [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self callPhoneNumber:YT_Service_Number];
        }
    }];
    [alert show];
}

#pragma mark - Private methods
- (void)netData
{
    NSDictionary* parameter = @{ @"toOuterId" : self.orderStr };
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];

    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_PayOrderDetail
        parameters:parameter
        success:^(id responseData) {
            if (_receiveType == NoReceive) {
                _paySuccessModel = [[PaySuccessModel alloc] initWithPaySuccessDictionary:responseData[@"data"] showUserHB:NO];
            }
            else {
                _paySuccessModel = [[PaySuccessModel alloc] initWithPaySuccessDictionary:responseData[@"data"] showUserHB:YES];
            }
            [_dataArray removeAllObjects];

            if (_paySuccessModel.payStatus == UserPayModelStatusWaiteCancel || _paySuccessModel.payStatus == UserPayModelStatusWaiteUserPayRefund || _paySuccessModel.payStatus == UserPayModelStatusWaiteUserPayRefundSuccess) {
            }
            else {
                [_dataArray addObjectsFromArray:_paySuccessModel.hbList];
            }
            [self initializePageSubviews];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:self.view];
        }];
}

- (void)setupSelectTableCell:(HbSelectTableCell*)cell atIndexPath:(NSIndexPath*)indexPath hbIntroModel:(HbIntroModel*)introModel
{
    if (introModel.didSelect) {
        [_selectHbArray removeObject:introModel];
        introModel.didSelect = NO;
    }
    else {
        [_selectHbArray addObject:introModel];
        CGFloat costValue = 0;
        for (HbIntroModel* model in _selectHbArray) {
            CGFloat priceValue = [model.cost floatValue];
            costValue += priceValue;
        }
        if (costValue > self.paySuccessModel.maxCost) {
            [_selectHbArray removeObject:introModel];
            [self showAlert:[NSString stringWithFormat:@"金额已经超出啦！"] title:@""];
            return;
        }
        else {
            introModel.didSelect = YES;
        }
    }
    cell.leftSelectButton.selected = introModel.didSelect;
    [_dataArray replaceObjectAtIndex:indexPath.row withObject:introModel];
    [self setupDidEnabledReceiveButton];
}
- (void)setupDidEnabledReceiveButton
{
    self.receiveButton.enabled = self.selectHbArray.count > 0 ? YES : NO;
}

#pragma mark - Navigation
- (void)didRightButtonPre:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didCallServiceButtonPre:(id)sender
{
    [self callPhoneNumber:YT_Service_Number];
}
#pragma mark - Page subviews
- (void)initializeData
{
    _dataArray = [[NSMutableArray alloc] init];
    _selectHbArray = [[NSMutableArray alloc] init];
    [self netData];
}
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.receiveButton];
    self.yellowHeadView.textLabel.text = [NSString stringWithFormat:@"您已获赠总价值%.2f元的红包,从以下红包获取", _paySuccessModel.maxCost];

    CGFloat buttonHeight = 50;
    NSArray* viewcontros = self.navigationController.viewControllers;
    if (viewcontros.count >= 2) {
        if (_receiveType != NoReceive && ![viewcontros[viewcontros.count - 2] isKindOfClass:[ZHQMyConsumeViewController class]]) {
            buttonHeight = 0;
        }
    }
    [_tableView makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(self.view);
    }];
    [_receiveButton makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(buttonHeight);
    }];
    self.tableView.tableHeaderView = self.payHeadView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, buttonHeight)];
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
        if (_receiveType != NoReceive) {
            [_tableView registerClass:[HbIntroTableCell class] forCellReuseIdentifier:CellIdentifierForHad];
            _tableView.rowHeight = 70;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        else {
            [_tableView registerClass:[HbSelectTableCell class] forCellReuseIdentifier:CellIdentifier];
            _tableView.rowHeight = 60;
        }
    }
    return _tableView;
}
- (PayOrderHeadView*)payHeadView
{
    if (!_payHeadView) {
        _payHeadView = [[PayOrderHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 362)];
        [_payHeadView configPayOrderHeadViewWithIntroModel:_paySuccessModel];
    }
    return _payHeadView;
}
- (YTYellowBackgroundView*)yellowHeadView
{
    if (!_yellowHeadView) {
        _yellowHeadView = [[YTYellowBackgroundView alloc] initWithFrame:CGRectMake(0, 15, kDeviceWidth, 30)];
        _yellowHeadView.textLabel.text = [NSString stringWithFormat:@"您已获赠总价值%.2f元的红包,从以下红包获取", _paySuccessModel.maxCost];
    }
    return _yellowHeadView;
}
- (UIButton*)receiveButton
{
    if (!_receiveButton) {
        _receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _receiveButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_receiveButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_receiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        if (_receiveType != NoReceive) {
            [_receiveButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [_receiveButton addTarget:self action:@selector(inspectAllHb:) forControlEvents:UIControlEventTouchUpInside];
            _receiveButton.enabled = YES;
            _receiveButton.hidden = YES;
        }
        else {
            [_receiveButton setTitle:@"确认领取" forState:UIControlStateNormal];
            [_receiveButton addTarget:self action:@selector(receivButtonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            _receiveButton.enabled = NO;
        }
    }
    return _receiveButton;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
