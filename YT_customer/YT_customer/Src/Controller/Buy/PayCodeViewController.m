#import "PayCodeViewController.h"
#import "YTTimerManager.h"
#import "UUIDUtil.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+Helper.h"
#import "YTAuthResultModel.h"
#import "CIFilterEffect.h"
#import "PayUtil.h"
#import "PaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "PayViewController.h"

static NSString *payTimer = @"PayTimer";

@interface PayCodeViewController ()
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic,strong) YTCreateUserAuthSet *userAuthSet;
@property (strong, nonatomic) UIImageView* qrcodeImageView;
@property (strong, nonatomic) UILabel* qrcodeLabel;
@property (strong, nonatomic) UILabel* messageLabel;
@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) YTAuthResultModel *authResultModel;
@end

@implementation PayCodeViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [self stopPolling];
}
- (instancetype)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的二维码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    self.isLoading = NO;
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createUserAuthCode];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPolling];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createUserAuthCode
{
    self.requestParas = @{@"token" : [UUIDUtil uuid]};
    self.requestURL = YC_Request_CreateUserAuthCode;
}
#pragma mark -override fetchData
- (void)actionFetchRequest:(YTRequestModel *)request result:(YTBaseModel *)parserObject
              errorMessage:(NSString *)errorMessage
{
   
    if (parserObject.success) {
        if ([request.url isEqualToString:YC_Request_CreateUserAuthCode]) {
             [self.activityIndicator stopAnimating];
            YTCreateUserAuthModel *userAuthModel = (YTCreateUserAuthModel *)parserObject;
            self.userAuthSet = userAuthModel.userAuthSet;
            _qrcodeLabel.text = userAuthModel.userAuthSet.authCode;
            _qrcodeImageView.image = [[[CIFilterEffect alloc] initWithQRCodeString:userAuthModel.userAuthSet.authCode width:240] qrCodeImage];
            [self startPolling];
        }else if ([request.url isEqualToString:YC_Request_UserAuthCodeResult]) {
            self.isLoading = NO;
            self.authResultModel = (YTAuthResultModel *)parserObject;
            YTAuthResultPayOrder *payOrder = self.authResultModel.authResultSet.extras.payOrder;
            if (self.authResultModel.authResultSet.extras.payOrder) {
//                if (self.authResultModel.authResultSet.extras.payOrder.payChannel == 1) {
//                    [self showZhifubaoPay:self.authResultModel.authResultSet.extras.payInfo];
//                }else{
//                    [self showWeixinPay:self.authResultModel.authResultSet.extras.unifiedOrderClientReqData payorderId:self.authResultModel.authResultSet.extras.payOrder.orderId];
//                }
                [self stopPolling];
                PayViewController *payVC = [[PayViewController alloc] init];
                payVC.mayChange = YES;
                payVC.shopId = payOrder.shopId;
                payVC.payChannel = payOrder.payChannel;
                payVC.payPrice = payOrder.originPrice;
                payVC.authCode = _qrcodeLabel.text;
                [self.navigationController pushViewController:payVC animated:YES];
            }
        }
    }else{
        [self showAlert:errorMessage title:@""];
    }
}
#pragma mark - Private methods
- (void)showZhifubaoPay:(NSString *)payInfo
{
    __weak __typeof(self)weakSelf = self;
    [[PayUtil sharedPayUtil] alipayOrder:payInfo
                              blackBlock:^(NSDictionary* dic) {
                                  if ([dic[@"resultStatus"] integerValue] == 9000) {
                                      __strong __typeof(weakSelf)strongSelf = weakSelf;
                                          [strongSelf pushToPaySuccessViewController];
                                  }
                              }];
}
- (void)showWeixinPay:(NSDictionary *)orderDic payorderId:(NSNumber *)payorderId
{
    __weak __typeof(self)weakSelf = self;
    [[PayUtil sharedPayUtil] weChatPayWithDictionary:@{@"unifiedOrderClientReqData":orderDic} payorderId:payorderId blackBlock:^(NSDictionary *dic) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf pushToPaySuccessViewController];
    }];
}
- (void)pushToPaySuccessViewController
{
    PaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[PaySuccessViewController class]];
    paySuccessVC.hiddenLeftBtn = YES;
    paySuccessVC.receiveType = NoReceive;
    paySuccessVC.passArr = [[NSArray alloc] init];
    paySuccessVC.orderStr = self.authResultModel.authResultSet.extras.payOrder.toOuterId;
    paySuccessVC.orderId = self.authResultModel.authResultSet.extras.payOrder.orderId;
    paySuccessVC.navigationItem.leftItemsSupplementBackButton = NO;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}
