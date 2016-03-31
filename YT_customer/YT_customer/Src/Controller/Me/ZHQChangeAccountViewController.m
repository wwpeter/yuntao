//
//  ZHQChangeAccountViewController.m
//  YT_customer
//
//  Created by 郑海清 on 15/6/15.
//  Copyright (c) 2015年 sairongpay. All rights reserved.
//

#import "ZHQChangeAccountViewController.h"
#import "YTNetworkMange.h"
#import "NSStrUtil.h"
#import "MBProgressHUD+Add.h"

@interface ZHQChangeAccountViewController ()

@end

@implementation ZHQChangeAccountViewController


#pragma mark - Life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Page subviews
-(void)setUp
{
    switch (_viewType) {
        case NickView:
            [self createNickView];
            break;
        case PhoneView:
            [self createPhoneView];
            break;
            
        case NewPhoneView:
            [self createPhoneView];
            break;
        case PasswordView:
            [self createPasswordView];
            break;
        default:
            break;
    }
    
    UIImage *norImage = [UIImage imageNamed:@"yt_navigation_backBtn_normal.png"];
    UIImage *higlImage = [UIImage imageNamed:@"yt_navigation_backBtn_high.png"];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomImage:norImage highlightImage:higlImage target:self action:@selector(didLeftBarButtonItemAction:)];
}
-(void)createNickView
{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.bottomLine];
    [self.view addSubview:backView];
    [self.view addSubview:self.bottomBtn];
    [backView addSubview:self.nickTextField];
    self.navigationItem.title = @"修改昵称";
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(64 + 15);
        make.height.offset(50);
    }];
    
    [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(backView.bottom).offset(20);
        make.height.offset(44);
    }];
    
    [_topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_nickTextField.top);
        make.height.offset(0.5);
    }];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(backView.bottom);
        make.height.offset(0.5);
    }];
    
    
    [_nickTextField makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(backView);
        make.left.mas_equalTo(backView).offset(15);
        
    }];
}
-(void)createPhoneView
{
    UIView *backView = [[UIView alloc]init];
    UIImageView *phoneImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yt_register_phone.png"]];
    UIImageView *codeImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yt_register_code.png"]];
    
    backView.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.bottomLine];
    [self.view addSubview:backView];
    [backView addSubview:self.phoneTextField];
    [backView addSubview:self.codeTextField];
    [backView addSubview:self.getCode];
    [self.view addSubview:self.bottomBtn];
    [backView addSubview:phoneImg];
    [backView addSubview:codeImg];
    
    UIView *midLine = [[UIView alloc]init];
    midLine.backgroundColor = CCCUIColorFromHex(0xCCCCCC);
    [backView addSubview:midLine];
    
    if (_viewType == PhoneView)
    {
        
        self.navigationItem.title = @"修改手机绑定";
    }
    else
    {
        
        self.navigationItem.title = @"绑定手机绑定";
    }
    
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(64 + 15);
        make.height.offset(100 + 0.5);
    }];
    
    [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(backView.bottom).offset(20);
        make.height.offset(44);
    }];
    
    
    [_topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.bottom.equalTo(backView.top);
        make.height.offset(0.5);
    }];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backView);
        make.top.equalTo(backView.bottom);
        make.height.offset(0.5);
    }];
    [phoneImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(15);
        make.centerY.equalTo(_phoneTextField);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [_phoneTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.top);
        make.height.offset(50);
        make.left.mas_equalTo(phoneImg.right).offset(15);
        make.right.equalTo(self.getCode.left).offset(-15);
        
    }];

    [midLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneTextField.bottom);
        make.left.mas_equalTo(backView).offset(15);
        make.right.equalTo(backView);
        make.height.offset(0.5);
    }];

    [codeImg makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(15);
        make.centerY.equalTo(_codeTextField);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    
    [_codeTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLine.bottom);
        make.left.mas_equalTo(codeImg.right).offset(15);
        make.height.offset(50);
    }];

    [_getCode makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.centerY.equalTo(_phoneTextField);
        make.right.equalTo(backView).offset(-15);
    }];
}
-(void)createPasswordView
{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
    [self.view addSubview:backView];
    
    [self.view addSubview:self.topLine];
    [self.view addSubview:self.bottomLine];
    [backView addSubview:self.oldPasswordTextField];
    [backView addSubview:self.tPasswordTextField];
    [backView addSubview:self.checkPasswordTextField];
    [self.view addSubview:self.bottomBtn];
    
    UIView *midLine1 = [[UIView alloc]init];
    midLine1.backgroundColor = CCCUIColorFromHex(0xCCCCCC);
    UIView *midLine2 = [[UIView alloc]init];
    midLine2.backgroundColor = CCCUIColorFromHex(0xCCCCCC);
    
    [backView addSubview:midLine1];
    [backView addSubview:midLine2];
    self.navigationItem.title = @"修改密码";
    
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(64 + 15);
        make.height.offset(150 + 1);
    }];
    
    [_bottomBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(backView.bottom).offset(20);
        make.height.offset(44);
    }];
    
    [_topLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(backView.top);
        make.height.offset(0.5);
    }];
    [_bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(backView.bottom);
        make.height.offset(0.5);
    }];
    
    [_oldPasswordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(backView);
        make.left.mas_equalTo(backView).offset(15);
        make.height.offset(50);
    }];
    [midLine1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oldPasswordTextField.bottom);
        make.right.equalTo(_oldPasswordTextField);
        make.height.offset(0.5);
        make.left.mas_equalTo(backView).offset(15);
    }];
    [_tPasswordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLine1.bottom);
        make.left.equalTo(backView).offset(15);
        make.right.equalTo(backView);
        make.height.offset(50);
    }];
    
    [midLine2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tPasswordTextField.bottom);
        make.right.equalTo(_tPasswordTextField.right);
        make.height.offset(0.5);
        make.left.mas_equalTo(backView).offset(15);
    }];
    
    [_checkPasswordTextField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(midLine2.bottom);
        make.right.equalTo(backView);
        make.left.mas_equalTo(backView).offset(15);
        make.height.offset(50);
        
    }];
}
#pragma mark - Event  response
-(void)didLeftBarButtonItemAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)didRightBarButtonItemAction:(id)sender
{
    switch (_viewType) {
        case NickView:
            _block(_nickTextField.text,_viewType);
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
        case PhoneView:
        {
            ZHQChangeAccountViewController *vc = [[ZHQChangeAccountViewController alloc] init];
            vc.viewType = NewPhoneView;
            vc.block = self.block;
            [self.navigationController pushViewController:vc animated:YES];
        }
       
            break;
        case NewPhoneView:
            _block(_phoneTextField.text,_viewType);
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            break;
        case PasswordView:
        {
            if ([_tPasswordTextField.text isEqualToString:_checkPasswordTextField.text])
            {
                //上传密码
                NSDictionary* parameters = @{ @"oldPassWord" : [NSStrUtil ytLoginMD5WithPhoneNumber:@"" password:_oldPasswordTextField.text],
                                              @"newPassWord" : [NSStrUtil ytLoginMD5WithPhoneNumber:@"" password:_tPasswordTextField.text] };
                [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UpdatePassWord
                                                            parameters:parameters
                                                               success:^(id responseData) {
                                                                   
                                                               }
                                                               failure:^(NSString* errorMessage){
                                                                   [MBProgressHUD showError:errorMessage toView:self.view];
                                                                   
                                                               }];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"密码输入不一致，请检查输入" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
        }
            
            break;
        default:
            break;
    }
    
    if (_viewType != PhoneView)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
  
    }
}


