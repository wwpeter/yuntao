#import "HbPaySuccessViewController.h"
#import "MBProgressHUD+Add.h"
#import "OederRefunfViewController.h"
#import "OrderDetailHeadView.h"
#import "OrderDetailSectionFooterView.h"
#import "OrderDetailSectionHeadView.h"
#import "OrderDetailTableCell.h"
#import "OrderDetailViewController.h"
#import "PromotionHbDetailViewController.h"
#import "ShopDetailViewController.h"
#import "StoryBoardUtilities.h"
#import "UIImage+HBClass.h"
#import "UIView+BlockGesture.h"
#import "UIViewController+Helper.h"
#import "WXApi.h"
#import "YTHongbaoPayModel.h"
#import "YTOrderModel.h"
#import "YTVenderDefine.h"
#import "YTWechatPayModel.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString* CellIdentifier = @"OrderDetailCellIdentifier";

@interface OrderDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* dealPayBtn;
@property (nonatomic, strong) YTWechatPayModel* wechatPayModel;

@end

@implementation OrderDetailViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [NOTIFICENTER removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NOTIFICENTER addObserver:self
                     selector:@selector(wechatPayRespNotification:)
                         name:kWechatPayRespNotification
                       object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NOTIFICENTER removeObserver:self name:kWechatPayRespNotification object:nil];
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
        if ([operation.urlTag isEqualToString:continueAlipayURL]) {
            YTHongbaoPayModel* hongbaoPayModel = (YTHongbaoPayModel*)parserObject;
            wSelf(wSelf);
            [[AlipaySDK defaultService] payOrder:hongbaoPayModel.hongbaoPay.payInfo
                                      fromScheme:kAlipayScheme
                                        callback:^(NSDictionary* resultDic) {
                                            __strong __typeof(wSelf) strongSelf = wSelf;
                                            strongSelf.requestParas = [[NSDictionary alloc] initWithDictionary:resultDic];
                                            strongSelf.requestURL = alipayResultURL;
                                            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                                                [strongSelf hongbaoDidBuySuccess];
                                            }
                                        }];
        }
        else if ([operation.urlTag isEqualToString:continueWeixinURL]) {
            _wechatPayModel = (YTWechatPayModel*)parserObject;
            PayReq* request = [[PayReq alloc] init];
            request.partnerId = _wechatPayModel.wechatPay.wechatReqData.partnerId;
            request.prepayId = _wechatPayModel.wechatPay.wechatReqData.prepayId;
            request.package = _wechatPayModel.wechatPay.wechatReqData.packageValue;
            request.nonceStr = _wechatPayModel.wechatPay.wechatReqData.nonceStr;
            request.timeStamp = _wechatPayModel.wechatPay.wechatReqData.timeStamp;
            request.sign = _wechatPayModel.wechatPay.wechatReqData.sign;
            [WXApi sendReq:request];
        }
        else if ([operation.urlTag isEqualToString:alipayResultURL] ||
            [operation.urlTag isEqualToString:weiXinPayResultURL]) {
            if (self.successBlock) {
                self.successBlock();
            }
        }
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _order.shopBuyHongbaos.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (_order.status == YTORDERSTATUS_SUCCESS) {
        return 162;
    }
    return 116;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderDetailSectionHeadView* sectionHeadView = [[OrderDetailSectionHeadView alloc] init];
    sectionHeadView.titleLabel.text = _order.sellerShopName;
    __weak __typeof(self) weakSelf = self;
    [sectionHeadView addTapActionWithBlock:^(UIGestureRecognizer* gestureRecoginzer) {
        ShopDetailViewController* shopDetailVC = [[ShopDetailViewController alloc] initWithShopId:weakSelf.order.sellerShopId];
        [weakSelf.navigationController pushViewController:shopDetailVC animated:YES];
    }];
    return sectionHeadView;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    OrderDetailSectionFooterView* sectionFooterView = [[OrderDetailSectionFooterView alloc] init];
    [sectionFooterView configOrderDetailWithModel:_order];
    __weak __typeof(self) weakSelf = self;
    sectionFooterView.refundBlock = ^() {
        [weakSelf orderRefund];
    };
    return sectionFooterView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    OrderDetailTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    YTCommonHongBao* commonHongbao = _order.shopBuyHongbaos[indexPath.row];
    [cell configOrderDetailTableCellModel:commonHongbao];

    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTCommonHongBao* commonHongbao = _order.shopBuyHongbaos[indexPath.row];
    PromotionHbDetailViewController* hbDetailVC = [[PromotionHbDetailViewController alloc] initWithHbId:commonHongbao.hongbaoId];
    [self.navigationController pushViewController:hbDetailVC animated:YES];
}
#pragma mark - Event response
- (void)payButtonDidClicked:(id)sender
{
    self.requestParas = @{ @"payOrderId" : self.order.orderId,
        loadingKey : @(YES) };
    if (self.order.payType == YTPayTypeZfb) {
        self.requestURL = continueAlipayURL;
    }
    else {
        self.requestURL = continueWeixinURL;
    }
}
#pragma mark - Wechat onResp NSNotification
- (void)wechatPayRespNotification:(NSNotification*)notification
{
    PayResp* response = (PayResp*)[notification object];
    if (response.errCode == WXSuccess) {
        self.requestParas = @{ @"shopOrderId" : _wechatPayModel.wechatPay.shopOrder.shopOrderId };
        self.requestURL = weiXinPayResultURL;
        [self hongbaoDidBuySuccess];
    }
    else {
        [self showAlert:@"支付失败" title:@""];
    }
}
#pragma mark - Private methods
- (void)orderRefund
{
    OederRefunfViewController* orderRefundVC = [[OederRefunfViewController alloc] init];
    orderRefundVC.order = _order;
    [self.navigationController pushViewController:orderRefundVC animated:YES];
}
- (void)hongbaoDidBuySuccess
{
    HbPaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbPaySuccessViewController class]];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.dealPayBtn];
    [_dealPayBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(self.order.status == YTORDERSTATUS_WAITEPAY ? 45 : 0);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_dealPayBtn.top);
    }];
    self.tableView.tableHeaderView = ({
        OrderDetailHeadView* headView = [[OrderDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 90)];
        [headView configDetailWithModel:self.order];
        headView;
    });
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        [_tableView registerClass:[OrderDetailTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (UIButton*)dealPayBtn
{
    if (!_dealPayBtn) {
        _dealPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dealPayBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_dealPayBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_dealPayBtn setTitle:@"完成支付" forState:UIControlStateNormal];
        [_dealPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dealPayBtn addTarget:self action:@selector(payButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        _dealPayBtn.hidden = YES;
    }
    return _dealPayBtn;
}
@end
