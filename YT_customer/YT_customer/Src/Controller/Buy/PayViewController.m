#import "PayViewController.h"
#import "HbSelectTableCell.h"
#import "HbIntroModel.h"
#import "UIViewController+Helper.h"
#import "UIView+DKAddition.h"
#import "HbStoreStatsView.h"
#import "CStoreOrderConfirmViewController.h"
#import "MBProgressHUD+Add.h"
#import "YTNetworkMange.h"
#import "SVPullToRefresh.h"
#import "NSStrUtil.h"
#import "ShopDetailModel.h"
#import "PayModeHeadView.h"
#import "PayModeTableCell.h"
#import "ShopDetailSectionHeadView.h"
#import "UIImage+HBClass.h"
#import "YTPlaceTextView.h"
#import "PayYellowView.h"
#import "HbMoreFooterView.h"
#import "PayOrderViewController.h"
#import "PayUtil.h"
#import "PaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "ReceiveHbSuccessViewController.h"
#import "UIAlertView+TTBlock.h"
#import "UIActionSheet+TTBlock.h"
#import "CMyHbDetailViewController.h"
#import "SingleHbModel.h"
#import "YTYellowBackgroundView.h"
#import "PayNotPreferenceView.h"
#import "SubtractFullModel.h"
#import "CompositeUntil.h"
#import "UserMationMange.h"
#import "ZCTradeView.h"
#import "YTAccountModel.h"
#import "YTModelFactory.h"

static const NSInteger kHeaderHeight = 108;
static const NSInteger kBottomStatsHeight = 50;

static NSString* const kPayPasswdErroe = @"PAY_PASSWD_ERROR";
static NSString* HbCellIdentifier = @"HbCellIdentifier";
static NSString* PayCellIdentifier = @"PayCellIdentifier";

@interface PayViewController () <UITableViewDelegate, UITableViewDataSource, HbSelectTableCellDelegate,
    YTPayTextViewDelegate, HbStoreStatsViewDelegate, YTPlaceTextViewDelegate,
    PayNotPreferenceViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (assign, nonatomic) NSInteger page;

@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) NSMutableArray* userHbArray;
//@property (strong, nonatomic) NSMutableArray* selectHbArray;

@property (strong, nonatomic) YTPayTextView* payTextView;
@property (strong, nonatomic) PayYellowView* yellowView;
@property (strong, nonatomic) PayNotPreferenceView* notPreferenceView;

@property (strong, nonatomic) UIView* headView;
@property (strong, nonatomic) PayModeHeadView* payHeadView;
@property (strong, nonatomic) ShopDetailSectionHeadView* hbHeadView;
@property (strong, nonatomic) YTPlaceTextView* remarkView;
@property (strong, nonatomic) YTYellowBackgroundView* enterYellowView;
@property (strong, nonatomic) UIButton* buyButton;

@property (copy, nonatomic) NSString* costValue;
@property (copy, nonatomic) NSString* toOuterId;
@property (assign, nonatomic) NSInteger selectPayIndex;
@property (assign, nonatomic) NSInteger selectHbIndex;
@property (assign, nonatomic) BOOL didShowMore;
@property (assign, nonatomic) BOOL didSelectNotPreference;
@end