-(void)getCode:(id)sender
{
    //获取验证码
    [self timeCountdown];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_nickTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_oldPasswordTextField resignFirstResponder];
    [_tPasswordTextField resignFirstResponder];
    [_checkPasswordTextField resignFirstResponder];
}


#pragma mark - textFirld Delegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;
{
    if (textField == _phoneTextField) {
        if (_phoneTextField.text.length >= 10) {
            if (!_countdowning) {
                _getCode.enabled = YES;
            }
        }
        else {
            _getCode.enabled = NO;
        }
    }
    return YES;
}


#pragma mark Getters & Setters
-(UITextField *)nickTextField
{
    if (!_nickTextField) {
        _nickTextField = [[UITextField alloc]init];
        _nickTextField.placeholder = @"请输入新昵称";
        _nickTextField.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
        _nickTextField.textColor = CCCUIColorFromHex(0x333333);
        _nickTextField.tintColor = YTDefaultRedColor;
    }
    return _nickTextField;
};


-(UITextField *)phoneTextField
{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        
        if (_viewType == NewPhoneView)
        {
            _phoneTextField.placeholder = @"请输入新手机号";
        }
        else
        {
            _phoneTextField.placeholder = @"请输入旧手机号";
        }
        
        _phoneTextField.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
        _phoneTextField.textColor = CCCUIColorFromHex(0x333333);
        _phoneTextField.tintColor = YTDefaultRedColor;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
};

