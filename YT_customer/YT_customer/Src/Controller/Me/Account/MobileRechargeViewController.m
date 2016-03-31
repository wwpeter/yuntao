#import "MobileRechargeViewController.h"
#import "CCTextField.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "MBProgressHUD+Add.h"
#import <AddressBookUI/AddressBookUI.h>
#import "MobileRechargeAmountView.h"
#import "ZCTradeView.h"
#import "CYCSuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "UIAlertView+TTBlock.h"

@interface MobileRechargeViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) CCTextField *textField;
@property (strong, nonatomic) UIButton *contactBtn;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) MobileRechargeAmountView *amountView;
@property (strong, nonatomic) NSNumber *amount;

@end

@implementation MobileRechargeViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手机充值";
    [self initializePageSubviews];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel*)parserObject
              errorMessage:(NSString*)errorMessage
{
    if (parserObject.success) {
        if ([request.url isEqualToString:YC_Request_MemberMobileCharge]) {
            CYCSuccessViewController* successVC = [[CYCSuccessViewController alloc] init];
            successVC.successTitle = @"充值成功";
            successVC.successDescribe = [NSString stringWithFormat:@"%@,充值金额%@", self.textField.text, self.amount];
            [self.navigationController pushViewController:successVC animated:YES];
        }
    }
    else {
        if ([request.url isEqualToString:YC_Request_MemberMobileCharge]) {
            if ([errorMessage isEqualToString:@"支付密码不正确"]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"您输入的密码错误，请联系客服" message:@"400-117-7677" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                __weak __typeof(self) weakSelf = self;
                [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf callPhoneNumber:YT_Service_Number];
                }];
                [alert show];
                return;
            }
        }
            [self showAlert:errorMessage title:@""];
    }
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
// 8.0之后才会调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    /*
     NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
     if (firstName==nil) {
     firstName = @" ";
     }
     NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
     if (lastName==nil) {
     lastName = @" ";
     }
     */
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:0];
    }
    _textField.text = phone;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

// Called after the user has pressed cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

// 8.0之前才会调用
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

// 8。0之前才会调用
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier {
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    /*
     NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
     if (firstName==nil) {
     firstName = @" ";
     }
     NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
     if (lastName==nil) {
     lastName = @" ";
     }
     */
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    NSString *phone = @"";
    if (phones.count > 0) {
        phone = [phones objectAtIndex:0];
    }
    _textField.text = phone;
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    // 不执行默认的操作，如，打电话
    return NO;
}
#pragma mark - Private methods
- (void)mobileChargeWithAnoumt:(NSNumber *)amount
{
    if (self.textField.text.length < 11) {
        [self showAlert:@"请先输入手机号哦~" title:@""];
    }  else{
        [self.textField resignFirstResponder];
        ZCTradeView *tradeView = [[ZCTradeView alloc] initWithInputTitle:@"请输入支付密码" frame:CGRectZero];
        self.amount = amount;
        __weak __typeof(self)weakSelf = self;
        tradeView.finish = ^(NSString *passWord){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.requestParas = @{@"mobile" : strongSelf.textField.text,
                                        @"type" : @1,
                                        @"payPasswd" : [passWord GetMD5],
                                        loadingKey : @(YES)};
            strongSelf.requestURL = YC_Request_MemberMobileCharge;
        };
        [tradeView show];
    }
}
#pragma mark - Event response
- (void)contactButtonClickde:(id)sender
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    picker.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (void)fullViewTap:(UITapGestureRecognizer*)tap
{
    [self.textField resignFirstResponder];
}
- (void)fullViewThirdTap:(UITapGestureRecognizer*)tap
{
    [self mobileChargeWithAnoumt:@1];
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
    [self.backView addSubview:self.contactBtn];
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.amountView];
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
        make.edges.equalTo(_backView).with.insets(UIEdgeInsetsMake(2, 0, 2, 35));
    }];
    [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backView).offset(-15);
        make.centerY.mas_equalTo(_backView);
        make.size.mas_equalTo(CGSizeMake(20, 22));
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_backView.bottom).offset(10);
        make.right.mas_equalTo(_backView);
    }];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewTap:)]];
    
    UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewThirdTap:)];
    thirdTap.numberOfTapsRequired = 3;
    thirdTap.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:thirdTap];
    
   __weak __typeof(self)weakSelf = self;
    self.amountView.selectBlock = ^(NSNumber *amount) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf mobileChargeWithAnoumt:amount];
    };
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
        _textField.font = [UIFont systemFontOfSize:18];
        _textField.textColor = [UIColor blackColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType =UIReturnKeyDone;
        _textField.enablesReturnKeyAutomatically = YES;
        //        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.delegate = self;
    }
    return _textField;
}
- (UIButton *)contactBtn
{
    if (!_contactBtn) {
        _contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contactBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_contactBtn setImage:[UIImage imageNamed:@"face_pay_phonebook.png"] forState:UIControlStateNormal];
        [_contactBtn addTarget:self action:@selector(contactButtonClickde:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactBtn;
}
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = CCCUIColorFromHex(0x666666);
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.numberOfLines = 1;
        _messageLabel.text = @"充话费";
    }
    return _messageLabel;
}
- (MobileRechargeAmountView *)amountView
{
    if (!_amountView) {
        _amountView = [[MobileRechargeAmountView alloc] initWithFrame:CGRectMake(0, 105, kDeviceWidth, kDeviceWidth*2/3)];
    }
    return _amountView;
}


@end
