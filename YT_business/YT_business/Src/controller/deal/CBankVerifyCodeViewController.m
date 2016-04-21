#import "CBankVerifyCodeViewController.h"
#import "UIImage+HBClass.h"
#import "CWithdrawSuccessViewController.h"

@interface CBankVerifyCodeViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel* messageLabel;
@property (strong, nonatomic) UITextField* codeField;
@property (strong, nonatomic) UIButton* codeBtn;
@property (strong, nonatomic) UIImageView* textBackImageView;
@property (strong, nonatomic) UIButton* nextButton;
@end

@implementation CBankVerifyCodeViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (instancetype)initWithPhoneNum:(NSString*)phoneNum
{
    self = [super init];
    if (self) {
        _phoneNum = phoneNum;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"验证手机号";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    [self initializePageSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.codeField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Event response
- (void)codeButtonClicked:(UIButton*)sender
{
    _codeBtn.enabled = NO;
    //    [self sendPhoneCode:_phoneField.text];
    [self timeCountdown];
}
- (void)nextButtonClicked:(id)sender
{
    CWithdrawSuccessViewController *withdrawSuccessVC = [[CWithdrawSuccessViewController alloc] init];
    [self.navigationController pushViewController:withdrawSuccessVC animated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.messageLabel];
    NSString* phoneText = [_phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, _phoneNum.length - 7) withString:@"****"];
    self.messageLabel.text = [NSString stringWithFormat:@"本次操作需要短信验证,验证码已发送至手机: %@,请按提示操作。", phoneText];
    [self.view addSubview:self.textBackImageView];
    [self.view addSubview:self.codeField];
    [self.view addSubview:self.codeBtn];
    [self.view addSubview:self.nextButton];
    
    NSInteger fieldWidth = (CGRectGetWidth(self.view.bounds)-45)/3;
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(20);
    }];
    [_textBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_messageLabel.bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(2*fieldWidth, 50));
    }];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_textBackImageView.left).offset(20);
        make.top.bottom.right.mas_equalTo(_textBackImageView);
    }];
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_textBackImageView.right).offset(15);
        make.right.mas_equalTo(-15);
        make.top.bottom.mas_equalTo(_textBackImageView);
    }];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_textBackImageView.bottom).offset(25);
        make.height.mas_equalTo(45);
    }];
}
#pragma mark - Getters & Setters
- (UILabel*)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = UILabel.new;
        _messageLabel.numberOfLines = 2;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.textColor = CCCUIColorFromHex(0x666666);
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _messageLabel;
}
- (UITextField*)codeField
{
    if (!_codeField) {
        _codeField = [[UITextField alloc] init];
        _codeField.borderStyle = UITextBorderStyleNone;
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeField.returnKeyType = UIReturnKeyDone;
        _codeField.enablesReturnKeyAutomatically = YES;
        _codeField.placeholder = @"短信验证码";
        _codeField.delegate = self;
    }
    return _codeField;
}
- (UIButton*)codeBtn
{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _codeBtn.layer.masksToBounds = YES;
        _codeBtn.layer.cornerRadius = 4;
        _codeBtn.layer.borderWidth = 0.5f;
        _codeBtn.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
        [_codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_codeBtn setTitleColor:CCCUIColorFromHex(0x666666) forState:UIControlStateDisabled];
        [_codeBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xf5f5f5)] forState:UIControlStateNormal];
        [_codeBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xbebebe)] forState:UIControlStateDisabled];
        [_codeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(codeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}
- (UIImageView *)textBackImageView
{
    if (!_textBackImageView) {
        _textBackImageView = [[UIImageView alloc] init];
        _textBackImageView.backgroundColor = [UIColor whiteColor];
        _textBackImageView.layer.masksToBounds = YES;
        _textBackImageView.layer.cornerRadius = 4;
        _textBackImageView.layer.borderWidth = 0.5f;
        _textBackImageView.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    }
    return _textBackImageView;
}
- (UIButton*)nextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
#pragma mark - 60s 倒计时
- (void)timeCountdown
{
    __block NSInteger timeout = 60;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行

    dispatch_source_set_event_handler(_timer, ^{

        if (timeout <= 0) { //倒计时结束，关闭

            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _codeBtn.titleLabel.text = @"重新验证码";
                _codeBtn.enabled = YES;
            });
        }
        else {

            NSInteger seconds = timeout % 60;
            NSString* strTime = [NSString stringWithFormat:@"(%.2ld)后重发", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _codeBtn.titleLabel.text = strTime;
            });
            timeout--;
        }
    });

    dispatch_resume(_timer);
}

@end
