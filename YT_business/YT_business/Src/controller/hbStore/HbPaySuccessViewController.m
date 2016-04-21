
#import "HbPaySuccessViewController.h"
#import "YTPaySuccessView.h"
#import "YTNavigationController.h"
#import "RESideMenu.h"
#import "UIViewController+Helper.h"

@interface HbPaySuccessViewController () <YTPaySuccessViewDelegate>

@property (strong, nonatomic) YTPaySuccessView* paySuccessView;

@end

@implementation HbPaySuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - YTPaySuccessViewDelegate
- (void)paySuccessView:(YTPaySuccessView*)view clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.paySuccessView];
    [_paySuccessView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(70);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    if (self.viewMode == PaySuccessViewModeRefundPay) {
        self.paySuccessView.titleLabel.text = @"退款申请已提交";
        self.paySuccessView.describeLabel.text = @"我们将在最晚24个小时内退款到原支付方账户，如有疑问，可点击右上角拨打客服电话";
        self.paySuccessView.lookButton.hidden = YES;
        [self.paySuccessView.buyButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.navigationItem.rightBarButtonItem setTitle:@"联系客服"];
    }
}
#pragma mark - Getters & Setters
- (void)setHideButton:(BOOL)hideButton
{
    _hideButton = hideButton;
    self.paySuccessView.buyButton.hidden = self.paySuccessView.lookButton.hidden = hideButton;
}
- (void)setNavigationTitle:(NSString *)navigationTitle
{
    _navigationTitle = [navigationTitle copy];
    self.navigationItem.title = navigationTitle;
}
- (void)setPaySuccessTitle:(NSString*)paySuccessTitle
{
    _paySuccessTitle = [paySuccessTitle copy];
    self.paySuccessView.titleLabel.text = paySuccessTitle;
}
- (void)setPaySuccessDescribe:(NSString*)paySuccessDescribe
{
    _paySuccessDescribe = [paySuccessDescribe copy];
    self.paySuccessView.describeLabel.text = paySuccessDescribe;
}
- (YTPaySuccessView*)paySuccessView
{
    if (!_paySuccessView) {
        _paySuccessView = [[YTPaySuccessView alloc] init];
        _paySuccessView.delegate = self;
    }
    return _paySuccessView;
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    if (self.viewMode == PaySuccessViewModeRefundPay) {
        [self callPhoneNumber:YT_Service_Number];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
