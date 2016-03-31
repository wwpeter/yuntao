#import "YTEditPhoneViewController.h"
#import "UIViewController+Helper.h"
#import "RGTextCodeView.h"
#import "UIImage+HBClass.h"
#import "UIAlertView+TTBlock.h"
#import "YTNetworkMange.h"
#import "MBProgressHUD+Add.h"
#import "NSStrUtil.h"

@interface YTEditPhoneViewController ()
@property (strong, nonatomic) RGTextCodeView* rgView;
@end

@implementation YTEditPhoneViewController

#pragma mark - Life cycle
- (id)init
{
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor whiteColor];
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

#pragma mark - Private methods
- (void)sendSmsForUpdateMobile:(NSString*)mobile
{
    NSDictionary* parameters = @{ @"mobile" : mobile };
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_SendSmsForUpdateMobile
        parameters:parameters
        success:^(id responseData) {

        }
        failure:^(NSString* errorMessage) {
            [self showAlert:errorMessage title:@""];
        }];
}
#pragma mark - Event response
- (void)doneButtonClicked:(id)sender
{
    BOOL isValid = [_rgView checkTextDidInEffect];
    if (!isValid) {
        return;
    }
    [self.rgView endEditing:YES];
    [MBProgressHUD showMessag:@"请稍后..." toView:self.view];
    NSDictionary* parameters = @{ @"mobile" : _rgView.phoneField.text,
        @"password" : [NSStrUtil ytLoginMD5WithPhoneNumber:_rgView.phoneField.text password:_rgView.psdField.text],
        @"checkCode" : _rgView.codeField.text };
    __weak __typeof(self) weakSelf = self;
    [[YTNetworkMange sharedMange] postResultWithServiceUrl:YC_Request_UpdateMobile
        parameters:parameters
        success:^(id responseData) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf.editSuccessBlock) {
                    strongSelf.editSuccessBlock(_rgView.phoneField.text);
                }
                if (buttonIndex == 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                        [strongSelf.navigationController popViewControllerAnimated:YES];
                    });
                }
            }];
            [alert show];

        }
        failure:^(NSString* errorMessage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showAlert:errorMessage title:@""];
        }];
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    _rgView = [[RGTextCodeView alloc] init];
    _rgView.phoneField.placeholder = @"请输入手机号";
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

    __weak __typeof(self) weakSelf = self;
    _rgView.verificationBlock = ^(NSString* mobile) {
        if (!weakSelf) {
            return;
        }
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf sendSmsForUpdateMobile:mobile];
    };
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
