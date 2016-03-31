#import "BalancesWithdrawViewController.h"
#import "RGActionView.h"
#import "RGFieldView.h"
#import "UIImage+HBClass.h"
#import "YTPickerView.h"
#import "AddBankCardViewController.h"
#import "YTBankModel.h"
#import "UIViewController+Helper.h"
#import "WithdrawSuccessViewController.h"
#import "ZCTradeView.h"
#import "UIAlertView+TTBlock.h"
#import "NSStrUtil.h"

static NSString* const kDefauleCardName = @"使用新卡提现";
static NSString* const kPayPasswdErroe = @"PAY_PASSWD_ERROR";

@interface BalancesWithdrawViewController () <RGActionViewDelegate, RGFieldViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) RGActionView* cardView;
@property (strong, nonatomic) RGFieldView* balanceView;
@property (strong, nonatomic) UIButton* nextButton;
@property (strong, nonatomic) YTPickerView* pickerView;

@property (strong, nonatomic) YTBankModel* bankModel;
@property (strong, nonatomic) NSArray* pickerArray;
@property (strong, nonatomic) YTBank* bank;
@end

@implementation BalancesWithdrawViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (instancetype)initWithRemain:(NSInteger)remain
{
    self = [super init];
    if (self) {
        _remain = remain;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"余额提现";
    [self initializePageSubviews];
    [self setupUserBankList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUserBankList
{
    YTBank* bank = [YTBank unarchiveBank];
    if (bank) {
        self.bank = bank;
    }
    self.requestParas = @{};
    self.requestURL = YC_Request_MyBankList;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel*)parserObject
              errorMessage:(NSString*)errorMessage
{
    if (parserObject.success) {
        if ([request.url isEqualToString:YC_Request_MemberApplyBankCashout]) {
            if ([parserObject.resultCode isEqualToString:kPayPasswdErroe]) {
                NSString* serviseStr = [NSString stringWithFormat:@"请联系客服%@", YT_Service_Number];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您输入的密码错误" message:serviseStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
                wSelf(wSelf);
                [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
                    [wSelf callPhoneNumber:YT_Service_Number];
                }];
                [alert show];
            }
            else if ([NSStrUtil isEmptyOrNull:parserObject.resultCode]) {
                WithdrawSuccessViewController* successVC = [[WithdrawSuccessViewController alloc] init];
                successVC.successTitle = @"提现成功,24小时内到账";
                successVC.cardText = _cardView.detailLabel.text;
                successVC.amountText = [NSString stringWithFormat:@"￥%@", _balanceView.textFiled.text];
                [self.navigationController pushViewController:successVC animated:YES];
            }
            else {
                [self showAlert:parserObject.message title:@""];
            }
        }
        if ([request.url isEqualToString:YC_Request_MyBankList]) {
            self.bankModel = (YTBankModel*)parserObject;
            NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithArray:@[ kDefauleCardName ]];
            for (YTBank* bank in self.bankModel.banks) {
                NSString* str = [self bankNameAndNumber:bank];
                [mutableArray addObject:str];
            }
            self.pickerView.pickerData = [[NSArray alloc] initWithArray:mutableArray];
            [self.pickerView.pickerView reloadAllComponents];
        }
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}

#pragma mark - RGActionViewDelegate
- (void)rgactionViewDidClicked:(RGActionView*)actionView
{
    [self.balanceView.textFiled resignFirstResponder];
    if (_pickerView.display) {
        return;
    }
    [self.pickerView showInView:self.view];
    wSelf(wSelf);
    self.pickerView.actionBlock = ^() {
        __strong __typeof(wSelf) strongSelf = wSelf;
        NSString* str = strongSelf.pickerView.pickerData[strongSelf.pickerView.selectIndex];
        if ([str isEqualToString:kDefauleCardName]) {
            [strongSelf pushToAddBankViewController];
        }
        else {
            strongSelf.bank = strongSelf.bankModel.banks[strongSelf.pickerView.selectIndex - 1];
            //            strongSelf.cardView.detailLabel.text = str;
        }
    };
}
#pragma mark - RGFieldViewDelegate
- (void)rgfiledView:(RGFieldView*)filedView textFieldShouldBeginEditing:(UITextField*)textField
{
    [self.pickerView hidePicker];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_pickerView]) {
        return NO;
    }
    return YES;
}