@implementation PayViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    [self initializeData];
    if (self.shopModel) {
        self.navigationItem.title = self.shopModel.shopName;
        [self loadStoreHbTopData];
        [self initializePageSubviews];
    }
    else {
        [self loadShopInfoData];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.shopModel) {
        [self.shopModel validateFullSubtractTime];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Data
- (void)loadShopInfoData
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary* parameters = @{ @"shopId" : _shopId };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_ShopInfo
        parameters:parameters
        success:^(id responseData) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.shopModel = [[ShopDetailModel alloc]
                initWithShopDetailDictionary:responseData];
            [strongSelf loadStoreHbTopData];
            [strongSelf initializePageSubviews];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:weakSelf.view];
        }];
}
- (void)loadStoreHbTopData
{
    [self pullToRefreshViewWithObject:self.shopModel.userHongbaos];
}
- (void)pullToRefreshViewWithObject:(NSArray*)array
{
    [self.userHbArray removeAllObjects];
    self.page = 2;
    for (NSDictionary* dic in array) {
        HbIntroModel* hiModel =
            [[HbIntroModel alloc] initWithHbIntroDictionary:dic[@"hongbao"]];
        [self.userHbArray addObject:hiModel];
    }
    if (self.payType == PreferencePayTypeHongbao) {
        self.dataArray = [[NSMutableArray alloc] initWithArray:self.userHbArray];
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    if (_dataArray.count > 1 && !self.didShowMore) {
        return 1;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView*)tableView
    heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 && _dataArray.count == 0) {
        return CGFLOAT_MIN;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView*)tableView
    heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (_dataArray.count == 0) {
            return CGFLOAT_MIN;
        }
        if (_dataArray.count > 1 && !self.didShowMore) {
            return 15 + 44;
        }
    }
    return 15;
}
- (UIView*)tableView:(UITableView*)tableView
    viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.payHeadView;
    }
    else if (section == 1) {
        if (_dataArray.count == 0) {
            return nil;
        }
        else {
            return self.hbHeadView;
        }
    }
    return nil;
}
- (UIView*)tableView:(UITableView*)tableView
    viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (_dataArray.count > 1 && !self.didShowMore) {
            UIView* footerView = [[UIView alloc] init];
            HbMoreFooterView* moreView = [[HbMoreFooterView alloc]
                initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
            [footerView addSubview:moreView];
            __weak __typeof(self) weakSelf = self;
            moreView.selectBlock = ^(BOOL didDown) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.didShowMore = YES;
                [strongSelf.tableView reloadData];
            };
            return footerView;
        }
    }
    return nil;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        PayModeTableCell* cell =
            [tableView dequeueReusableCellWithIdentifier:PayCellIdentifier];
        UIImage* normalImage = [UIImage imageNamed:@"yt_cell_left_normal.png"];
        UIImage* selectImage = [UIImage imageNamed:@"yt_cell_left_select.png"];
        if (indexPath.row == 0) {
            cell.iconImageView.image = [UIImage imageNamed:@"yt_payType_balance.png"];
            cell.titleLabel.text = @"余额支付";
            cell.messageLabel.text = @"您可以使用账户余额进行支付";
        }
        else if (indexPath.row == 1) {
            cell.iconImageView.image = [UIImage imageNamed:@"yt_payType_zfb.png"];
            cell.titleLabel.text = @"支付宝支付";
            cell.messageLabel.text = @"支持有支付宝、网银的用户使用";
        }
        else {
            cell.iconImageView.image = [UIImage imageNamed:@"yt_payType_wx.png"];
            cell.titleLabel.text = @"微信支付";
            cell.messageLabel.text = @"支持安装微信5.0以上版本";
        }
        if (self.payChannel > 0) {
            cell.userInteractionEnabled = NO;
            _selectPayIndex = self.payChannel == 1 ? 1 : 2;
        }
        cell.accessoryView = [[UIImageView alloc]
            initWithImage:_selectPayIndex == indexPath.row ? selectImage
                                                           : normalImage];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
    else {
        HbSelectTableCell* cell =
            [tableView dequeueReusableCellWithIdentifier:HbCellIdentifier];
        cell.delegate = self;
        HbIntroModel* introModel = _dataArray[indexPath.row];
        introModel.didSelect = indexPath.row == self.selectHbIndex ? YES : NO;
        [cell configHbSelectCellWithIntroModel:introModel];
        cell.thanLabel.text = @"";
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView
    didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if (_selectPayIndex == indexPath.row) {
            return;
        }
        _selectPayIndex = indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                 withRowAnimation:UITableViewRowAnimationNone];
    }
    else {
        HbIntroModel* introModel = _dataArray[indexPath.row];
        CMyHbDetailViewController* hbDetailVC = [StoryBoardUtilities
            viewControllerForMainStoryboard:[CMyHbDetailViewController class]];
        hbDetailVC.hbtype = HbDetailTypeShopHb;
        hbDetailVC.hbId = introModel.hbId;
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
}
#pragma mark - HbSelectTableCellDelegate
- (void)hbSelectTableCell:(HbSelectTableCell*)cell
                didSelect:(HbIntroModel*)introModel
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    [self setupSelectTableCell:cell
                   atIndexPath:indexPath
                  hbIntroModel:introModel];
}
#pragma mark - YTPlaceTextViewDelegate
- (void)placeTextView:(YTPlaceTextView*)view
    textViewShouldBeginEditing:(UITextView*)textView
{
    CGPoint pointInTable =
        [view.superview convertPoint:view.frame.origin
                              toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = (216 + 64 + 44) - (CGRectGetHeight(self.tableView.bounds) - pointInTable.y);
    [self.tableView setContentOffset:contentOffset animated:YES];
}
- (void)placeTextView:(YTPlaceTextView*)view
    textViewShouldEndEditing:(UITextView*)textView
{
    CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height + 64 + 40);
    [self.tableView setContentOffset:offset animated:YES];
}

