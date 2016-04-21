#import "CDealRecordInputViewController.h"
#import "CCTextField.h"
#import "CDealRecordCollecionViewController.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "StoryBoardUtilities.h"
#import "HbPaySuccessViewController.h"
#import "YTBarPayModel.h"
#import "YTTimerManager.h"
#import "YTScanUserAuthPayModel.h"
#import "YTUserAuthResultModel.h"
#import "MBProgressHUD+Add.h"

static NSString* payTimer = @"PayTimer";

@interface CDealRecordInputViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) CCTextField *textField;
@property (strong, nonatomic) YTScanUserAuthPaySet* userAuthPaySet;
@end

@implementation CDealRecordInputViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [self stopPolling];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  _inputMode == DealRecordInputModeCollection ? @"请输入序列号" : @"请输入条形码";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    NSString *itemString = _inputMode == DealRecordInputModeCollection ? @"提交" : @"下一步";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemString style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
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
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:scanUseHongbaoURL] ||
            [operation.urlTag isEqualToString:saleScanUseHongbaoURL]) {
            [self showPaySuccessViewController:@"验证成功"];
        }
        else if ([operation.urlTag isEqualToString:bizBarPayURL] ||
            [operation.urlTag isEqualToString:saleBarPayURL] ||
            [operation.urlTag isEqualToString:weiXinBarPayURL] ||
            [operation.urlTag isEqualToString:saleWeiXinBarPayURL]) {
            YTBarPayModel* barPayModel = (YTBarPayModel*)parserObject;
            [self showPaySuccessViewController:[NSString stringWithFormat:@"您已成功收款%.2f元", barPayModel.barPaySet.payOrder.totalPrice / 100.]];
        }
        else if ([operation.urlTag isEqualToString:saleScanUserAuthCodePayURL] ||
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
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - Private methods
- (void)inputDone
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showPaySuccessViewController:(NSString*)describe
{
    HbPaySuccessViewController* paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbPaySuccessViewController class]];
    paySuccessVC.hideButton = YES;
    paySuccessVC.paySuccessDescribe = describe;
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}
#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
     [self.navigationController popViewControllerAnimated:YES];
    return YES;
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
#pragma mark - 导航栏按钮
- (void)didRightBarButtonItemAction:(id)sender
{
    if ([NSStrUtil isEmptyOrNull:self.textField.text]) {
        [self showAlert:@"您还没有输入任何信息哦·" title:@""];
        return;
    }
    [self.textField resignFirstResponder];
    if (_inputMode == DealRecordInputModeCollection) {
        NSInteger amoutValue = [_totalAmount doubleValue]*100;
        if ([_textField.text hasPrefix:@"8888"]) {
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
            self.requestParas = @{ @"authCode" : _textField.text,
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
        } else {
            self.requestParas = @{@"authCode":_textField.text,
                                  @"totalAmount":@(amoutValue),
                                  loadingKey:@(YES)};
            if ([YTUsr usr].type == LoginViewTypeAsstanter) {
                if (self.payType == YTPayTypeZfb) {
                    self.requestURL = saleBarPayURL;
                }else{
                    self.requestURL = saleWeiXinBarPayURL;
                }
            }
            else {
                if (self.payType == YTPayTypeZfb) {
                    self.requestURL = bizBarPayURL;
                }else{
                    self.requestURL = weiXinBarPayURL;
                }
            }
        }
    } else{
        self.requestParas = @{@"token":_textField.text,
                              loadingKey:@(YES)};
        if ([YTUsr usr].type == LoginViewTypeAsstanter) {
            self.requestURL = saleScanUseHongbaoURL;
        } else {
            self.requestURL = scanUseHongbaoURL;
        }

    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.backView];
    UIImageView *topLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    UIImageView *topLine2 = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [self.backView addSubview:topLine];
    [self.backView addSubview:topLine2];
    [self.backView addSubview:self.textField];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(46);
    }];
    // 线条
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(_backView);
        make.height.mas_equalTo(1);
    }];
    [topLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.right.mas_equalTo(_backView);
        make.height.mas_equalTo(1);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(_backView).with.insets(UIEdgeInsetsMake(2, 0, 2, 0));
    }];
}

#pragma mark - Getters & Setters
- (UIView *)backView
{
    if (!_backView) {
        _backView = UIView.new;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
- (CCTextField *)textField
{
    if (!_textField) {
        _textField = [[CCTextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textColor = [UIColor blackColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType =UIReturnKeyDone;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.delegate = self;
    }
    return _textField;
}
@end