-(UITextField *)codeTextField
{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.placeholder = @"请输入手机短信中的验证码";
        _codeTextField.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
        _codeTextField.textColor = CCCUIColorFromHex(0x333333);
        _codeTextField.tintColor = YTDefaultRedColor;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeTextField;
}


-(UITextField *)oldPasswordTextField
{
    if (!_oldPasswordTextField) {
        _oldPasswordTextField = [[UITextField alloc]init];
        _oldPasswordTextField.placeholder = @"请输入现有密码";
        _oldPasswordTextField.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
        _oldPasswordTextField.textColor = CCCUIColorFromHex(0x333333);
        _oldPasswordTextField.secureTextEntry = YES;
        _oldPasswordTextField.tintColor = YTDefaultRedColor;
    }
    return _oldPasswordTextField;
};

-(UITextField *)tPasswordTextField
{
    if (!_tPasswordTextField) {
        _tPasswordTextField = [[UITextField alloc]init];
        _tPasswordTextField.placeholder = @"请输入新密码";
        _tPasswordTextField.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
        _tPasswordTextField.textColor = CCCUIColorFromHex(0x333333);
        _tPasswordTextField.secureTextEntry = YES;
        _tPasswordTextField.tintColor = YTDefaultRedColor;
    }
    return _tPasswordTextField;
};

-(UITextField *)checkPasswordTextField
{
    if (!_checkPasswordTextField) {
        _checkPasswordTextField = [[UITextField alloc]init];
        _checkPasswordTextField.placeholder = @"请再次输入新密码";
        _checkPasswordTextField.backgroundColor = CCCUIColorFromHex(0xFFFFFF);
        _checkPasswordTextField.textColor = CCCUIColorFromHex(0x333333);
        _checkPasswordTextField.secureTextEntry = YES;
        _checkPasswordTextField.tintColor = YTDefaultRedColor;
    }
    return _checkPasswordTextField;
}

-(UIButton *)getCode
{
    if (!_getCode)
    {
        _getCode = [UIButton buttonWithType:UIButtonTypeCustom];
        _getCode.titleLabel.font = [UIFont systemFontOfSize:13];
        [_getCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCode setBackgroundImage:[UIImage imageNamed:@"yt_register_codeBtn_normal.png"] forState:UIControlStateNormal];
        [_getCode setBackgroundImage:[UIImage imageNamed:@"yt_register_codeBtn_disable.png"] forState:UIControlStateDisabled];
        [_getCode addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
        _getCode.enabled = NO;

    }

    return _getCode;
}

-(UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        switch (_viewType) {
            case NickView:
                [_bottomBtn setTitle:@"确认修改" forState:UIControlStateNormal];
                break;
            case PhoneView:
                [_bottomBtn setTitle:@"验证" forState:UIControlStateNormal];
                break;
            case NewPhoneView:
                [_bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
                break;
            case PasswordView:
                [_bottomBtn setTitle:@"确认修改" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        [_bottomBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(didRightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn.layer.masksToBounds = YES;
        _bottomBtn.layer.cornerRadius = 3;
    }
    
    
    return _bottomBtn;
}

-(UIView *)topLine
{
    
    if (!_topLine) {
        _topLine = [[UIView alloc]init];
        _topLine.backgroundColor = CCCUIColorFromHex(0xCCCCCC);
        
    }
    return _topLine;
}

-(UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = CCCUIColorFromHex(0xCCCCCC);
    }
    return _bottomLine;
}


#pragma mark - 60s 倒计时
- (void)timeCountdown
{
//    _countdowning = YES;
    __block NSInteger timeout= 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                _getCode.titleLabel.text = @"重新发送";
                _countdowning = NO;
                if (_phoneTextField.text.length >= 10) {
                    _getCode.enabled = YES;
                }
            });
            
        }else{
            
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"(%.2ld)后重发", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                _getCode.titleLabel.text =strTime;
            });
            timeout--;
        }
    });
    
    dispatch_resume(_timer);
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
