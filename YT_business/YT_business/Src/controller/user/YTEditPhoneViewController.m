#import "YTEditPhoneViewController.h"
#import "UIViewController+Helper.h"
#import "RGTextCodeView.h"
#import "UIImage+HBClass.h"
#import "UIAlertView+TTBlock.h"

@interface YTEditPhoneViewController ()
@property (strong, nonatomic) RGTextCodeView* rgView;
@end

@implementation YTEditPhoneViewController

#pragma mark - Life cycle
- (id)init
{
    if ((self = [super init])) {
        self.navigationItem.title = @"修改手机绑定";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:updateMobileURL]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [YTUsr usr].mobile = _rgView.phoneField.text;
            wSelf(wSelf);
            [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
                __strong __typeof(wSelf) strongSelf = wSelf;
                if (buttonIndex == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];

            [alert show];
        }
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}

#pragma mark - Event response
- (void)doneButtonClicked:(id)sender
{
    BOOL isValid = [_rgView checkTextDidInEffect];
    if (!isValid) {
        return;
    }
    [self.rgView endEditing:YES];
    self.requestParas = @{ @"mobile" : _rgView.phoneField.text,
        @"password" : [NSStrUtil ytLoginMD5WithPhoneNumber:_rgView.phoneField.text password:_rgView.psdField.text],
        @"checkCode" : _rgView.codeField.text,
        loadingKey : @(YES) };
    self.requestURL = updateMobileURL;
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    _rgView = [[RGTextCodeView alloc] init];
    _rgView.phoneField.placeholder = @"请输入手机号";
    _rgView.psdField.placeholder = @"请输入密码";
    [self.view addSubview:_rgView];
    UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    doneBtn.layer.masksToBounds = YES;
    doneBtn.layer.cornerRadius = 4;
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];

    [_rgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(15);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
    }];

    [doneBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(_rgView.bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(45);
    }];

    wSelf(wSelf);
    _rgView.validCodeBlock = ^(NSString* mobile) {
        if (!wSelf) {
            return;
        }
        __strong typeof(wSelf) sSelf = wSelf;
        sSelf.requestParas = @{ @"mobile" : mobile };
        sSelf.requestURL = sendSmsForUpdateMobileURL;
    };
}

@end