#pragma mark - Private methods
- (NSString*)bankNameAndNumber:(YTBank*)bank
{
    NSString* bankNum = bank.bankNo;
    if (bankNum.length > 4) {
        bankNum = [bankNum substringFromIndex:bankNum.length - 4];
    }
    return [NSString stringWithFormat:@"%@(%@)", bank.bankName, bankNum];
}
- (void)pushToAddBankViewController
{
    AddBankCardViewController* addBankCardVC = [[AddBankCardViewController alloc] init];
    __weak __typeof(self) weakSelf = self;
    addBankCardVC.addSucessBlock = ^(YTBank* bank) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.bank = bank;
        NSMutableArray* mutableArr = [[NSMutableArray alloc] initWithArray:strongSelf.pickerView.pickerData];
        NSString* str = [strongSelf bankNameAndNumber:bank];
        [mutableArr addObject:str];
        strongSelf.pickerView.pickerData = [[NSArray alloc] initWithArray:mutableArr];
        [strongSelf.pickerView.pickerView reloadAllComponents];
    };
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}
- (void)withdrawDeposit:(NSInteger)amount
{
    [self.pickerView hidePicker];
    [self.balanceView.textFiled resignFirstResponder];
    ZCTradeView* tradeView = [[ZCTradeView alloc] initWithInputTitle:@"请输入支付密码" frame:CGRectZero];
    wSelf(wSelf);
    tradeView.finish = ^(NSString* passWord) {
        __strong __typeof(wSelf) strongSelf = wSelf;
        strongSelf.requestParas = @{ @"bindbankId" : _bank.bankId,
            @"amount" : [NSString stringWithFormat:@"%@", @(amount)],
            @"payPwd" : [passWord GetMD5],
            loadingKey : @(YES) };
            strongSelf.requestURL = YC_Request_MemberApplyBankCashout;
    };
    [tradeView show];
    [YTBank saveArchiveBank:self.bank];
}

#pragma mark - Event response
- (void)backViewTap:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
    [self.pickerView hidePicker];
}
- (void)nextButtonClicked:(id)sender
{
    if ([_cardView.detailLabel.text isEqualToString:kDefauleCardName]) {
        [self pushToAddBankViewController];
    }
    else {
        if ([NSStrUtil isEmptyOrNull:self.balanceView.textFiled.text]) {
            [self showAlert:@"请输入取款金额" title:@""];
            return;
        }
        if (![NSStrUtil isPureInt:self.balanceView.textFiled.text] && ![NSStrUtil isPureFloat:self.balanceView.textFiled.text]) {
            [self showAlert:@"输入的金额不正确" title:@""];
            return;
        }
        NSArray* strArray = [self.balanceView.textFiled.text componentsSeparatedByString:@"."];
        if (strArray.count > 1) {
            NSString* lastStr = [strArray lastObject];
            if (lastStr.length > 2) {
                [self showAlert:@"小数点最多保留2位" title:@""];
                return;
            }
        }
        NSInteger amount = [self.balanceView.textFiled.text doubleValue] * 100;
        if (amount <= 0) {
            [self showAlert:@"提现金额需要大于0" title:@""];
            return;
        }
        if (amount > self.remain) {
            [self showAlert:@"余额不足" title:@""];
            return;
        }
        [self withdrawDeposit:amount];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.cardView];
    [self.view addSubview:self.balanceView];
    [self.view addSubview:self.nextButton];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(backViewTap:)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}
#pragma mark - Getters & Setters
- (void)setBank:(YTBank*)bank
{
    _bank = bank;
    NSString* bankNum = bank.bankNo;
    if (bankNum.length > 4) {
        bankNum = [bankNum substringFromIndex:bankNum.length - 4];
    }
    _cardView.detailLabel.text = [NSString stringWithFormat:@"%@(%@)", bank.bankName, bankNum];
}
- (RGActionView*)cardView
{
    if (!_cardView) {
        _cardView = [[RGActionView alloc] initWithTitle:@"储蓄卡" frame:CGRectMake(0, 15, kDeviceWidth, 50)];
        _cardView.backgroundColor = [UIColor whiteColor];
        _cardView.arrowView.hidden = YES;
        _cardView.displayTopLine = YES;
        _cardView.detailLabel.text = kDefauleCardName;
        _cardView.detailLabel.textColor = CCCUIColorFromHex(0x4b649d);
        _cardView.detailLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _cardView.delegate = self;
    }
    return _cardView;
}
- (RGFieldView*)balanceView
{
    if (!_balanceView) {
        _balanceView = [[RGFieldView alloc] initWithTitle:@"金额(元)" frame:CGRectMake(0, 15 + 50, kDeviceWidth, 50)];
        _balanceView.backgroundColor = [UIColor whiteColor];
        _balanceView.keyboardType = UIKeyboardTypeDecimalPad;
        _balanceView.leftMargin = 0;
        _balanceView.placeholder = [NSString stringWithFormat:@"当前零钱余额￥%.2f", _remain / 100.];
        _balanceView.delegate = self;
    }

    return _balanceView;
}
- (UIButton*)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(15, 15 + 100 + 25, kDeviceWidth - 30, 45);
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 4;
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_nextButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}
- (YTPickerView*)pickerView
{
    if (!_pickerView) {
        _pickerView = [[YTPickerView alloc] initWithPickerPickerData:@[ kDefauleCardName ] frame:CGRectMake(0, KDeviceHeight, kDeviceWidth, 216)];
    }
    return _pickerView;
}

@end
