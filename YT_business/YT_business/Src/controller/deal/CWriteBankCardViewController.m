#import "CWriteBankCardViewController.h"
#import "RGActionView.h"
#import "RGFieldView.h"
#import "UIImage+HBClass.h"
#import "UIView+DKAddition.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "CBankVerifyCodeViewController.h"

@interface CWriteBankCardViewController ()
@property (strong, nonatomic) RGActionView* cardView;
@property (strong, nonatomic) RGFieldView* phoneView;
@property (strong, nonatomic) UIButton* nextButton;
@end

@implementation CWriteBankCardViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"填写银行卡信息";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Event response
- (void)nextButtonClicked:(id)sender
{
    if (self.phoneView.textFiled.text.length < 11) {
        [self showAlert:@"请输入正确的手机号" title:@""];
    }
    else {
        CBankVerifyCodeViewController* bankVerifyCodeVC = [[CBankVerifyCodeViewController alloc] initWithPhoneNum:self.phoneView.textFiled.text];
        [self.navigationController pushViewController:bankVerifyCodeVC animated:YES];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.cardView];
    [self.view addSubview:self.phoneView];
    NSString* agreementText = @"点击下一步代表同意";
    CGFloat textWidth = [NSStrUtil stringWidthWithString:agreementText stringFont:[UIFont systemFontOfSize:14]];
    UILabel* agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _phoneView.dk_bottom + 15, textWidth, 20)];
    agreementLabel.textColor = CCCUIColorFromHex(0x333333);
    agreementLabel.font = [UIFont systemFontOfSize:14];
    agreementLabel.text = agreementText;

    UIButton* agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreementBtn.frame = CGRectMake(agreementLabel.dk_x + textWidth, agreementLabel.dk_y, 90, 20);
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [agreementBtn setTitleColor:CCCUIColorFromHex(0x007aff) forState:UIControlStateNormal];
    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [self.view addSubview:agreementLabel];
    [self.view addSubview:agreementBtn];

    [self.view addSubview:self.nextButton];
}
#pragma mark - Getters & Setters
- (RGActionView*)cardView
{
    if (!_cardView) {
        _cardView = [[RGActionView alloc] initWithTitle:@"卡类型" frame:CGRectMake(0, 15, kDeviceWidth, 50)];
        _cardView.backgroundColor = [UIColor whiteColor];
        _cardView.arrowView.hidden = YES;
        _cardView.displayTopLine = YES;
        _cardView.detailLabel.text = @"华夏银行 储蓄卡";
        _cardView.detailLabel.textColor = CCCUIColorFromHex(0x4b649d);
    }
    return _cardView;
}
- (RGFieldView*)phoneView
{
    if (!_phoneView) {
        _phoneView = [[RGFieldView alloc] initWithTitle:@"手机号" frame:CGRectMake(0, 15 + 50, kDeviceWidth, 50)];
        _phoneView.backgroundColor = [UIColor whiteColor];
        _phoneView.keyboardType = UIKeyboardTypeDecimalPad;
        _phoneView.leftMargin = 0;
        _phoneView.placeholder = @"请输入银行预留手机号";
    }
    return _phoneView;
}
- (UIButton*)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(15, 15 + 100 + 55, kDeviceWidth - 30, 45);
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

@end
