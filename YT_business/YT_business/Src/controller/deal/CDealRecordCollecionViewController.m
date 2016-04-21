#import "CDealRecordCollecionViewController.h"
#import "UIImage+HBClass.h"
#import "UIViewController+Helper.h"
#import "HbPaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "YTBarPayModel.h"
#import "QRCodeReaderViewController.h"
#import "CDealRecordInputViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "UIAlertView+TTBlock.h"
#import "YTHttpClient.h"
#import "MBProgressHUD+Add.h"
#import "YTTimerManager.h"
#import "YTScanUserAuthPayModel.h"
#import "YTUserAuthResultModel.h"

static NSString* payTimer = @"PayTimer";

@interface CDealRecordCollecionViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UITextField* textField;
@property (strong, nonatomic) UIButton* doneBtn;
@property (strong, nonatomic) QRCodeReaderViewController* readerVC;
@property (strong, nonatomic) YTScanUserAuthPaySet* userAuthPaySet;
@property (assign, nonatomic) BOOL isScanPop;
@property (assign, nonatomic) BOOL isScaning;
@end

@implementation CDealRecordCollecionViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [self stopPolling];
}
- (id)init
{
    if ((self = [super init])) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"收款";
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopPolling];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isScanPop) {
        [self.textField becomeFirstResponder];
    }
    self.isScanPop = NO;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    self.isScaning = NO;
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:saleScanUserAuthCodePayURL] ||
            [operation.urlTag isEqualToString:scanUserAuthCodePayURL]) {
            YTScanUserAuthPayModel* scanUserAuthPayModel = (YTScanUserAuthPayModel*)parserObject;
            self.userAuthPaySet = scanUserAuthPayModel.userAuthPaySet;
            [MBProgressHUD showMessag:@"" toView:self.view];
            [self startPolling];
        }
        else if ([operation.urlTag isEqualToString:saleUserAuthCodeResultURL] ||
            [operation.urlTag isEqualToString:userAuthCodeResultURL]) {
            YTUserAuthResultModel* resultModel = (YTUserAuthResultModel*)parserObject;
            YTUserAuthResultPayOrder* payOrder = resultModel.authResultSet.extras.payOrder;
            if (payOrder.status == YTPAYSTATUS_PAYED) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self showPaySuccessViewController:[NSString stringWithFormat:@"您已成功收款%.2f元", payOrder.totalPrice / 100.]];
            }
            else {
            }
        }
        else {
            YTBarPayModel* barPayModel = (YTBarPayModel*)parserObject;
            [self showPaySuccessViewController:[NSString stringWithFormat:@"您已成功收款%.2f元", barPayModel.barPaySet.payOrder.totalPrice / 100.]];
        }
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - textField Delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;
{
    if (string.length > 0 || range.location > 0) {
        [self didDoneButtonChange:YES];
    }
    else {
        [self didDoneButtonChange:NO];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField*)textField
{
    [self didDoneButtonChange:NO];
    return YES;
}

#pragma mark -Private methods
- (void)didDoneButtonChange:(BOOL)enabled
{
    if (enabled) {
        _doneBtn.userInteractionEnabled = YES;
        [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
    }
    else {
        _doneBtn.userInteractionEnabled = NO;
        [_doneBtn setTitleColor:CCCUIColorFromHex(0xbfbfbf) forState:UIControlStateNormal];
        [_doneBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xdedede)] forState:UIControlStateNormal];
    }
}
- (void)toScanningQrcodeViewController
{
    _readerVC = [[QRCodeReaderViewController alloc] init];
    _readerVC.hidesBottomBarWhenPushed = YES;
    _readerVC.navigationItem.title = @"扫一扫";
    UIImage* image = [UIImage imageNamed:@"face_pay_inputNumber.png"];
    _readerVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:image highlightImage:image target:self action:@selector(readerRightBarButtonItemAction:)];
    __weak typeof(self) weakSelf = self;
    [_readerVC setCompletionWithBlock:^(NSString* resultAsString) {
        [weakSelf setupScanResultString:resultAsString];
    }];
    [self.navigationController pushViewController:_readerVC animated:NO];
}
- (void)showPaySuccessViewController:(NSString*)describe
{
    HbPaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbPaySuccessViewController class]];
    paySuccessVC.hideButton = YES;
    paySuccessVC.paySuccessDescribe = describe;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}
