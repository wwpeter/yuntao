#import "PhoneRegisterViewController.h"
#import "RGTextCodeView.h"
#import "UIImage+HBClass.h"
#import "OutWebViewController.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"
#import "UserInfomationModel.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"

static NSString *const YT_Service_Agreement = @"http://user.protocol.yuntaohongbao.com";

@interface PhoneRegisterViewController ()

@property (strong, nonatomic)RGTextCodeView *rgView;
@property (strong, nonatomic) UIButton *clickBtn;
@property (strong, nonatomic) UIButton *agreementBtn;
@property (strong, nonatomic) UILabel *wordLabel;
@property (strong, nonatomic) UIButton *registerBtn;
@end

@implementation PhoneRegisterViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.navigationItem.title = @"注册";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Event response 注册
- (void)registerButtonClicked:(UIButton*)sender
{
    if (![self.rgView checkTextDidInEffect]) {
        return;
    }
    [MBProgressHUD showMessag:kYTWaitingMessage toView:self.view];
    NSDictionary *parameters = @{@"mobile" : self.rgView.phoneField.text,
                                 @"checkCode" : self.rgView.codeField.text,
                                 @"password" : [NSStrUtil ytLoginMD5WithPhoneNumber:self.rgView.phoneField.text password:self.rgView.psdField.text]
                                 };
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_Registe parameters:parameters success:^(id responseData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self userLoginSuccess:responseData[@"data"]];
    } failure:^(NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:errorMessage toView:self.view];
    }];
}
- (void)pactButtonClicked:(UIButton*)sender
{
    OutWebViewController *webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
        webVC.urlStr = YT_Service_Agreement;
        [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - Private methods
- (void)userLoginSuccess:(NSDictionary *)dictionary
{
       [self.view endEditing:YES];
    // 存储用户资料
    UserInfomationModel *userModel = [[UserInfomationModel alloc] initWithUserDictionary:dictionary];
    [userModel saveUserDefaults];
    [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification
                                                                object:nil];
        }];
}

- (void)sendVerificationCodeWithPhone:(NSString *)phoneText
{
    if (phoneText.length < 10) {
        [self showAlert:@"您输入的号码不正确" title:@"提示"];
        return;
    }
    NSDictionary *parameters = @{@"mobile" : phoneText};
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_RegMobile parameters:parameters success:^(id responseData) {
#pragma mark - dug模式下的短信信息提示
#if DEBUG
        [self showAlert:responseData[@"data"] title:@""];
#endif
        
    } failure:^(NSString *errorMessage) {
        [self showAlert:errorMessage title:@""];
    }];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.rgView = [[RGTextCodeView alloc] init];
    [self.view addSubview:self.rgView];
    __weak __typeof(self)weakSelf = self;
    _rgView.verificationBlock = ^(NSString *mobile){
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf sendVerificationCodeWithPhone:mobile];
    };
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _registerBtn.layer.masksToBounds = YES;
    _registerBtn.layer.cornerRadius = 4;
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clickBtn setImage:[UIImage imageNamed:@"yt_register_selectBtn_select.png"] forState:UIControlStateNormal];
    [_clickBtn addTarget:self action:@selector(clickBtnPre:) forControlEvents:UIControlEventTouchUpInside];
    
    _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreementBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [_agreementBtn setBackgroundColor:[UIColor clearColor]];
    [_agreementBtn addTarget:self action:@selector(agreementBtnPre:) forControlEvents:UIControlEventTouchUpInside];
    
    _wordLabel = [[UILabel alloc]init];
    _wordLabel.font = [UIFont systemFontOfSize:15];
    _wordLabel.text = @"我已阅读并同意云淘红包";
    _wordLabel.textColor = CCCUIColorFromHex(0x666666);
    [self.view addSubview:_clickBtn];
    [self.view addSubview:_agreementBtn];
    [self.view addSubview:_wordLabel];
//    [self.view addSubview:pactBtn];

    [_rgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rgView.bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(45*iPhoneMultiple);
    }];
    [_clickBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.top.mas_equalTo(_registerBtn.bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
    }];
    [_wordLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_clickBtn.right);
        make.centerY.mas_equalTo(_clickBtn);
    }];
    [_agreementBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_wordLabel.right);
        make.centerY.mas_equalTo(_wordLabel);
    }];
//    [pactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(registerBtn.bottom).offset(15);
//        make.left.mas_equalTo(self.view).offset(15);
//        make.width.mas_equalTo(90);
//        make.height.mas_equalTo(20);
//    }];
}
#pragma mark - Event response
-(void)clickBtnPre:(id)sender
{
    if (_registerBtn.enabled) {
        [_clickBtn setImage:[UIImage imageNamed:@"yt_register_selectBtn_cancel.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_clickBtn setImage:[UIImage imageNamed:@"yt_register_selectBtn_select.png"] forState:UIControlStateNormal];
    }
    _registerBtn.enabled = !_registerBtn.enabled;
}

-(void)agreementBtnPre:(id)sender
{
    OutWebViewController *webVC = [[OutWebViewController alloc]initWithURL:YT_Service_Agreement title:@"用户协议" isShowRight:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
