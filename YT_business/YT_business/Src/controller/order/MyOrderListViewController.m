#import "MyOrderListViewController.h"
#import "UIImage+HBClass.h"
#import "OrderCellHeadView.h"
#import "OrderCellFootView.h"
#import "HbOrderConfirmTableCell.h"
#import "HbEmptyView.h"
#import "YTOrderModel.h"
#import "YTRefundOrderModel.h"
#import "MBProgressHUD+Add.h"
#import "YTNavigationController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "YTHongbaoPayModel.h"
#import "UIViewController+Helper.h"
#import "YTVenderDefine.h"
#import "ShopDetailViewController.h"
#import "RESideMenu.h"
#import "YTWechatPayModel.h"
#import "WXApi.h"
#import "OrderDetailViewController.h"

static NSString* CellIdentifier = @"OrderConfirmCellIdentifier";

@interface MyOrderListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* orderListTable;
@property (strong, nonatomic) UIButton* buyMoreButton;
@property (strong, nonatomic) HbEmptyView* emptyView;

@property (strong, nonatomic) NSMutableArray* orderList;
@property (strong, nonatomic) YTWechatPayModel* wechatPayModel;
@end

@implementation MyOrderListViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [NOTIFICENTER removeObserver:self];
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (instancetype)initWithOrderListVieType:(MyOrderListViewType)type
{
    self = [super init];
    if (self) {
        _viewType = type;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    _orderList = [[NSMutableArray alloc] init];
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
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    int currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        currPage = 1;
    }
    else {
        ++currPage;
    }
    self.requestParas = @{ @"pageSize" : @(20),
        @"pageNum" : @(currPage),
        isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = (self.viewType == MyOrderListViewTypePayment ? orderHongbaoURL : refundHongbaoURL);
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
                                                [strongSelf.orderListTable triggerPullToRefresh];
                                            }
                                            else {
                                                //                                                [strongSelf showAlert:@"支付失败！" title:@""];
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
                 [operation.urlTag isEqualToString:weiXinPayResultURL] ) {
             [self.orderListTable triggerPullToRefresh];
        }
        else if ([operation.urlTag isEqualToString:orderHongbaoURL] ||
                 [operation.urlTag isEqualToString:refundHongbaoURL]) {
            int countNum;
            if (self.viewType == MyOrderListViewTypePayment) {
                YTOrderModel* orderModel = (YTOrderModel*)parserObject;
                countNum = orderModel.orderSet.totalCount;
                if (!operation.isLoadingMore) {
                    self.orderList = [NSMutableArray arrayWithArray:orderModel.orderSet.records];
                }
                else {
                    [self.orderList addObjectsFromArray:orderModel.orderSet.records];
                }
            }
            else {
                YTRefundOrderModel* refundOrderModel = (YTRefundOrderModel*)parserObject;
                countNum = refundOrderModel.refundOrderInfo.refundOrderSet.totalCount;
                if (!operation.isLoadingMore) {
                    self.orderList = [NSMutableArray arrayWithArray:refundOrderModel.refundOrderInfo.refundOrderSet.records];
                }
                else {
                    self.orderList = [NSMutableArray arrayWithArray:refundOrderModel.refundOrderInfo.refundOrderSet.records];
                }
                [self.orderListTable.pullToRefreshView stopAnimating];
            }
            [self.orderListTable reloadData];
            if (self.orderList.count < countNum) {
                self.orderListTable.showsInfiniteScrolling = YES;
            }
            else {
                self.orderListTable.showsInfiniteScrolling = NO;
            }
            [self showEmptyView];
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
    if (!operation.isLoadingMore) {
        [self.orderListTable.pullToRefreshView stopAnimating];
    }
    else {
        [self.orderListTable.infiniteScrollingView stopAnimating];
    }
}
#pragma mark - Wechat onResp NSNotification
- (void)wechatPayRespNotification:(NSNotification*)notification
{
    PayResp* response = (PayResp*)[notification object];
    if (response.errCode == WXSuccess) {
        self.requestParas = @{ @"shopOrderId" : _wechatPayModel.wechatPay.shopOrder.shopOrderId };
        self.requestURL = weiXinPayResultURL;
    }
    else {
        [self showAlert:@"支付失败" title:@""];
    }
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _orderList.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.viewType == MyOrderListViewTypePayment){
        YTOrder* order = _orderList[section];
        return order.shopBuyHongbaos.count;
    }else{
        YTRefundOrder *refundOrder = _orderList[section];
        return refundOrder.refundOrderDetails.count;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44 + 15;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.viewType == MyOrderListViewTypePayment) {
        YTOrder* order = _orderList[section];
        if (order.status == 1) {
            return 88;
        }
    }
    return 44;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    
    OrderCellHeadView* headView = [[OrderCellHeadView alloc] init];
    if (self.viewType == MyOrderListViewTypePayment){
        YTOrder* order = _orderList[section];
        headView.titleLabel.text = order.sellerShopName;
        [headView configStatusLabel:order.status viewType:self.viewType];
        wSelf(wSelf);
        headView.actionBlock = ^() {
            ShopDetailViewController* shopDetailVC = [[ShopDetailViewController alloc] initWithShopId:order.sellerShopId];
            [wSelf.navigationController pushViewController:shopDetailVC animated:YES];
        };
    }else{
        YTRefundOrder *refundOrder = _orderList[section];
        headView.titleLabel.text = refundOrder.name;
        [headView configStatusLabel:refundOrder.status viewType:self.viewType];
//        wSelf(wSelf);
//        headView.actionBlock = ^() {
//            ShopDetailViewController* shopDetailVC = [[ShopDetailViewController alloc] initWithShopId:refundOrder.sellerShopId];
//            [wSelf.navigationController pushViewController:shopDetailVC animated:YES];
//        };
    }


    return headView;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    YTOrder* order = _orderList[section];
    OrderCellFootView* footView = [[OrderCellFootView alloc] init];
    [footView configOrderFootViewWithOrder:order];
    if (order.status == 1) {
        footView.showPayButton = YES;
        wSelf(wSelf);
        footView.payBlock = ^() {
            __strong __typeof(wSelf) strongSelf = wSelf;
            strongSelf.requestParas = @{ @"payOrderId" : order.orderId,
                loadingKey : @(YES) };
            if (order.payType == YTPayTypeZfb) {
                strongSelf.requestURL = continueAlipayURL;
            }
            else {
                strongSelf.requestURL = continueWeixinURL;
            }

        };
    }
    return footView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    HbOrderConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    YTOrder* order = _orderList[indexPath.section];
    if (indexPath.row < order.shopBuyHongbaos.count) {
        YTCommonHongBao* commonHongbao = (YTCommonHongBao*)[order.shopBuyHongbaos objectAtIndex:indexPath.row];
        [cell configHbOrderConfirmCellModel:commonHongbao];

        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    YTOrder* order = _orderList[indexPath.section];
    OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc] init];
    orderDetailVC.order = order;
    __weak __typeof(self)weakSelf = self;
    orderDetailVC.successBlock = ^(){
        [weakSelf.orderListTable triggerPullToRefresh];
    };
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}
#pragma mark - Event response
- (void)buyMoreButtonClicked:(id)sender
{
    [self showContentViewControllerAtIndex:3];
}