#pragma mark - YTPayTextViewDelegate
- (void)ytPayTextView:(YTPayTextView*)view
    textFieldDidBeginEditing:(UITextField*)textField
{
}
- (BOOL)ytPayTextView:(YTPayTextView*)view textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    return [CompositeUntil validateNumberTextField:textField replacementString:string];
}
- (void)ytPayTextView:(YTPayTextView*)view
    textFieldWillEndEditing:(UITextField*)textField
{
    CGFloat textValue = [textField.text doubleValue];
    if (textValue < 0.01f) {
        [self showAlert:@"最少输入0.01" title:@""];
        return;
    }
    CGFloat notPreferenceValue = [self.notPreferenceView.payTextView.textField.text doubleValue];
    if (textValue <= notPreferenceValue) {
        self.notPreferenceView.payTextView.textField.text = @"";
    }
    if (self.payType == PreferencePayTypeHongbao) {
        [self showHongbao];
    }
    else if (self.payType == PreferencePayTypeSubtract) {
        [self showFullSubtract];
        if (!self.shopModel.subtractInTime) {
            return;
        }
        [self showYellowViewAnimation:textValue];
    }
    else {
        [self showDiscount];
        if (!self.shopModel.isDiscount) {
            return;
        }
        [self showYellowViewAnimation:textValue];
    }
}
#pragma mark - PayNotPreferenceViewDelegate
- (BOOL)payNotPreferenceView:(PayNotPreferenceView*)view
 textFieldShouldBeginEditing:(UITextField*)textField
{
    CGFloat totalValue = [self.payTextView.textField.text doubleValue];
    if (totalValue < 0.01f) {
        [self showAlert:@"请先输入消费总额" title:@""];
        return NO;
    }
    return YES;
}
- (BOOL)payNotPreferenceView:(PayNotPreferenceView*)view textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    return [CompositeUntil validateNumberTextField:textField replacementString:string];
}
- (void)payNotPreferenceView:(PayNotPreferenceView*)view
     textFieldWillEndEditing:(UITextField*)textField
{
    CGFloat totalValue = [self.payTextView.textField.text doubleValue];
    CGFloat textValue = [textField.text doubleValue];
    if (textValue < 0.01f) {
        [self showAlert:@"输入金额不能少于0.01" title:@""];
        return;
    }
    if (totalValue < textValue) {
        [self showAlert:@"输入金额不能大于消费总额" title:@""];
        textField.text = @"";
        return;
    }
    if (self.payType == PreferencePayTypeHongbao) {
        [self showHongbao];
    }
    else if (self.payType == PreferencePayTypeSubtract) {
        [self showFullSubtract];
    }
    else {
        [self showDiscount];
    }
}

