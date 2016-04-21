#import "DistributePayViewController.h"
#import "PayModeTableCell.h"
#import "UIViewController+Helper.h"
#import "DistributePayHeadView.h"
#import "UIImage+HBClass.h"
#import "HbPaySuccessViewController.h"
#import "ZCTradeView.h"
#import "MBProgressHUD+Add.h"
#import "YTHongbaoPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIViewController+Helper.h"
#import "YTVenderDefine.h"
#import "YTWechatPayModel.h"
#import "WXApi.h"

static NSString* CellIdentifier = @"DistributePayCellIdentifier";

@interface DistributePayViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) NSInteger selectPayIndex;
@property (nonatomic, strong) UIButton* payBtn;
@property (nonatomic, strong) YTWechatPayModel* wechatPayModel;

@end

@implementation DistributePayViewController

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
    self.navigationItem.title = @"支付";
    self.selectPayIndex = 0;
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:steupPayPasswdURL]) {
            [self showAlert:@"您在进行提现或者其他消费时,输入该密码即可完成操作" title:@"密码设置成功"];
        }
        else if ([operation.urlTag isEqualToString:yuerPayURL]) {
            [self toDistributeSuccessViewController];
        }
        else if ([operation.urlTag isEqualToString:publishAlipayURL]) {
            YTHongbaoPayModel* hongbaoPayModel = (YTHongbaoPayModel*)parserObject;
            wSelf(wSelf);
            [[AlipaySDK defaultService] payOrder:hongbaoPayModel.hongbaoPay.payInfo
                                      fromScheme:kAlipayScheme
                                        callback:^(NSDictionary* resultDic) {
                                            __strong __typeof(wSelf) strongSelf = wSelf;
                                            strongSelf.requestParas = [[NSDictionary alloc] initWithDictionary:resultDic];
                                            strongSelf.requestURL = publishAlipayResultURL;
                                            if ([resultDic[@"resultStatus"] integerValue] == 9000) {
                                                [strongSelf toDistributeSuccessViewController];
                                            }
                                            else {
                                            }
                                        }];
        }
        else if ([operation.urlTag isEqualToString:publishWeixinpayURL]) {
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
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return 3;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    PayModeTableCell* cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"yt_payType_balance.png"];
        cell.titleLabel.text = @"余额支付";
        cell.messageLabel.text = @"您可以使用账余额进行支付";
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
    [cell payModeSelect:_selectPayIndex == indexPath.row];

    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_selectPayIndex == indexPath.row) {
        return;
    }
    _selectPayIndex = indexPath.row;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
             withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - Wechat onResp NSNotification