- (void)setupScanResultString:(NSString*)resultString
{
    if (self.isScaning) {
        return;
    }
    NSLock* lock = [[NSLock alloc] init];
    [lock lock];
    self.isScanPop = YES;
    [_readerVC.navigationController popViewControllerAnimated:NO];
    NSInteger amoutValue = [_textField.text doubleValue] * 100;
    if ([resultString hasPrefix:@"8888"]) {
        NSInteger discount = [YTUsr usr].shop.discount;
        CGFloat amount = 0;
        if (discount == 0 || discount == 100) {
            amount = amoutValue;
        }
        else {
            amount = amoutValue * (discount / 100.);
            amount = amount < 1 ? 1 : amount;
        }
        NSInteger payChanel = self.payType == YTPayTypeZfb ? 1 : 2;
        self.requestParas = @{ @"authCode" : resultString,
            @"amount" : @(amount),
            @"originAmount" : @(amoutValue),
            @"payChanel" : @(payChanel),
            loadingKey : @(YES) };
        if ([YTUsr usr].type == LoginViewTypeAsstanter) {
            self.requestURL = saleScanUserAuthCodePayURL;
        }
        else {
            self.requestURL = scanUserAuthCodePayURL;
        }
    }
    else {
        self.requestParas = @{ @"authCode" : resultString,
            @"totalAmount" : @(amoutValue),
            loadingKey : @(YES) };
        if ([YTUsr usr].type == LoginViewTypeAsstanter) {
            if (self.payType == YTPayTypeZfb) {
                self.requestURL = saleBarPayURL;
            }
            else {
                self.requestURL = saleWeiXinBarPayURL;
            }
        }
        else {
            if (self.payType == YTPayTypeZfb) {
                self.requestURL = bizBarPayURL;
            }
            else {
                self.requestURL = weiXinBarPayURL;
            }
        }
    }
    [lock unlock];
    self.isScaning = YES;
}

#pragma mark - Polling Data
- (void)startPolling
{
    // 提供ActionOption之前，需要手动停止上一个timer，再重新schedule
    [self stopPolling];
    __weak typeof(self) weakSelf = self;
    [[YTTimerManager sharedInstance] scheduledDispatchTimerWithName:payTimer
                                                       timeInterval:2.0
                                                              queue:nil
                                                            repeats:YES
                                                       actionOption:AbandonPreviousAction
                                                             action:^{
                                                                 [weakSelf fetchPayResultData];
                                                             }];
}
- (void)stopPolling
{
    [[YTTimerManager sharedInstance] cancelTimerWithName:payTimer];
}
- (void)fetchPayResultData
{
    if ([NSStrUtil isEmptyOrNull:self.userAuthPaySet.authCode]) {
        return;
    }
    self.requestParas = @{ @"authCode" : self.userAuthPaySet.authCode };
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        self.requestURL = saleUserAuthCodeResultURL;
    }
    else {
        self.requestURL = userAuthCodeResultURL;
    }
}
#pragma mark - Event response
- (void)doneButtonClicked:(id)sender
{
    [_textField resignFirstResponder];
    NSInteger amoutValue = [_textField.text doubleValue] * 100;
    if (amoutValue < 1) {
        [self showAlert:@"金额不能少于0.01元哦~" title:@""];
        return;
    }
    [self toScanningQrcodeViewController];
}
#pragma mark - Navigation
- (void)readerRightBarButtonItemAction:(id)sender
{
    CDealRecordInputViewController* dealRecordInputVC = [[CDealRecordInputViewController alloc] init];
    dealRecordInputVC.payType = self.payType;
    dealRecordInputVC.totalAmount = _textField.text;
    [self.navigationController pushViewController:dealRecordInputVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UIImage* textBackImage = [[UIImage imageNamed:@"ye_payTextFieldBackground.png"] stretchableImageWithLeftCapWidth:60 topCapHeight:10];
    UIImageView* textImageView = [[UIImageView alloc] initWithImage:textBackImage];
    [self.view addSubview:textImageView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.doneBtn];
    [self didDoneButtonChange:NO];
    [textImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(48);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.bottom.mas_equalTo(textImageView);
        make.left.mas_equalTo(textImageView).offset(55);
        make.right.mas_equalTo(textImageView);
    }];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(textImageView);
        make.top.mas_equalTo(textImageView.bottom).offset(30);
        make.height.mas_equalTo(45);
    }];
}
#pragma mark - Getters & Setters
- (UITextField*)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tintColor = [UIColor redColor];
        _textField.textColor = [UIColor redColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
        _textField.placeholder = @"请输入收款金额";
    }
    return _textField;
}
- (UIButton*)doneBtn
{
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _doneBtn.layer.masksToBounds = YES;
        _doneBtn.layer.cornerRadius = 4;
        [_doneBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}
@end