#pragma mark - Private methods
- (void)showDiscount
{
    self.yellowView.leftLabel.text = [NSString
        stringWithFormat:@"折扣优惠 (%.1f折)", _shopModel.discount / 10.];
    self.yellowView.rightLabel.text = @"-0元";
    CGFloat totalValue = [self.payTextView.textField.text doubleValue];
    CGFloat notPreferenceValue =
        [self.notPreferenceView.payTextView.textField.text doubleValue];
    CGFloat cost = totalValue - notPreferenceValue;
    if (self.shopModel.isDiscount) {
        CGFloat lCost = cost * (self.shopModel.discount / 100.);
        if (lCost > 0) {
            lCost = lCost < 0.01f ? 0.01 : lCost;
        }
        CGFloat dCost = cost - lCost;
        self.costValue =
            [NSString stringWithFormat:@"%.2f", lCost + notPreferenceValue];
        self.yellowView.rightLabel.text =
            [NSString stringWithFormat:@"-%.2f元", dCost];
    }
    else {
        self.costValue = [NSString stringWithFormat:@"%.2f", totalValue];
    }
}
- (void)showFullSubtract
{
    CGFloat totalValue = [self.payTextView.textField.text doubleValue];
    CGFloat notPreferenceValue =
        [self.notPreferenceView.payTextView.textField.text doubleValue];

    if (!self.shopModel.nowSubtract) {
        self.costValue = [NSString stringWithFormat:@"%.2f", totalValue];
        return;
    }
    self.yellowView.leftLabel.text =
        [NSString stringWithFormat:@"每满%@减%@",
                  @(self.shopModel.nowSubtract.subtractFull),
                  @(self.shopModel.nowSubtract.subtractCur)];
    self.yellowView.rightLabel.text = @"-0元";
    CGFloat cost = totalValue - notPreferenceValue;
    if (cost >= self.shopModel.nowSubtract.subtractFull) {
        NSInteger fullFold = cost / self.shopModel.nowSubtract.subtractFull;
        CGFloat curValue = self.shopModel.nowSubtract.subtractCur * fullFold;
        if (curValue >= self.shopModel.nowSubtract.subtractMax) {
            curValue = self.shopModel.nowSubtract.subtractMax;
        }
        CGFloat lCost = (cost - curValue) + notPreferenceValue;
        self.costValue = [NSString stringWithFormat:@"%.2f", lCost];
        self.yellowView.rightLabel.text =
            [NSString stringWithFormat:@"-%@元", @(curValue)];
    }
    else {
        self.costValue = [NSString stringWithFormat:@"%.2f", totalValue];
    }
}
- (void)showHongbao
{
    self.yellowView.leftLabel.text = @"红包优惠";
    self.yellowView.rightLabel.text = @"-0元";
    CGFloat totalValue = [self.payTextView.textField.text doubleValue];
    CGFloat notPreferenceValue =
        [self.notPreferenceView.payTextView.textField.text doubleValue];
    CGFloat cost = totalValue - notPreferenceValue;
    if (self.selectHbIndex >= 0) {
        HbIntroModel* introModel = _dataArray[self.selectHbIndex];
        CGFloat hbCost = [introModel.cost floatValue];
        CGFloat dCost = cost - hbCost;
        dCost = dCost < 0.01f ? 0.01 : dCost;
        self.costValue =
            [NSString stringWithFormat:@"%.2f", dCost + notPreferenceValue];
        self.yellowView.rightLabel.text =
            [NSString stringWithFormat:@"-%.2f元", hbCost];
    }
    else {
        self.costValue = [NSString stringWithFormat:@"%.2f", cost];
    }
}
- (void)showYellowViewAnimation:(CGFloat)value
{
    if (value == 0) {
        self.headView.dk_height = self.notPreferenceView.dk_bottom + 15;
        [UIView animateWithDuration:1.0f
            animations:^{
                _yellowView.alpha = 0;
                _tableView.tableHeaderView = _headView;
            }
            completion:^(BOOL finished) {
                _yellowView.dk_y = 31;
                _notPreferenceView.dk_y = _payTextView.dk_bottom + 15;
            }];
    }
    else {
        self.headView.dk_height = self.notPreferenceView.dk_bottom + 30 + (self.didSelectNotPreference ? 15 : 0);
        _yellowView.alpha = 1;
        [UIView animateWithDuration:1.0f
                         animations:^{
                             _yellowView.dk_y = 31 + 30;
                             _notPreferenceView.dk_y = _payTextView.dk_bottom + 15 + 30;
                         }];
        self.tableView.tableHeaderView = self.headView;
    }
}
// 添加/移除选择项
- (void)setupSelectTableCell:(HbSelectTableCell*)cell
                 atIndexPath:(NSIndexPath*)indexPath
                hbIntroModel:(HbIntroModel*)introModel
{
    if ([NSStrUtil isEmptyOrNull:self.payTextView.textField.text]) {
        [self showAlert:@"请先输入消费金额" title:@""];
        return;
    }

    CGFloat maxValue = [self.payTextView.textField.text floatValue];
    //    CGFloat notPreValue = [self.notPreferenceView.payTextView.textField.text
    //    floatValue];
    //    if ((maxValue - notPreValue) < [introModel.cost floatValue]) {
    //        [self showAlert:@"消费金额小于红包金额" title:@""];
    //        return;
    //    }
    if (indexPath.row == _selectHbIndex) {
        return;
    }
    if (_selectHbIndex >= 0) {
        NSIndexPath* lastIndexPath =
            [NSIndexPath indexPathForRow:_selectHbIndex
                               inSection:1];
        HbSelectTableCell* lastCell = (HbSelectTableCell*)
            [self.tableView cellForRowAtIndexPath:lastIndexPath];
        lastCell.leftSelectButton.selected = NO;
    }
    self.selectHbIndex = indexPath.row;
    cell.leftSelectButton.selected = YES;
    [self showHongbao];
    [self showYellowViewAnimation:maxValue];
}
- (void)receiveHongbaoWithOrderId:(NSNumber*)orderId
{
    if (!self.toOuterId || !orderId) {
        return;
    }
    [self pushToPaySuccessViewControllerWithOrderStr:self.toOuterId
                                             orderId:orderId];
}
- (void)pushToPaySuccessViewControllerWithOrderStr:(NSString*)toOuterId
                                           orderId:(NSNumber*)orderId
{
    PaySuccessViewController* paySuccessVC = [StoryBoardUtilities
        viewControllerForMainStoryboard:[PaySuccessViewController class]];
    paySuccessVC.hiddenLeftBtn = YES;
    paySuccessVC.receiveType = NoReceive;
    paySuccessVC.orderStr = toOuterId;
    paySuccessVC.orderId = orderId;
    paySuccessVC.navigationItem.leftItemsSupplementBackButton = NO;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}
