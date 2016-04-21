#import "PhoneRegisterViewController.h"
#import "RGTextCodeView.h"
#import "UIImage+HBClass.h"
#import "OutWebViewController.h"

static NSString *const YT_Service_Agreement = @"http://www.sairongpay.com/abouts/ArticleContent.aspx?ID=1619&ClassID=2";

@interface PhoneRegisterViewController ()

@property (strong, nonatomic)RGTextCodeView *rgView;
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
#pragma mark - Event response
- (void)registerButtonClicked:(UIButton*)sender
{
    [self.view endEditing:YES];
}
- (void)pactButtonClicked:(UIButton*)sender
{
    OutWebViewController *webVC = [[OutWebViewController alloc] initWithNibName:@"OutWebViewController" bundle:nil];
        webVC.urlStr = YT_Service_Agreement;
        [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - Private methods
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.rgView = [[RGTextCodeView alloc] init];
    [self.view addSubview:self.rgView];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 4;
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *pactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pactBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [pactBtn setTitleColor:CCCUIColorFromHex(0x007aff) forState:UIControlStateNormal];
    [pactBtn setTitle:@"服务协议>>" forState:UIControlStateNormal];
    [pactBtn addTarget:self action:@selector(pactButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pactBtn];

    [_rgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rgView.bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(45*iPhoneMultiple);
    }];
    [pactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(registerBtn.bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(20);
    }];
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