#pragma mark - Private methods
- (void)showEmptyView
{
    if (self.orderList.count == 0) {
        [self.view addSubview:self.emptyView];
        [self.view addSubview:self.buyMoreButton];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.mas_equalTo(self.view);
        }];
        [_buyMoreButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.bottom.mas_equalTo(self.view);
            make.height.mas_equalTo(50);
        }];
    }
    else {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
        }
        if (_buyMoreButton) {
            [_buyMoreButton removeFromSuperview];
        }
    }
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.orderListTable];
    [_orderListTable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(self.view);
    }];
    wSelf(wSelf);
    // refresh
    [self.orderListTable addYTPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [self.orderListTable addYTInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    self.orderListTable.showsInfiniteScrolling = NO;
    [self.orderListTable triggerPullToRefresh];
}
#pragma mark - Getters & Setters
- (UITableView*)orderListTable
{
    if (!_orderListTable) {
        _orderListTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _orderListTable.delegate = self;
        _orderListTable.dataSource = self;
        _orderListTable.backgroundColor = [UIColor clearColor];
        _orderListTable.rowHeight = 60;
        [_orderListTable registerClass:[HbOrderConfirmTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _orderListTable;
}
- (UIButton*)buyMoreButton
{
    if (!_buyMoreButton) {
        _buyMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyMoreButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_buyMoreButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_buyMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyMoreButton setTitle:@"购买红包" forState:UIControlStateNormal];
        [_buyMoreButton addTarget:self action:@selector(buyMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyMoreButton;
}
- (HbEmptyView*)emptyView
{
    if (!_emptyView) {
        _emptyView = [[HbEmptyView alloc] init];

        _emptyView.iconImageView.image = [UIImage imageNamed:@"hb_emptu_icon.png"];
        _emptyView.titleLabel.text = @"没有红包";
        _emptyView.displayArrow = YES;
        NSString* description = @"点击这里购买红包吧!";
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:description];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 2)];
        _emptyView.descriptionLabel.attributedText = str;
    }
    return _emptyView;
}
@end
