#import "DealRecordBlanceViewController.h"
#import "MBProgressHUD+Add.h"
#import "YTAccountModel.h"
#import "ZCTradeView.h"
#import "UIViewController+Helper.h"
#import "NSStrUtil.h"
#import "UserMationMange.h"
#import "DealRecordBlanceiewDetailViewController.h"
#import "MobileRechargeViewController.h"
#import "BalancesWithdrawViewController.h"

@interface DealRecordBlanceViewController ()
@property (strong, nonatomic) UIView* redView;
@property (strong, nonatomic) UIView* whiteView;

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* amountLabel;
@property (strong, nonatomic) UILabel* remainLabel;

@property (strong, nonatomic) UIButton* recordDetailBtn;
@property (strong, nonatomic) UIButton* rechargeBtn;
@property (strong, nonatomic) UIButton* extractBtn;

@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) YTAccountModel* accountModel;
@end

@implementation DealRecordBlanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"账户余额";
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.requestParas = @{ loadingKey : @(YES) };
    self.requestURL = YC_Request_QueryMemberAcount;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel*)parserObject
              errorMessage:(NSString*)errorMessage
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (parserObject.success) {
        if ([request.url isEqualToString:YC_Request_QueryMemberAcount]) {
            self.accountModel = (YTAccountModel*)parserObject;
            self.amountLabel.text = [NSString stringWithFormat:@"%.2f", self.accountModel.account.total / 100.];
            self.remainLabel.text = [NSString stringWithFormat:@"(可用余额%.2f)", self.accountModel.account.remain / 100.];
        }
        else if ([request.url isEqualToString:YC_Request_SetPayPasswd]) {
            [self showAlert:@"您在进行提现或者其他消费时,输入该密码即可完成操作" title:@"密码设置成功"];
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}
#pragma mark - Private methods
- (void)setupPasswordAgain:(NSString*)psd
{
    ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"确认支付密码" frame:CGRectZero];
    __weak __typeof(self) weakSelf = self;
    tradeView.finish = ^(NSString* passWord) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([passWord isEqualToString:psd]) {
            strongSelf.requestParas = @{ @"payPwd" : [passWord GetMD5],
                loadingKey : @(YES) };
            strongSelf.requestURL = YC_Request_SetPayPasswd;
        }
        else {
            [strongSelf showAlert:@"两次输入的密码不一样" title:@"设置密码失败"];
        }
    };
    [tradeView show];
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
#pragma mark - Event response
- (void)recordDetailButtonClicked:(id)sender
{
    DealRecordBlanceiewDetailViewController* dealRecordBlanceiewDetailVC = [[DealRecordBlanceiewDetailViewController alloc] init];
    [self.navigationController pushViewController:dealRecordBlanceiewDetailVC animated:YES];
}
- (void)rechargeButtonClicked:(id)sender
{
    if ([NSStrUtil isEmptyOrNull:[[UserMationMange sharedInstance] payPwd]]) {
        [self setupUserPayPassword];
    }
    else {
        MobileRechargeViewController* mobileRechargeVC = [[MobileRechargeViewController alloc] init];
        [self.navigationController pushViewController:mobileRechargeVC animated:YES];
    }
}
- (void)extractButtonClicked:(id)sender
{
    if ([NSStrUtil isEmptyOrNull:[[UserMationMange sharedInstance] payPwd]]) {
        [self setupUserPayPassword];
    }
    else {
        BalancesWithdrawViewController* balancesWithdrawVC = [[BalancesWithdrawViewController alloc] initWithRemain:self.accountModel.account.remain];
        [self.navigationController pushViewController:balancesWithdrawVC animated:YES];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.redView];
    [self.view addSubview:self.whiteView];
    UIImageView* redBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb_throw_redBackground.png"]];
    [self.redView addSubview:redBackImageView];
    [self.redView addSubview:self.titleLabel];
    [self.redView addSubview:self.amountLabel];
    [self.redView addSubview:self.remainLabel];
    [self.redView addSubview:self.recordDetailBtn];
    [self.whiteView addSubview:self.rechargeBtn];
    [self.whiteView addSubview:self.extractBtn];
    UIImageView* verticalLine = [[UIImageView alloc] initWithImage:YTlightGrayLineImage];
    [self.whiteView addSubview:verticalLine];

    [_redView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(114);
    }];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(_redView.bottom);
        make.left.right.mas_equalTo(_redView);
        make.height.mas_equalTo(95);
    }];
    [redBackImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(_redView);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.mas_equalTo(15);
        make.right.mas_equalTo(-35);
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.bottom).offset(10);
    }];
    [_remainLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_amountLabel.right).offset(5);
        make.bottom.mas_equalTo(_amountLabel).offset(-10);
    }];
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.bottom.mas_equalTo(_whiteView);
        make.width.mas_equalTo(_whiteView).multipliedBy(0.5);
    }];
    [_recordDetailBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(18);
        make.right.mas_equalTo(-14);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(25);
        make.bottom.mas_equalTo(-25);
        make.centerX.mas_equalTo(_whiteView);
        make.width.mas_equalTo(1);
    }];
    [_extractBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.top.bottom.mas_equalTo(_whiteView);
        make.left.mas_equalTo(_rechargeBtn.right);
    }];

    self.amountLabel.text = @"--";
}