- (void)wechatPayRespNotification:(NSNotification*)notification
{
    PayResp* response = (PayResp*)[notification object];
    if (response.errCode == WXSuccess) {
        if ([NSStrUtil notEmptyOrNull:_wechatPayModel.wechatPay.shopOrder.shopOrderId]) {
            self.requestParas = @{ @"payOrderId" : _wechatPayModel.wechatPay.shopOrder.shopOrderId };
            self.requestURL = publishWeixinpayResultURL;
        }
        [self toDistributeSuccessViewController];
    }
    else {
        [self showAlert:@"支付失败" title:@""];
    }
}
#pragma mark - Private methods
- (void)toDistributeSuccessViewController
{
    NSString* payResult = @"";
    if (self.hongbao.hongbaoType == DistributeMoneyHBTypeLuck) {
        payResult = [NSString stringWithFormat:@"您也发布%@个拼手气红包,总金额%.2f元", @(self.hongbao.count), self.hongbao.cost];
    }
    else {
        payResult = [NSString stringWithFormat:@"您也发布%@个普通红包,单个金额%.2f元", @(self.hongbao.count), self.hongbao.cost / self.hongbao.count];
    }
    HbPaySuccessViewController* successVC = [[HbPaySuccessViewController alloc] init];
    successVC.navigationTitle = @"发布成功";
    successVC.paySuccessTitle = @"发布成功";
    successVC.paySuccessDescribe = payResult;
    successVC.hideButton = YES;
    [self.navigationController pushViewController:successVC animated:YES];
}
- (void)configUserPayPassword
{
    ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"设置支付密码" frame:CGRectZero];
    wSelf(wSelf);
    tradeView.finish = ^(NSString* passWord) {
        [wSelf setupPasswordAgain:passWord];
    };
    [tradeView show];
}
- (void)setupPasswordAgain:(NSString*)psd
{
    ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"确认支付密码" frame:CGRectZero];
    wSelf(wSelf);
    tradeView.finish = ^(NSString* passWord) {
        __strong __typeof(wSelf) strongSelf = wSelf;
        if ([passWord isEqualToString:psd]) {
            strongSelf.requestParas = @{ @"payPwd" : [passWord GetMD5],
                loadingKey : @(YES) };
            strongSelf.requestURL = steupPayPasswdURL;
        }
        else {
            [strongSelf showAlert:@"两次输入的密码不一样" title:@"设置密码失败"];
        }
    };
    [tradeView show];
}
- (void)yuerPay
{
    if ([NSStrUtil isEmptyOrNull:[YTUsr usr].payPwd]) {
        [self configUserPayPassword];
    }
    else {
        ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"请输入支付密码" frame:CGRectZero];
        wSelf(wSelf);
        tradeView.finish = ^(NSString* passWord) {
            __strong __typeof(wSelf) strongSelf = wSelf;
            NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] initWithDictionary:[self payNeedParameter]];
            mutableDict[@"payPasswd"] = [passWord GetMD5];
            strongSelf.requestParas = [NSDictionary dictionaryWithDictionary:mutableDict];
            strongSelf.requestURL = yuerPayURL;
        };
        [tradeView show];
    }
}
- (void)publishAlipay
{
    self.requestParas = [self payNeedParameter];
    self.requestURL = publishAlipayURL;
}
- (void)publishWeixinpay
{
    self.requestParas = [self payNeedParameter];
    self.requestURL = publishWeixinpayURL;
}
- (NSDictionary*)payNeedParameter
{
    return @{ @"amount" : [NSString stringWithFormat:@"%.0f", self.hongbao.cost * 100],
        @"hongbaoNum" : @(self.hongbao.count),
        @"isGeneral" : self.hongbao.hongbaoType == DistributeMoneyHBTypeLuck ? @(NO) : @(YES),
        @"content" : self.hongbao.content,
        loadingKey : @(YES) };
}
#pragma mark - Event response
- (void)payButtonClicked:(id)sender
{
    if (_selectPayIndex == 0) {
        [self yuerPay];
    }
    else if (_selectPayIndex == 1) {
        [self publishAlipay];
    }
    else {
        [self publishWeixinpay];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    _tableView.tableHeaderView = ({
        UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
        DistributePayHeadView* payHeadView = [[DistributePayHeadView alloc] initWithFrame:CGRectMake(0, 15, kDeviceWidth, 45)];
        payHeadView.detailAttributedString = [self payDetailAttributedString];
        [headView addSubview:payHeadView];
        headView;
    });
    _tableView.tableFooterView = ({
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 90)];
        [footerView addSubview:self.payBtn];
        footerView;
    });
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[PayModeTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (UIButton*)payBtn
{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(15, 30, CGRectGetWidth(self.view.bounds) - 30, 50);
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius = 4;
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_payBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xE63E4B)] forState:UIControlStateNormal];
        [_payBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xDA2F3C)] forState:UIControlStateHighlighted];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (NSAttributedString*)payDetailAttributedString
{
    NSString* countValue = [NSString stringWithFormat:@"%@", @(self.hongbao.count)];
    NSString* costValue = [NSString stringWithFormat:@"￥%.2f", self.hongbao.cost];
    NSString* fullText = [NSString stringWithFormat:@"共%@个拼手气红包  总价%@", countValue, costValue];
    NSRange countRange = NSMakeRange(1, countValue.length);
    NSRange costRange = NSMakeRange(fullText.length - costValue.length, costValue.length);

    NSMutableAttributedString* mutableAttributedStr =
        [[NSMutableAttributedString alloc]
            initWithString:fullText];

    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:countRange];
    [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:YTDefaultRedColor range:costRange];
    [mutableAttributedStr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:18]
                                 range:costRange];
    return [[NSAttributedString alloc] initWithAttributedString:mutableAttributedStr];
}
@end