- (void)startPolling
{
    // 提供ActionOption之前，需要手动停止上一个timer，再重新schedule
    [self stopPolling];
    __weak typeof(self) weakSelf = self;
    [[YTTimerManager sharedInstance] scheduledDispatchTimerWithName:payTimer
                                                           timeInterval:5.0
                                                                  queue:nil
                                                                repeats:YES
                                                           actionOption:AbandonPreviousAction
                                                                 action:^{
                                                                     [weakSelf fetchCodeData];
                                                                 }];

}
- (void)stopPolling
{
    [[YTTimerManager sharedInstance] cancelTimerWithName:payTimer];
}

- (void)fetchCodeData
{
    if (self.isLoading) {
        return;
    }
    self.requestParas = @{ @"authCode" : self.userAuthSet.authCode };
    self.requestURL = YC_Request_UserAuthCodeResult;
    self.isLoading = YES;
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self createUserAuthCode];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_codePay_background"]];
    [backView addSubview:backImageView];
    
    UIImageView *barCodeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_codePay_barcode"]];
    [backView addSubview:barCodeImageView];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [backView addSubview:lineImageView];
    [backView addSubview:self.qrcodeLabel];
    [backView addSubview:self.qrcodeImageView];
    [backView addSubview:self.activityIndicator];
    [backView addSubview:self.messageLabel];
    
    UIImageView *tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_codePay_redTip"]];
    [self.view addSubview:tipImageView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = YTDefaultRedColor;
    tipLabel.font = [UIFont systemFontOfSize:16];
    tipLabel.numberOfLines = 1;
    tipLabel.text = @"付款时请勿离开该页面";
    [self.view addSubview:tipLabel];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(345, 334));
    }];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(backView);
    }];
    [barCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(backView);
        make.size.mas_equalTo(CGSizeMake(239, 59));
    }];
    [_qrcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(barCodeImageView.bottom).offset(5);
        make.left.right.mas_equalTo(backView);
    }];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(barCodeImageView.bottom).offset(30);
    }];
    [_qrcodeImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerX.mas_equalTo(backView);
        make.top.mas_equalTo(lineImageView.bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.mas_equalTo(_qrcodeImageView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_qrcodeImageView.bottom).offset(15);
        make.left.right.mas_equalTo(backView);
    }];
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView.bottom).offset(30);
        make.centerX.mas_equalTo(backView).offset(-70);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipImageView.right).offset(2);
        make.centerY.mas_equalTo(tipImageView);
    }];
    [self.activityIndicator startAnimating];
}
#pragma mark - Getters & Setters
- (UIImageView*)qrcodeImageView
{
    if (!_qrcodeImageView) {
        _qrcodeImageView = [[UIImageView alloc] init];
    }
    return _qrcodeImageView;
}
- (UILabel *)qrcodeLabel
{
    if (!_qrcodeLabel) {
        _qrcodeLabel = [[UILabel alloc] init];
        _qrcodeLabel.textColor = CCCUIColorFromHex(0x333333);
        _qrcodeLabel.font = [UIFont systemFontOfSize:15];
        _qrcodeLabel.textAlignment = NSTextAlignmentCenter;
        _qrcodeLabel.numberOfLines = 1;
    }
    return _qrcodeLabel;
}
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = CCCUIColorFromHex(0x999999);
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 1;
        _messageLabel.text = @"出示二维码给商户";
    }
    return _messageLabel;
}
- (UIActivityIndicatorView*)activityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}
@end
