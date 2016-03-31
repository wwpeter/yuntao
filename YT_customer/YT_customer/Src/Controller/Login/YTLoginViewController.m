#import "YTLoginViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "UIImage+HBClass.h"
#import "PhoneRegisterViewController.h"
#import "BusinessRegisterViewController.h"
#import "FindPasswordViewController.h"
#import "YTNetworkMange.h"
#import "UserInfomationModel.h"
#import "MBProgressHUD+Add.h"
#import "NSStrUtil.h"

@interface YTLoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *phoneField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIButton *loginBtn;

@end

@implementation YTLoginViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.navigationItem.title = @"登录";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    UIImage *norImage = [UIImage imageNamed:@"yt_navigation_backBtn_normal.png"];
    UIImage *higlImage = [UIImage imageNamed:@"yt_navigation_backBtn_high.png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:norImage highlightImage:higlImage target:self action:@selector(didLeftBarButtonItemAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self setupPageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - textField Delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;
{
    if (_phoneField.text.length > 0 && _passwordField.text.length > 1 && range.location > 0) {
        [self didLoginButtonChange:YES];
    }
    else {
        [self didLoginButtonChange:NO];
    }
    
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self didLoginButtonChange:NO];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (textField.tag == 1000) {
        [_passwordField becomeFirstResponder];
    } else {
        [_passwordField resignFirstResponder];
        [self userNameLogin];
    }
    return YES;
}
#pragma mark - Button Avtion
- (void)loginButtonClicked:(UIButton*)sender
{
    [self userNameLogin];
}
- (void)forgetButtonClicked:(UIButton*)sender
{
    FindPasswordViewController *findPasswordVC = [[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

- (void)userNameLogin
{
    [self.view endEditing:YES];
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary *parameters = @{@"mobile" : self.phoneField.text,
                                 @"password" : [NSStrUtil ytLoginMD5WithPhoneNumber:self.phoneField.text password:self.passwordField.text]
                                 };
    __weak __typeof(self)weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_Login parameters:parameters success:^(id responseData) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        //用户资料
        [strongSelf userLoginSuccess:responseData[@"data"]];
    } failure:^(NSString *errorMessage) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [MBProgressHUD showError:errorMessage toView:strongSelf.view];
        if (strongSelf.failureBlock) {
            strongSelf.failureBlock();
        }
    }];
}
#pragma mark - Login success
- (void)userLoginSuccess:(NSDictionary *)dictionary
{
   
    // 存储用户资料
    UserInfomationModel *userModel = [[UserInfomationModel alloc] initWithUserDictionary:dictionary];
    [userModel saveUserDefaults];
    if (self.successBlock) {
        self.successBlock();
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification
                                                            object:nil];
    }];
}
#pragma mark - Event response 处理按钮状态
- (void)didLoginButtonChange:(BOOL)enabled
{
    if (enabled) {
        _loginBtn.userInteractionEnabled = YES;
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
    }
    else {
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setTitleColor:CCCUIColorFromHex(0xbfbfbf) forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xdedede)] forState:UIControlStateNormal];
    }
}
#pragma mark - Navigation
- (void)didLeftBarButtonItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didRightBarButtonItemAction:(id)sender
{
    if (_loginType == LoginViewTypeBusiness) {
        BusinessRegisterViewController *registerVC = [[BusinessRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
        
    } else {
        PhoneRegisterViewController *registerVC = [[PhoneRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }
}

#pragma mark - Page subviews
- (void)setupPageSubviews
{
    UIView *topView = UIView.new;
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *topLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [topView addSubview:topLine];
    UIImageView *topLine2 = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [topView addSubview:topLine2];
    UIImageView *topLine3 = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [topView addSubview:topLine3];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    // 线条
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(topView);
        make.height.mas_equalTo(1);
    }];
    [topLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView).offset(50);
        make.left.mas_equalTo(topView).offset(10);
        make.right.mas_equalTo(topView);
        make.height.mas_equalTo(1);
    }];
    [topLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.right.mas_equalTo(topView);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView* phoneLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    phoneLeftImageView.image = [UIImage imageNamed:@"yt_login_user.png"];
    UIImageView* wordLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    wordLeftImageView.image = [UIImage imageNamed:@"yt_login_psd.png"];
    
    _phoneField = [[UITextField alloc] init];
    _phoneField.borderStyle = UITextBorderStyleNone;
    _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneField.returnKeyType = UIReturnKeyNext;
    _phoneField.leftViewMode = UITextFieldViewModeAlways;
    _phoneField.enablesReturnKeyAutomatically = YES;
    _phoneField.leftView = phoneLeftImageView;
    _phoneField.placeholder = @"手机号/邮箱";
#if DEBUG
    _phoneField.text = @"18667112173";
#endif
    _phoneField.delegate = self;
    _phoneField.tag = 1000;
    
    _passwordField = [[UITextField alloc] init];
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.enablesReturnKeyAutomatically = YES;
    _passwordField.leftView = wordLeftImageView;
    _passwordField.placeholder = @"请输入密码";
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    _passwordField.tag = 1001;
    
    [topView addSubview:_phoneField];
    [topView addSubview:_passwordField];
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(topView).offset(5);
        make.top.mas_equalTo(topView).offset(10);
        make.right.mas_equalTo(topView);
        make.height.mas_equalTo(30);
    }];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phoneField.bottom).offset(20);
        make.left.right.and.height.mas_equalTo(_phoneField);
    }];
    
    // Button 登陆按钮
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 4;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    [self didLoginButtonChange:NO];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [forgetBtn setTitleColor:CCCUIColorFromHex(0x666666) forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(45*iPhoneMultiple);
    }];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginBtn.bottom).offset(15);
        make.right.mas_equalTo(_loginBtn);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(20);
    }];
}

@end
