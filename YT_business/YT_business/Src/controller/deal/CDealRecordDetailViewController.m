
#import "DealHbIntroModel.h"
#import "CDealHbIntroTableCell.h"
#import "CDealRecordDetailViewController.h"
#import "CDealRecordTableSectionHeadView.h"
#import "HbDetailViewController.h"
#import "UIImage+HBClass.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+Helper.h"
#import "UIAlertView+TTBlock.h"
#import "HbPaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "YTTradeRefundModel.h"
#import "CDealPayRefundSuccessViewController.h"
#import "YTMessageModel.h"
#import "DealRecordDetailSalesTableCell.h"
#import "DealRecordDetailCutTableCell.h"
#import "DealRecordDetailUserHeadView.h"
#import "DealRecordDetailRemarkView.h"

static NSString* SalesCellIdentifier = @"DealRecordDetailSalesCellIdentifier";
static NSString* CutCellIdentifier = @"DealRecordDetailCutCellIdentifier";
static NSString* HbCellIdentifier = @"DealRecordDetailViewCellIdentifier";

@interface CDealRecordDetailViewController () <UITableViewDelegate,
    UITableViewDataSource> {
    UITableView* tradeDetailTableView;
    UIButton* refundBtn;
}

@property (strong, nonatomic) NSArray* dealArr;
@end

@implementation CDealRecordDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"账单详情";
    [self setupDealData];

    tradeDetailTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tradeDetailTableView.delegate = self;
    tradeDetailTableView.dataSource = self;
    tradeDetailTableView.backgroundColor = [UIColor whiteColor];
    tradeDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tradeDetailTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [tradeDetailTableView registerClass:[CDealHbIntroTableCell class] forCellReuseIdentifier:HbCellIdentifier];
    [tradeDetailTableView registerClass:[DealRecordDetailSalesTableCell class] forCellReuseIdentifier:SalesCellIdentifier];
    [tradeDetailTableView registerClass:[DealRecordDetailCutTableCell class] forCellReuseIdentifier:CutCellIdentifier];

    tradeDetailTableView.tableHeaderView = ({
        DealRecordDetailUserHeadView* headView = [[DealRecordDetailUserHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 70)];
        headView.imageUrl = self.trade.user.avatar;
        headView.name = self.trade.user.userName;
        headView;
    });

    tradeDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    [self.view addSubview:tradeDetailTableView];
    if (_trade.totalPrice >= 0 && _trade.isRefund == 1 && _trade.status == YTPAYSTATUS_PAYED) {
        refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [refundBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [refundBtn setTitle:@"退款" forState:UIControlStateNormal];
        [refundBtn addTarget:self action:@selector(refundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:refundBtn];
        [refundBtn makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(self.view);
        }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupDealData
{
    NSMutableArray* mutableArr = [[NSMutableArray alloc] init];
    NSString* originPrice = [NSString stringWithFormat:@"￥%.2f", self.trade.originPrice / 100.];
    YTMessageModel* messageOrgin = [[YTMessageModel alloc] initWithTitle:@"订单总额" message:originPrice];
    if (self.trade.payType == YTPAYTYPE_FACErREFUND) {
        [mutableArr addObject:messageOrgin];
    }
    else {
        NSString* shouxufei = [NSString stringWithFormat:@"-￥%.2f", self.trade.shouxvfei / 100.];
        NSString* totalPrice = @"";
        NSString* cashbackAmount = @"";
        if (self.trade.payType == YTPAYTYPE_FACEPAY) {
            CGFloat total = self.trade.originPrice - self.trade.shouxvfei + self.trade.shopCashbackAmount;
            totalPrice = [NSString stringWithFormat:@"￥%.2f", total / 100.];
            cashbackAmount = [NSString stringWithFormat:@"+￥%.2f", self.trade.shopCashbackAmount / 100.];
        }
        else {
            totalPrice = [NSString stringWithFormat:@"￥%.2f", self.trade.inCome / 100.];
            cashbackAmount = [NSString stringWithFormat:@"+￥%.2f", 1000 / 100.];
        }
        YTMessageModel* messageTotal = [[YTMessageModel alloc] initWithTitle:@"合计收入" message:totalPrice];

        YTMessageModel* messageCashbackAmount = [[YTMessageModel alloc] initWithTitle:@"平台补贴" message:cashbackAmount];

        YTMessageModel* messageShouxufei = [[YTMessageModel alloc] initWithTitle:@"手续费" message:shouxufei];

        [mutableArr addObject:messageTotal];
        [mutableArr addObject:messageOrgin];
        [mutableArr addObject:messageCashbackAmount];
        [mutableArr addObject:messageShouxufei];
        if (self.trade.payType == YTPAYTYPE_USERPAY) {
            NSString* prePrice = [NSString stringWithFormat:@"￥%.2f", (self.trade.originPrice - self.trade.totalPrice) / 100.];
            YTMessageModel* messagePreference = [[YTMessageModel alloc] initWithTitle:@"用户优惠" message:prePrice];
            [mutableArr addObject:messagePreference];
        }
    }
    self.dealArr = [[NSArray alloc] initWithArray:mutableArr];
}
#pragma mark -fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject error:(NSError*)requestErr
{
    if (parserObject.success) {
        if (self.refundBlock) {
            self.refundBlock();
        }
        if ([operation.urlTag isEqualToString:bizBarCancelPayURL] ||
            [operation.urlTag isEqualToString:saleCancelPayURL] ||
            [operation.urlTag isEqualToString:cancelWeiXinBarPayURL] ||
            [operation.urlTag isEqualToString:saleCancelWeiXinBarPayURL]) {
            YTTradeRefundModel* tradeModel = (YTTradeRefundModel*)parserObject;
            CDealPayRefundSuccessViewController* dealPayRefundVC = [[CDealPayRefundSuccessViewController alloc] init];
            dealPayRefundVC.amount = [NSString stringWithFormat:@"￥%.2f", _trade.totalPrice / 100.];
            dealPayRefundVC.trade = tradeModel.trade;
            [self.navigationController pushViewController:dealPayRefundVC animated:YES];
        }
        else {
            HbPaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbPaySuccessViewController class]];
            paySuccessVC.viewMode = PaySuccessViewModeRefundPay;
            [self.navigationController pushViewController:paySuccessVC animated:YES];
        }
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.trade.userHongbaos.count + 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dealArr.count + 1;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == self.dealArr.count) {
            return 100;
        }
        return 50;
    }
    return 70;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    if (section == 1) {
        return 24;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section != 0 || self.trade.payType != YTPAYTYPE_USERPAY) {
        return CGFLOAT_MIN;
    }
    return [DealRecordDetailRemarkView remarkHeight:self.trade.trademessage];
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 1) {
        return nil;
    }
    CDealRecordTableSectionHeadView* headView = [[CDealRecordTableSectionHeadView alloc] init];
    headView.titleLeftOffset = 10;
    headView.titleLabel.textColor = CCCUIColorFromHex(0x999999);
    headView.titleLabel.text = @"领取红包";
    headView.hideBottomLine = YES;
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 0 || self.trade.payType != YTPAYTYPE_USERPAY) {
        return nil;
    }
    DealRecordDetailRemarkView* remarkView = [[DealRecordDetailRemarkView alloc] init];
    remarkView.remark = self.trade.trademessage;
    return remarkView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row < self.dealArr.count) {
            DealRecordDetailSalesTableCell* cell = [tableView dequeueReusableCellWithIdentifier:SalesCellIdentifier];
            if (indexPath.row == 0) {
                cell.titleLabel.textColor = [UIColor blackColor];
            }
            else {
                cell.titleLabel.textColor = CCCUIColorFromHex(0x666666);
            }
            if (indexPath.row == 1) {
                cell.describeLabel.textColor = [UIColor blackColor];
            }
            else {
                cell.describeLabel.textColor = YTDefaultRedColor;
            }
            YTMessageModel* messageM = [self.dealArr objectAtIndex:indexPath.row];
            cell.titleLabel.text = messageM.title;
            cell.describeLabel.text = messageM.message;
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            return cell;
        }
        else {
            DealRecordDetailCutTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CutCellIdentifier];
            [cell configDealRecordDetailCut:self.trade];
            return cell;
        }
    }
    else {
        CDealHbIntroTableCell* cell = [tableView dequeueReusableCellWithIdentifier:HbCellIdentifier];
        NSInteger hongbaoSection = indexPath.section - 1;
        if (hongbaoSection < self.trade.userHongbaos.count) {
            YTHongBao* hongbao = [self.trade.userHongbaos objectAtIndex:hongbaoSection];
            [cell configDealHbIntroCellWithIntroModel:hongbao];
        }
        return cell;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section < self.trade.userHongbaos.count) {
        YTHongBao* hongbao = (YTHongBao*)[self.trade.userHongbaos objectAtIndex:indexPath.section];
        HbDetailViewController* hbDetailVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbDetailViewController class]];
        hbDetailVC.hbId = hongbao.hongbao.indexId;
        hbDetailVC.controllerMode = HbDetailViewModeVisitor;
        [self.navigationController pushViewController:hbDetailVC animated:YES];
    }
}

