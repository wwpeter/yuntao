#import "FindPasswordViewController.h"

#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "UIImage+HBClass.h"
#import "UIAlertView+TTBlock.h"
#import "MBProgressHUD+Add.h"
#import "DeviceUtil.h"
#import "YTNetworkMange.h"
#import "UserInfomationModel.h"
#import "MBProgressHUD+Add.h"

#define kPhoneFieldTag 2000
#define kCodeFieldTag 2001
#define kPsdFieldTag 2002

@interface FindPasswordViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UITextField *phoneField;
@property (strong, nonatomic) UITextField *codeField;
@property (strong, nonatomic) UITextField *psdField;

@property (strong, nonatomic) UIButton *codeBtn;
@property (assign, nonatomic) BOOL countdowning;

@end

@implementation FindPasswordViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.navigationItem.title = @"找回密码";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [self.view addGestureRecognizer:singleTap];
    [self setupPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textFirld Delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;
{
    if (textField.tag == kPhoneFieldTag) {
        if (_phoneField.text.length >= 10) {
            if (!_countdowning) {
                _codeBtn.enabled = YES;
            }
        }
        else {
            _codeBtn.enabled = NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.tag == kPhoneFieldTag) {
        _codeBtn.enabled = NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.tag == kPsdFieldTag) {
        [_psdField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Action
- (void)handleTap:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}
- (void)codeButtonClicked:(UIButton*)sender
{
    _codeBtn.enabled = NO;
    [self sendPhoneCode:_phoneField.text];
    [self timeCountdown];
}
- (void)registerButtonClicked:(UIButton*)sender
{
    if (![self checkTextDidInEffect]) {
        return;
    }
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary *parameters = @{@"mobile" : self.phoneField.text,
                                 @"checkCode" : self.codeField.text,
                                 @"password" : [NSStrUtil ytLoginMD5WithPhoneNumber:self.phoneField.text password:self.psdField.text]
                                 };
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UpdatePwdForForget parameters:parameters success:^(id responseData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self userLoginSuccess:responseData[@"data"]];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
#pragma mark - login success
- (void)userLoginSuccess:(NSDictionary *)dictionary
{
    [self.view endEditing:YES];
    // 存储用户资料
    UserInfomationModel *userModel = [[UserInfomationModel alloc] initWithUserDictionary:dictionary];
    [userModel saveUserDefaults];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
    [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification object:nil];
            }];
        }
    }];
    [alert show];
}
#pragma mark - 发送验证码
- (void)sendPhoneCode:(NSString *)phoneNum
{
    if (phoneNum.length < 10) {
        [self showAlert:@"您输入的号码不正确" title:@"提示"];
        return;
    }
    NSDictionary *parameters = @{@"mobile" : _phoneField.text};
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_SendSmsCodeForForgetPwd parameters:parameters success:^(id responseData) {
    } failure:^(NSString *errorMessage) {
        [self showAlert:errorMessage title:@""];
    }];

}
- (BOOL)checkTextDidInEffect
{
    if (_phoneField.text.length < 10) {
        [self showAlert:@"请输入正确地手机号码" title:@"提示"];
        return NO;
    }
    else if ([NSStrUtil isEmptyOrNull:_codeField.text]) {
        [self showAlert:@"请输入验证码" title:@"提示"];
        return NO;
    }
    else if ([NSStrUtil isEmptyOrNull:_psdField.text]) {
        [self showAlert:@"密码不能为空" title:@"提示"];
        return NO;
    }
    else if (_psdField.text.length < 6) {
        [self showAlert:@"密码长度不能少于6位" title:@"提示"];
        return NO;
    }
    else {
        return YES;
    }
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Page subviews
- (void)setupPageSubviews
{
    _topView = UIView.new;
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    UIImageView *topLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [_topView addSubview:topLine];
    UIImageView *topLine2 = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [_topView addSubview:topLine2];
    UIImageView *topLine3 = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [_topView addSubview:topLine3];
    UIImageView *topLine4 = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [_topView addSubview:topLine4];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    
    // 线条
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(_topView);
        make.height.mas_equalTo(1);
    }];
    [topLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView).offset(50);
        make.left.mas_equalTo(_topView).offset(10);
        make.right.mas_equalTo(_topView);
        make.height.mas_equalTo(1);
    }];
    [topLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLine2).offset(50);
        make.left.right.and.height.mas_equalTo(topLine2);
    }];
    [topLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.right.mas_equalTo(_topView);
        make.height.mas_equalTo(1);
    }];
    
    // textField
    UIImageView* phoneLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    phoneLeftImageView.image = [UIImage imageNamed:@"yt_register_phone.png"];
    UIImageView* codeLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    codeLeftImageView.image = [UIImage imageNamed:@"yt_register_code.png"];
    UIImageView* psdLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    psdLeftImageView.image = [UIImage imageNamed:@"yt_login_psd.png"];
    
    
    _phoneField = [[UITextField alloc] init];
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.keyboardType = UIKeyboardTypePhonePad;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.returnKeyType = UIReturnKeyNext;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    _phoneField.enablesReturnKeyAutomatically = YES;
    _phoneField.leftView = phoneLeftImageView;
    _phoneField.placeholder = @"请输入手机号码";
    _phoneField.delegate = self;
    _phoneField.tag = kPhoneFieldTag;
    
    _codeField = [[UITextField alloc] init];
    _codeField.borderStyle = UITextBorderStyleNone;
    _codeField.keyboardType = UIKeyboardTypeNumberPad;
    _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _codeField.returnKeyType = UIReturnKeyNext;
    _codeField.leftViewMode = UITextFieldViewModeAlways;
    _codeField.enablesReturnKeyAutomatically = YES;
    _codeField.leftView = codeLeftImageView;
    _codeField.placeholder = @"请输入短信中得验证码";
    _codeField.delegate = self;
    _codeField.tag = kCodeFieldTag;
    
    _psdField = [[UITextField alloc] init];
    _psdField.borderStyle = UITextBorderStyleNone;
    _psdField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _psdField.returnKeyType = UIReturnKeyDone;
    _psdField.leftViewMode = UITextFieldViewModeAlways;
    _psdField.enablesReturnKeyAutomatically = YES;
    _psdField.leftView = psdLeftImageView;
    _psdField.placeholder = @"请输入新密码";
    _psdField.secureTextEntry = YES;
    _psdField.delegate = self;
    _psdField.tag = kPsdFieldTag;
    
    
    [_topView addSubview:_phoneField];
    [_topView addSubview:_codeField];
    [_topView addSubview:_psdField];
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView).offset(10);
        make.left.mas_equalTo(_topView).offset(5);
        make.right.mas_equalTo(_topView).offset(-100);
        make.height.mas_equalTo(30);
    }];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView).offset(60);
        make.left.mas_equalTo(_topView).offset(5);
        make.right.mas_equalTo(_topView);
        make.height.mas_equalTo(30);
    }];
    [_psdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_codeField.bottom).offset(20);
        make.left.right.and.height.mas_equalTo(_codeField);
    }];
    
    // Button
    _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_codeBtn_normal.png"] forState:UIControlStateNormal];
    [_codeBtn setBackgroundImage:[UIImage imageNamed:@"yt_register_codeBtn_disable.png"] forState:UIControlStateDisabled];
    [_codeBtn addTarget:self action:@selector(codeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_codeBtn];
    _codeBtn.enabled = NO;
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 4;
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"找回密码" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(80, 30));
    }];
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topView.bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(45*iPhoneMultiple);
    }];
}
#pragma mark - 60s 倒计时
- (void)timeCountdown
{
    _countdowning = YES;
    __block NSInteger timeout= 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                _codeBtn.titleLabel.text = @"重新发送";
                _countdowning = NO;
                if (_phoneField.text.length >= 10) {
                    _codeBtn.enabled = YES;
                }
            });
            
        }else{
            
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"(%.2ld)后重发", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _codeBtn.titleLabel.text =strTime;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
}

@end