#pragma mark - Getters & Setters
- (UIView*)redView
{
    if (!_redView) {
        _redView = [[UIView alloc] init];
    }
    return _redView;
}
- (UIView*)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"账户余额(元)";
    }
    return _titleLabel;
}
- (UILabel*)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.numberOfLines = 1;
        _amountLabel.font = [UIFont systemFontOfSize:50];
        _amountLabel.textColor = [UIColor whiteColor];
    }
    return _amountLabel;
}
- (UILabel*)remainLabel
{
    if (!_remainLabel) {
        _remainLabel = [[UILabel alloc] init];
        _remainLabel.numberOfLines = 1;
        _remainLabel.font = [UIFont systemFontOfSize:16];
        _remainLabel.textColor = [UIColor whiteColor];
    }
    return _remainLabel;
}
- (UIButton*)recordDetailBtn
{
    if (!_recordDetailBtn) {
        _recordDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordDetailBtn setImage:[UIImage imageNamed:@"face_pay_sort.png"] forState:UIControlStateNormal];
        [_recordDetailBtn addTarget:self action:@selector(recordDetailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordDetailBtn;
}
- (UIButton*)rechargeBtn
{
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rechargeBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 70, 0, 0);
        _rechargeBtn.titleEdgeInsets = UIEdgeInsetsMake(40, -15, 0, 0);
        [_rechargeBtn setTitleColor:CCCUIColorFromHex(0x666666) forState:UIControlStateNormal];
        [_rechargeBtn setTitle:@"手机充值" forState:UIControlStateNormal];
        [_rechargeBtn setImage:[UIImage imageNamed:@"face_pay_phoneicon.png"] forState:UIControlStateNormal];
        [_rechargeBtn addTarget:self action:@selector(rechargeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}
- (UIButton*)extractBtn
{
    if (!_extractBtn) {
        _extractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _extractBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _extractBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 70, 0, 0);
        _extractBtn.titleEdgeInsets = UIEdgeInsetsMake(40, -15, 0, 0);
        [_extractBtn setTitleColor:CCCUIColorFromHex(0x666666) forState:UIControlStateNormal];
        [_extractBtn setTitle:@"余额提现" forState:UIControlStateNormal];
        [_extractBtn setImage:[UIImage imageNamed:@"face_pay_rmb.png"] forState:UIControlStateNormal];
        [_extractBtn addTarget:self action:@selector(extractButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extractBtn;
}

@end
