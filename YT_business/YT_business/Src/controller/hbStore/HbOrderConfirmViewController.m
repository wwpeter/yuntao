
#import "YTOrderModel.h"
#import "YTPayHeadView.h"
#import "UIImage+HBClass.h"
#import "OrderCellHeadView.h"
#import "OrderCellFootView.h"
#import "StoryBoardUtilities.h"
#import "HbOrderConfirmTableCell.h"
#import "HbPaySuccessViewController.h"
#import "HbOrderConfirmViewController.h"
#import "YTHongbaoStoreHelper.h"
#import "MBProgressHUD+Add.h"
#import "YTHongbaoPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIViewController+Helper.h"
#import "YTVenderDefine.h"
#import "YTWechatPayModel.h"
#import "WXApi.h"

static NSString* CellIdentifier = @"OrderConfirmCellIdentifier";

@interface HbOrderConfirmViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) YTPayHeadView* payHeadView;
@property (strong, nonatomic) UIButton* bookingButton;
@property (strong, nonatomic) YTWechatPayModel* wechatPayModel;
@end

@implementation HbOrderConfirmViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"订单确认";
    [self initializePageSubviews];
    [NOTIFICENTER addObserver:self
                     selector:@selector(wechatPayRespNotification:)
                         name:kWechatPayRespNotification
                       object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:buyHongbaoUseAlipayURL]) {
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
                                            else {
                                                //                    [strongSelf showAlert:@"支付失败！" title:@""];
                                            }
                                        }];
        }
        else if ([operation.urlTag isEqualToString:buyHongbaoUseWeiXinURL]) {
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
    }
    else {
        [self showAlert:parserObject.message title:@""];
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
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _orderArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    YTOrder* order = _orderArray[section];
    return order.shopBuyHongbaos.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44 + 15;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    YTOrder* order = _orderArray[section];
    OrderCellHeadView* headView = [[OrderCellHeadView alloc] init];
    headView.titleLabel.text = order.sellerShopName;
    return headView;
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    YTOrder* order = _orderArray[section];
    OrderCellFootView* footView = [[OrderCellFootView alloc] init];
    [footView configOrderFootViewWithOrder:order];
    return footView;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    HbOrderConfirmTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    YTOrder* order = _orderArray[indexPath.section];
    if (indexPath.row < order.shopBuyHongbaos.count) {
        YTCommonHongBao* commonHongbao = (YTCommonHongBao*)[order.shopBuyHongbaos objectAtIndex:indexPath.row];
        [cell configHbOrderConfirmCellModel:commonHongbao];

        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    }
    return cell;
}
#pragma mark - Event response
- (void)bookingButtonClicked:(id)sender
{
    [MBProgressHUD showMessag:@"" toView:self.navigationController.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGFloat totalPrice = 0;
        NSMutableDictionary* orderDic = [[NSMutableDictionary alloc] init];
        NSInteger i = 0;
        for (YTOrder* order in _orderArray) {
            totalPrice += order.totalPrice;
            for (YTCommonHongBao* commonHongbao in order.shopBuyHongbaos) {
                NSString* hongbaoIdKey = [NSString stringWithFormat:@"buyList[%@].hongbaoId", @(i)];
                NSString* hongbaoNumKey = [NSString stringWithFormat:@"buyList[%@].num", @(i)];
                orderDic[hongbaoIdKey] = commonHongbao.indexId;
                orderDic[hongbaoNumKey] = @(commonHongbao.num);
                i++;
            }
        }
        orderDic[@"totalPrice"] = @(totalPrice);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.requestParas = [[NSDictionary alloc] initWithDictionary:orderDic];
            if (self.payHeadView.payType == YTPayTypeZfb) {
                self.requestURL = buyHongbaoUseAlipayURL;
            }
            else {
                self.requestURL = buyHongbaoUseWeiXinURL;
            }
        });
    });
}
#pragma mark - Public methods
#pragma mark - Private methods
- (void)hongbaoDidBuySuccess
{
    [[YTHongbaoStoreHelper hongbaoStoreHelper] cleanOrder];
    [NOTIFICENTER postNotificationName:kHbStoreBuySuccessNotification
                                object:nil];
    HbPaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbPaySuccessViewController class]];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bookingButton];
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(-50);
    }];
    [_bookingButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 165 + 15)];
    [headView addSubview:self.payHeadView];
    self.tableView.tableHeaderView = headView;
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 60;
        [_tableView registerClass:[HbOrderConfirmTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (YTPayHeadView*)payHeadView
{
    if (!_payHeadView) {
        _payHeadView = [[YTPayHeadView alloc] initWithFrame:CGRectMake(0, 15, kDeviceWidth, 164)];
        _payHeadView.titleLabel.text = @"选择支付方式";
    }
    return _payHeadView;
}
- (UIButton*)bookingButton
{
    if (!_bookingButton) {
        _bookingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bookingButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_bookingButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_bookingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bookingButton setTitle:@"下单并支付" forState:UIControlStateNormal];
        [_bookingButton addTarget:self action:@selector(bookingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bookingButton;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
