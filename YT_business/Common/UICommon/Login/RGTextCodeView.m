
#import "YTRegisterHelper.h"
#import "RGTextCodeView.h"
#import "NSStrUtil.h"

#define kPhoneFieldTag 2000
#define kCodeFieldTag 2001
#define kPsdFieldTag 2002

@implementation RGTextCodeView

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    self.backgroundColor = [UIColor whiteColor];
    [self configureSubviews];
    
    return self;
}
#pragma mark - Public methods
- (BOOL)checkTextDidInEffect
{
    if (_phoneField.text.length < 11) {
        [self showAlert:@"请输入正确手机号码" title:@"提示"];
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
- (void)codeButtonClicked:(UIButton*)sender {
    _codeBtn.enabled = NO;
    [self timeCountdown];
    if (self.validCodeBlock) {
        self.validCodeBlock(self.phoneField.text);
        [YTRegisterHelper registerHelper].mobile = self.phoneField.text;
    }
}
-(void)configureSubviews
{
    UIImageView *topLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [self addSubview:topLine];
    UIImageView *topLine2 = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [self addSubview:topLine2];
    UIImageView *topLine3 = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [self addSubview:topLine3];
    UIImageView *topLine4 = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [self addSubview:topLine4];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [topLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(50);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [topLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topLine2).offset(50);
        make.left.right.and.height.mas_equalTo(topLine2);
    }];
    [topLine4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.right.mas_equalTo(self);
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
    _codeField.placeholder = @"请输入短信中验证码";
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
    
    
    [self addSubview:_phoneField];
    [self addSubview:_codeField];
    [self addSubview:_psdField];
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.left.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self).offset(-100);
        make.height.mas_equalTo(30);
    }];
    [_codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(60);
        make.left.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self);
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
    [self addSubview:_codeBtn];
    _codeBtn.enabled = NO;
    
    [_codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(80, 30));
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

- (void)showAlert:(NSString*)msg title:(NSString*)title
{
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:msg
                          delegate:nil
                          cancelButtonTitle:@"关闭"
                          otherButtonTitles:nil];
    [alert show];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
