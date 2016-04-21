#import "ApplySuccessViewController.h"
#import "MBProgressHUD+Add.h"
#import "OederRefunfViewController.h"
#import "OrderRefundFooterView.h"
#import "OrderRefundHbTableCell.h"
#import "OrderRefundTextFieldView.h"
#import "PromotionHbDetailViewController.h"
#import "UIViewController+Helper.h"
#import "YTOrderModel.h"
#import "YTPayTableCell.h"
#import "YTSignTextView.h"
#import "YTYellowBackgroundView.h"

static NSString* HbCellIdentifier = @"OederRefunfHBCellIdentifier";
static NSString* PayCellIdentifier = @"OederRefunfPayCellIdentifier";
static NSString* CauseCellIdentifier = @"OederRefunfCauseCellIdentifier";

static const NSInteger kRefundNumTag = 2000;
static const NSInteger kRefundMessageTag = 2001;

@interface OederRefunfViewController () <UITableViewDataSource, UITableViewDelegate, OrderRefundFieldViewDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) OrderRefundFooterView* footerView;
@property (nonatomic, copy) NSArray* refundCauses;
@property (nonatomic, assign) NSInteger selectCauseIndex;
@property (nonatomic, assign) NSInteger selectHbIndex;
@property (nonatomic, assign) NSInteger refundHongbaoNum;
@property (nonatomic, copy) NSString* refundMessage;
@end