- (void)setupUserPayPassword
{
    ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"设置支付密码" frame:CGRectZero];
    __weak __typeof(self) weakSelf = self;
    tradeView.finish = ^(NSString* passWord) {
        [weakSelf setupPasswordAgain:passWord];
    };
    [tradeView show];
}
- (void)setupPasswordAgain:(NSString*)psd
{
    ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"确认支付密码" frame:CGRectZero];
    __weak __typeof(self) weakSelf = self;
    tradeView.finish = ^(NSString* passWord) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([passWord isEqualToString:psd]) {
            [strongSelf settingUserPassword:passWord];
        }
        else {
            [strongSelf showAlert:@"两次输入的密码不一样" title:@"设置密码失败"];
        }
    };
    [tradeView show];
}
- (void)settingUserPassword:(NSString*)password
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary* parameters = @{ @"payPwd" : [password GetMD5] };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_SetPayPasswd
        parameters:parameters
        success:^(id responseData) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            YTBaseModel* responseModel = [YTModelFactory modelWithURL:YC_Request_SetPayPasswd
                                                         responseJson:responseData];
            if (responseModel.success) {
                [strongSelf showAlert:@"您在进行提现或者其他消费时,输入该密码即可完成操作" title:@"密码设置成功"];
            }
            else {
                [strongSelf showAlert:responseModel.message title:@""];
            }

        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:weakSelf.view];
        }];
}
- (void)placeOrder
{
    if (_selectPayIndex == 0) {
        [self payWithBalance];
    }
    else {
        [self payWithAlipayOrWeixinpay];
    }
}
- (void)payWithBalance
{
    if ([NSStrUtil isEmptyOrNull:[[UserMationMange sharedInstance] payPwd]]) {
        [self setupUserPayPassword];
    }
    else {
        ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"请输入支付密码" frame:CGRectZero];
        __weak __typeof(self) weakSelf = self;
        tradeView.finish = ^(NSString* passWord) {
            [weakSelf balancePayWithPassword:passWord];
        };
        [tradeView show];
    }
}
- (void)balancePayWithPassword:(NSString*)password
{
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary* parameters = @{};
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_QueryMemberAcount
        parameters:parameters
        success:^(id responseData) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            YTAccountModel* accountModel = [[YTAccountModel alloc] initWithDictionary:responseData error:NULL];
            [weakSelf balancePayWithRemain:accountModel.account.remain password:password];
        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:weakSelf.view];
        }];
}
- (void)balancePayWithRemain:(NSInteger)remain password:(NSString*)password
{
    NSInteger amount = (NSInteger)([self.costValue floatValue] * 100);
    if (remain < amount) {
        [self lackOfBalancePayWithAlipayOrWeixinpayRemain:remain password:password];
    }
    else {
        self.buyButton.enabled = NO;
        [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
        NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] initWithDictionary:[self needParameters]];
        mutableDict[@"payPasswd"] = [password GetMD5];
        mutableDict[@"remainAmount"] = @(remain);
        mutableDict[@"payMode"] = @1;
        __weak __typeof(self) weakSelf = self;
        [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_MemberBalancePay
            parameters:mutableDict
            success:^(id responseData) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                strongSelf.buyButton.enabled = YES;
                if ( [strongSelf validatePassword:responseData]) {
                NSDictionary* payOrderDict = responseData[@"data"][@"payOrder"];
                if (!payOrderDict) {
                    return;
                }
                strongSelf.toOuterId = payOrderDict[@"toOuterId"];
                [strongSelf
                    receiveHongbaoWithOrderId:payOrderDict[@"id"]];
                }
            }
            failure:^(NSString* errorMessage) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [MBProgressHUD showError:errorMessage toView:strongSelf.view];
                strongSelf.buyButton.enabled = YES;
            }];
    }
}
- (void)lackOfBalancePayWithAlipayOrWeixinpayRemain:(NSInteger)remain password:(NSString*)password
{
    NSInteger amount = (NSInteger)([self.costValue floatValue] * 100);
    NSString* lackValue = [NSString stringWithFormat:@"余额不足,还需支付%.2f元", (amount - remain) / 100.];
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:lackValue delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝继续支付", @"微信继续支付", nil];
    __weak __typeof(self) weakSelf = self;
    [sheet setCompletionBlock:^(UIActionSheet* alertView, NSInteger buttonIndex) {
        if (buttonIndex > 1) {
            return;
        }
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        NSInteger payMode = buttonIndex == 0 ? 2 : 3;
        NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] initWithDictionary:[strongSelf needParameters]];
        mutableDict[@"payPasswd"] = [password GetMD5];
        mutableDict[@"remainAmount"] = @(remain);
        mutableDict[@"payMode"] = @(payMode);
        [strongSelf lackOfBalancePayWithParameter:mutableDict payMode:payMode];
    }];
    [sheet showInView:self.view];
}
#pragma mark -余额支付
- (void)lackOfBalancePayWithParameter:(NSDictionary*)parameter payMode:(NSInteger)payMode
{
    self.buyButton.enabled = NO;
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_MemberBalancePay
        parameters:parameter
        success:^(id responseData) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                        weakSelf.buyButton.enabled = YES;
            if ([self validatePassword:responseData]) {
                if (payMode == 2) {
                    [strongSelf alipay:responseData];
                }
                else {
                    [strongSelf wechatpay:responseData];
                }
            }
        }
        failure:^(NSString* errorMessage) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:strongSelf.view];
            strongSelf.buyButton.enabled = YES;
        }];
}
#pragma mark - 微信或支付宝支付
- (void)payWithAlipayOrWeixinpay
{
    self.buyButton.enabled = NO;
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSString* url = _selectPayIndex == 1 ? YC_Request_Alipay : YC_Request_Weixinpay;
    NSDictionary* parameter = [self needParameters];
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:url
        parameters:parameter
        success:^(id responseData) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            if (_selectPayIndex == 1) {
                [strongSelf alipay:responseData];
            }
            else {
                [strongSelf wechatpay:responseData];
            }
            weakSelf.buyButton.enabled = YES;
        }
        failure:^(NSString* errorMessage) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [MBProgressHUD showError:errorMessage toView:strongSelf.view];
            strongSelf.buyButton.enabled = YES;
        }];
}
- (BOOL)validatePassword:(id)responseData
{
    if (!responseData[@"resultCode"]) {
        return NO;
    }
    NSString *resultCode = responseData[@"resultCode"];
    if ([resultCode isEqualToString:kPayPasswdErroe]) {
        NSString* serviseStr = [NSString stringWithFormat:@"请联系客服%@", YT_Service_Number];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您输入的密码错误" message:serviseStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
        wSelf(wSelf);
        [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
            [wSelf callPhoneNumber:YT_Service_Number];
        }];
        [alert show];
        return NO;
    }
    return YES;
}
- (void)alipay:(id)responseData
{
    NSDictionary* dataDict = responseData[@"data"];
    if (!dataDict) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [[PayUtil sharedPayUtil]
        alipayOrder:dataDict[@"payInfo"]
         blackBlock:^(NSDictionary* dic) {
             __strong __typeof(weakSelf) strongSelf = weakSelf;
             strongSelf.toOuterId = dataDict[@"payOrder"][@"toOuterId"];
             if ([dic[@"resultStatus"] integerValue] == 9000) {
                 [strongSelf
                     receiveHongbaoWithOrderId:dataDict[
                                                   @"payOrder"][@"id"]];
             }
         }];
}
- (void)wechatpay:(id)responseData
{
    NSDictionary* dataDict = responseData[@"data"];
    if (!dataDict) {
        return;
    }
    __weak __typeof(self) weakSelf = self;
    [[PayUtil sharedPayUtil]
        weChatPayWithDictionary:dataDict
                     payorderId:nil
                     blackBlock:^(NSDictionary* dic) {
                         __strong __typeof(weakSelf) strongSelf = weakSelf;
                         strongSelf.toOuterId = dataDict[
                             @"payOrder"][@"toOuterId"];
                         [strongSelf
                             receiveHongbaoWithOrderId:
                                 dataDict[@"payOrder"][@"id"]];
                     }];
}
- (NSDictionary*)needParameters
{
    NSString* amount = [NSString
        stringWithFormat:@"%d", (int)([self.costValue floatValue] * 100)];
    NSInteger originAmount = [self.payTextView.textField.text floatValue] * 100;
    NSInteger subAmount =
        [self.notPreferenceView.payTextView.textField.text floatValue] * 100;
    NSString* authCode = self.authCode ?: @"";
    NSString* userHbId = @"";
    if (self.selectHbIndex >= 0 && self.userHbArray.count > 0) {
        NSDictionary* dic = self.shopModel.userHongbaos[self.selectHbIndex];
        userHbId = dic[@"id"];
    }
    NSDictionary* parameter = @{
        @"shopId" : self.shopModel.shopId,
        @"originAmount" : @(originAmount),
        @"amount" : amount,
        @"subAmount" : @(subAmount),
        @"message" : self.remarkView.textView.text,
        @"authCode" : authCode,
        @"userHongbaoIds[0]" : userHbId,
        @"payType" : @(self.payType)
    };
    return parameter;
}
#pragma mark - Event response
- (void)buyButtonClicked:(id)sender
{
    CGFloat costFloatValue = [self.payTextView.textField.text floatValue];
    if (costFloatValue < 0.01f) {
        [self showAlert:@"输入的金额不能小于0.01" title:@""];
        return;
    }

    if (self.payType == PreferencePayTypeHongbao && self.shopModel.userHongbaos.count > 0 && self.selectHbIndex == -1) {
        if (IOS8) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"确定不选红包直接支付吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction* done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
                [self placeOrder];
            }];
            [alert addAction:cancel];

            [alert addAction:done];

            [self presentViewController:alert animated:YES completion:NULL];
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc]
                    initWithTitle:@""
                          message:@"确定不选红包直接支付吗？"
                         delegate:nil
                cancelButtonTitle:@"取消"
                otherButtonTitles:@"确定", nil];
            __weak __typeof(self) weakSelf = self;
            [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0f), dispatch_get_main_queue(), ^{
                        __strong __typeof(weakSelf) strongSelf = weakSelf;
                        [strongSelf placeOrder];
                        ;
                    });
                }
            }];
            [alert show];
        }
    }
    else {
        [self placeOrder];
    }
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.view endEditing:YES];
    if (self.payType == PreferencePayTypeDiscount) {
        self.payType = PreferencePayTypeHongbao;
        self.navigationItem.rightBarButtonItem.title = @"使用折扣";
        [self showHongbao];
    }
    else if (self.payType == PreferencePayTypeSubtract) {
        self.payType = PreferencePayTypeHongbao;
        self.navigationItem.rightBarButtonItem.title = @"使用优惠";
        [self showHongbao];
    }
    else {
        self.navigationItem.rightBarButtonItem.title = @"使用红包";
        if (self.shopModel.subtractInTime) {
            self.payType = PreferencePayTypeSubtract;
            [self showFullSubtract];
        }
        else {
            self.payType = PreferencePayTypeDiscount;
            [self showDiscount];
        }
    }
}
#pragma mark - Page subviews
- (void)initializeData
{
    _didSelectNotPreference = NO;
    _selectPayIndex = 0;
    _selectHbIndex = -1;
    _userHbArray = [[NSMutableArray alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    _toOuterId = @"";
}
- (void)initializePageSubviews
{
    self.navigationItem.title = self.shopModel.shopName;
    [self validateMayChangeUserPayType];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.tableFooterView = self.remarkView;
    [self.headView addSubview:self.yellowView];
    [self.headView addSubview:self.payTextView];
    [self.headView addSubview:self.notPreferenceView];
    [self.view addSubview:self.buyButton];
    __weak __typeof(self) weakSelf = self;
    self.notPreferenceView.selectBlock = ^(BOOL select) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.didSelectNotPreference = select;
        if (select) {
            strongSelf.headView.dk_height += 66;
            strongSelf.notPreferenceView.dk_height += 51;
        }
        else {
            strongSelf.headView.dk_height -= 66;
            strongSelf.notPreferenceView.dk_height -= 51;
        }
        strongSelf.notPreferenceView.payTextView.textField.text = @"";
        if (strongSelf.payType == PreferencePayTypeHongbao) {
            [strongSelf showHongbao];
        }
        else if (strongSelf.payType == PreferencePayTypeSubtract) {
            [strongSelf showFullSubtract];
        }
        else {
            [strongSelf showDiscount];
        }
        strongSelf.tableView.tableHeaderView = strongSelf.headView;
    };

    if (self.shopModel.status == 4) {
        [self.buyButton
            setBackgroundImage:[UIImage
                                   createImageWithColor:[UIColor lightGrayColor]]
                      forState:UIControlStateNormal];
        self.buyButton.enabled = NO;
        [self.view addSubview:self.enterYellowView];
        self.enterYellowView.hidden = NO;
    }
    self.costValue = @"0";
    if (self.payPrice > 0) {
        self.payTextView.textField.text =
            [NSString stringWithFormat:@"%.2f", self.payPrice / 100.];
        self.payTextView.userInteractionEnabled = NO;
        [self ytPayTextView:nil textFieldWillEndEditing:self.payTextView.textField];
    }
}
- (void)validateMayChangeUserPayType
{
    if (!self.mayChange) {
        return;
    }
    if (self.shopModel.userHongbaos.count > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
            initWithTitle:@"使用红包"
                    style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(didRightBarButtonItemAction:)];
    }
    if (self.shopModel.promotionType == 2) {
        self.payType = PreferencePayTypeSubtract;
        return;
    }
    if (self.shopModel.promotionType == 1 && self.shopModel.isDiscount) {
        self.payType = PreferencePayTypeDiscount;
        return;
    }
    if (self.shopModel.userHongbaos.count > 0) {
        self.payType = PreferencePayTypeHongbao;
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
}
#pragma mark - Getters & Setters
- (void)setCostValue:(NSString*)costValue
{
    _costValue = costValue;
    NSMutableAttributedString* costAttributedStr =
        [[NSMutableAttributedString alloc]
            initWithString:[NSString stringWithFormat:@"实际支付:￥%@",
                                     _costValue]];
    [costAttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont boldSystemFontOfSize:16]
                              range:NSMakeRange(5, costValue.length + 1)];
    [costAttributedStr addAttribute:NSForegroundColorAttributeName
                              value:YTDefaultRedColor
                              range:NSMakeRange(5, costValue.length + 1)];
    self.payHeadView.costLabel.attributedText = costAttributedStr;
}
- (void)setPayType:(PreferencePayType)payType
{
    _payType = payType;
    if (payType == PreferencePayTypeHongbao) {
        self.dataArray = [[NSMutableArray alloc] initWithArray:self.userHbArray];
    }
    else {
        [self.dataArray removeAllObjects];
    }
    [self.tableView reloadData];
}
- (UITableView*)tableView
{
    if (!_tableView) {
        CGFloat editHeight = _shopId ? 64 : 0;
        _tableView = [[UITableView alloc]
            initWithFrame:CGRectMake(
                              0, editHeight, kDeviceWidth,
                              KDeviceHeight - kBottomStatsHeight - editHeight)
                    style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 60;
        [_tableView registerClass:[HbSelectTableCell class]
            forCellReuseIdentifier:HbCellIdentifier];
        [_tableView registerClass:[PayModeTableCell class]
            forCellReuseIdentifier:PayCellIdentifier];
    }
    return _tableView;
}
- (UIView*)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]
            initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHeaderHeight)];
    }
    return _headView;
}
- (YTPayTextView*)payTextView
{
    if (!_payTextView) {
        _payTextView = [[YTPayTextView alloc]
            initWithFrame:CGRectMake(0, 15, kDeviceWidth, 48)];
        _payTextView.delegate = self;
    }
    return _payTextView;
}
- (PayYellowView*)yellowView
{
    if (!_yellowView) {
        _yellowView = [[PayYellowView alloc]
            initWithFrame:CGRectMake(15, 31, kDeviceWidth - 30, 32)];
        _yellowView.leftLabel.text = [NSString
            stringWithFormat:@"折扣优惠 (%.1f折)", _shopModel.discount / 10.];
    }
    return _yellowView;
}
- (PayNotPreferenceView*)notPreferenceView
{
    if (!_notPreferenceView) {
        _notPreferenceView = [[PayNotPreferenceView alloc]
            initWithFrame:CGRectMake(0, _payTextView.dk_bottom + 15, kDeviceWidth,
                              30)];
        _notPreferenceView.clipsToBounds = YES;
        _notPreferenceView.delegate = self;
    }
    return _notPreferenceView;
}
- (PayModeHeadView*)payHeadView
{
    if (!_payHeadView) {
        _payHeadView = [[PayModeHeadView alloc]
            initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
    }
    return _payHeadView;
}
- (ShopDetailSectionHeadView*)hbHeadView
{
    if (!_hbHeadView) {
        _hbHeadView = [[ShopDetailSectionHeadView alloc]
            initWithFrame:CGRectMake(0, 25, kDeviceWidth, 45)];
        _hbHeadView.leftLabel.text = [NSString
            stringWithFormat:@"选择可使用的红包(%@)", @(_dataArray.count)];
    }
    return _hbHeadView;
}
- (YTPlaceTextView*)remarkView
{
    if (!_remarkView) {
        _remarkView = [[YTPlaceTextView alloc]
            initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
        _remarkView.delegate = self;
        _remarkView.placeholder = @"给商家留言,如我是8号桌...";
    }
    return _remarkView;
}
- (UIButton*)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kBottomStatsHeight,
            kDeviceWidth, kBottomStatsHeight);
        _buyButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_buyButton
            setBackgroundImage:[UIImage
                                   createImageWithColor:CCCUIColorFromHex(0xfd5c63)]
                      forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        [_buyButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_buyButton addTarget:self
                       action:@selector(buyButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}
- (YTYellowBackgroundView*)enterYellowView
{
    if (!_enterYellowView) {
        _enterYellowView = [[YTYellowBackgroundView alloc]
            initWithFrame:CGRectMake(0, _buyButton.dk_y - 30, kDeviceWidth, 30)];
        _enterYellowView.textLabel.text = @"商户未开通该服务";
        _enterYellowView.hidden = YES;
    }
    return _enterYellowView;
}
@end