#pragma mark - Event response
- (void)refundButtonClicked:(id)sender
{
    //    CGFloat total = [_trade promotionTotalPrice];
    //    NSString* priceStr = [NSString stringWithFormat:@"￥%.2f",total/100.];
    //    NSString* messageStr = [NSString stringWithFormat:@"金额 %@", priceStr];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"是否确定退款?" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退款", nil];
    __weak __typeof(self) weakSelf = self;
    [alertView setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf userDidRefundPay];
        }
    }];
    [alertView show];
}

#pragma mark - Private methods
- (void)userDidRefundPay
{
    //当面付退款
    if (_trade.payType == YTPAYTYPE_FACEPAY) {
        self.requestParas = @{ @"out_trade_no" : _trade.toOuterId,
            loadingKey : @(YES) };
        if ([YTUsr usr].type == LoginViewTypeBusiness) {
            if (_trade.payChannel == YTPayTypeZfb) {
                self.requestURL = bizBarCancelPayURL;
            }
            else {
                self.requestURL = cancelWeiXinBarPayURL;
            }
        }
        else {
            if (_trade.payChannel == YTPayTypeZfb) {
                self.requestURL = saleCancelPayURL;
            }
            else {
                self.requestURL = saleCancelWeiXinBarPayURL;
            }
        }
    }
    else if (_trade.payType == YTPAYTYPE_USERPAY) {
        self.requestParas = @{ @"payOrderId" : _trade.tradeId,
            loadingKey : @(YES) };
        if ([YTUsr usr].type == LoginViewTypeBusiness) {
            self.requestURL = refundToUserURL;
        }
        else {
            self.requestURL = saleRefundToUserURL;
        }
    }
}
@end