@implementation OederRefunfViewController
#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"申请退款";
    [self initializeData];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (parserObject.success) {
        ApplySuccessViewController* applySuccessVC = [[ApplySuccessViewController alloc] initWithNibName:NSStringFromClass([ApplySuccessViewController class]) bundle:nil];
        applySuccessVC.navigationItem.leftBarButtonItem = nil;
        [self.navigationController pushViewController:applySuccessVC animated:YES];
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.order.shopBuyHongbaos.count;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return self.refundCauses.count;
    }
    else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 2) {
        return 45;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != 1) {
        return 60;
    }
    return 15;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    YTSignTextView* headerView = [[YTSignTextView alloc] init];
    headerView.displayTop = YES;
    headerView.titleLabel.text = section == 1 ? @"现金退款方" : @"退款原因";
    return headerView;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return nil;
    }
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
    OrderRefundTextFieldView* textFieldView = [[OrderRefundTextFieldView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 46)];
    textFieldView.delegate = self;
    if (section == 0) {
        textFieldView.placeholder = @"请输入退款红包数量(最多20个)";
        textFieldView.keyboardType = UIKeyboardTypeNumberPad;
        textFieldView.tag = kRefundNumTag;
        if (self.refundHongbaoNum != 0) {
            textFieldView.textField.text = [NSString stringWithFormat:@"%@", @(self.refundHongbaoNum)];
        }
        //        [textFieldView.textField addTarget:self action:@selector(textValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    else {
        textFieldView.placeholder = @"请输入退款说明(可不填)";
        textFieldView.keyboardType = UIKeyboardTypeDefault;
        textFieldView.tag = kRefundMessageTag;
        textFieldView.textField.text = self.refundMessage;
    }
    [footerView addSubview:textFieldView];
    return footerView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        OrderRefundHbTableCell* cell = [tableView dequeueReusableCellWithIdentifier:HbCellIdentifier];
        YTCommonHongBao* hongbao = _order.shopBuyHongbaos[indexPath.row];
        cell.selectBtn.selected = YES;
        [cell configOrderRefundTableCellModel:hongbao];
        return cell;
    }
    else if (indexPath.section == 1) {
        YTPayTableCell* cell = [tableView dequeueReusableCellWithIdentifier:PayCellIdentifier];
        cell.payType = _order.payType;
        cell.accessoryView = [[UIImageView alloc]
            initWithImage:[UIImage imageNamed:@"is_select_red"]];
        return cell;
    }
    else if (indexPath.section == 2) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CauseCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = CCCUIColorFromHex(0x333333);
        UIImage* normalImage = [UIImage imageNamed:@"un_select"];
        UIImage* selectImage = [UIImage imageNamed:@"is_select_red"];
        cell.textLabel.text = _refundCauses[indexPath.row];
        cell.accessoryView = [[UIImageView alloc]
            initWithImage:_selectCauseIndex == indexPath.row ? selectImage
                                                             : normalImage];

        return cell;
    }
    else {
        return [[UITableViewCell alloc] init];
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        YTCommonHongBao* commonHongbao = _order.shopBuyHongbaos[indexPath.row];
        PromotionHbDetailViewController* hbDetailVC = [[PromotionHbDetailViewController alloc] initWithHbId:commonHongbao.hongbaoId];
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
    else if (indexPath.section == 1) {
        return;
    }
    else if (indexPath.section == 2) {
        if (_selectCauseIndex == indexPath.row) {
            return;
        }
        _selectCauseIndex = indexPath.row;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                 withRowAnimation:UITableViewRowAnimationNone];
    }
    else {
        return;
    }
}
#pragma mark - OrderRefundFieldViewDelegate
- (void)orderRefundTextFieldView:(OrderRefundTextFieldView*)fieldView textFieldShouldBeginEditing:(UITextField*)textField
{
    if (fieldView.tag == kRefundNumTag) {
        return;
    }
    CGPoint pointInTable =
        [fieldView.superview convertPoint:fieldView.frame.origin
                                   toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = (216 + 64 + 44) - (CGRectGetHeight(self.tableView.bounds) - pointInTable.y);
    [self.tableView setContentOffset:contentOffset animated:YES];
}
- (void)orderRefundTextFieldView:(OrderRefundTextFieldView*)fieldView textFieldDidEndEditing:(UITextField*)textField
{
    if (fieldView.tag == kRefundNumTag) {
        self.refundHongbaoNum = [textField.text integerValue];
        [self validRefundHongbaoNum];
    }
    else {
        self.refundMessage = textField.text;
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)orderRefundTextFieldView:(OrderRefundTextFieldView*)fieldView textFieldShouldReturn:(UITextField*)textField
{
    [self.view endEditing:YES];
}
#pragma mark - Event response
- (void)textValueDidChange:(UITextField*)textField
{
}
#pragma mark - Private methods
- (void)applyRefund
{
    if (![self validRefundCause]) {
        return;
    }
    NSString* reason = @"";
    if ([NSStrUtil notEmptyOrNull:self.refundMessage]) {
        reason = self.refundMessage;
    }
    else if (self.selectCauseIndex >= 0 && self.refundCauses.count > self.selectCauseIndex) {
        reason = self.refundCauses[_selectCauseIndex];
    }
    YTCommonHongBao* commonHongbao = [_order.shopBuyHongbaos firstObject];
    self.requestParas = @{ @"refundList[0].num" : @(self.refundHongbaoNum),
        @"refundList[0].hongbaoId" : commonHongbao.hongbaoId,
        @"shopOrderId" : _order.orderId,
        @"reason" : reason,
        loadingKey : @(YES) };
    self.requestURL = refundPayHongbaoURL;
}
- (void)displayRefundHongbaoAmountWithHongbaoNum:(NSInteger)hongbaoNum
{
    self.footerView.hongbaoNum = hongbaoNum;
    YTCommonHongBao* commonHongbao = [_order.shopBuyHongbaos firstObject];
    self.footerView.amount = hongbaoNum * commonHongbao.price / 100.;
}
- (BOOL)validRefundHongbaoNum
{
    [self.view endEditing:YES];
    YTCommonHongBao* commonHongbao = [_order.shopBuyHongbaos firstObject];
    if (self.refundHongbaoNum == 0) {
        [self showAlert:@"请输入红包数量" title:@""];
        return NO;
    }
    else if (self.refundHongbaoNum > commonHongbao.remainNum) {
        [self showAlert:@"退款红包数量超过剩余数量" title:@""];
        self.refundHongbaoNum = commonHongbao.remainNum;
        return NO;
    }

    else if (self.refundHongbaoNum > 20) {
        [self showAlert:@"退款红包数量不能超过20" title:@""];
        self.refundHongbaoNum = 20;
        return NO;
    }
    else {
        return YES;
    }
}
- (BOOL)validRefundCause
{
    if (![self validRefundHongbaoNum]) {
        return NO;
    }
    if (_selectCauseIndex == -1 && [NSStrUtil isEmptyOrNull:self.refundMessage]) {
        [self showAlert:@"请至少选择一项或输入原因" title:@""];
        return NO;
    }
    return YES;
}
#pragma mark - Page subviews
- (void)initializeData
{
    self.refundCauses = @[ @"买多了/买错了", @"领取效果不好" ];
    self.selectCauseIndex = -1;
    self.selectHbIndex = -1;
    self.refundHongbaoNum = 0;
    self.refundMessage = @"";
}
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_footerView.top);
    }];
    self.tableView.tableHeaderView = ({
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 42)];
        YTYellowBackgroundView* yellowView = [[YTYellowBackgroundView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 30)];
        yellowView.textLabel.text = @"7天内无理由退款";
        [headView addSubview:yellowView];
        headView;
    });
    __weak __typeof(self) weakSelf = self;
    self.footerView.refundBlock = ^() {
        [weakSelf applyRefund];
    };
}
#pragma mark - Getters & Setters
- (void)setRefundHongbaoNum:(NSInteger)refundHongbaoNum
{
    _refundHongbaoNum = refundHongbaoNum;
    if (refundHongbaoNum == 0) {
        return;
    }
    OrderRefundTextFieldView* numView = [self.tableView viewWithTag:kRefundNumTag];
    numView.textField.text = [NSString stringWithFormat:@"%@", @(refundHongbaoNum)];
    [self displayRefundHongbaoAmountWithHongbaoNum:refundHongbaoNum];
}
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[OrderRefundHbTableCell class] forCellReuseIdentifier:HbCellIdentifier];
        [_tableView registerClass:[YTPayTableCell class] forCellReuseIdentifier:PayCellIdentifier];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CauseCellIdentifier];
    }
    return _tableView;
}
- (OrderRefundFooterView*)footerView
{
    if (!_footerView) {
        _footerView = [[OrderRefundFooterView alloc] init];
        _footerView.amount = 0.00f;
        _footerView.hongbaoNum = 0;
    }
    return _footerView;
}
@end
