#import "CYCSuccessViewController.h"
#import "YTPaySuccessView.h"

@interface CYCSuccessViewController ()<YTPaySuccessViewDelegate>

@property(strong, nonatomic)YTPaySuccessView *paySuccessView;

@end

@implementation CYCSuccessViewController

#pragma mark - Life cycle
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"done") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - YTPaySuccessViewDelegate
- (void)paySuccessView:(YTPaySuccessView *)view clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.paySuccessView];
    [_paySuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}
#pragma mark - Getters & Setters
- (void)setSuccessTitle:(NSString *)successTitle
{
    _successTitle = successTitle;
    self.paySuccessView.titleLabel.text = successTitle;
}
- (void)setSuccessDescribe:(NSString *)successDescribe
{
    _successDescribe = successDescribe;
     self.paySuccessView.describeLabel.text = successDescribe;
}
- (void)setRedButtonTitle:(NSString *)redButtonTitle
{
    _redButtonTitle = redButtonTitle;
     [self.paySuccessView.buyButton setTitle:redButtonTitle forState:UIControlStateNormal];
}
- (void)setGrayButtonTitle:(NSString *)grayButtonTitle
{
    _grayButtonTitle = grayButtonTitle;
     [self.paySuccessView.lookButton setTitle:grayButtonTitle forState:UIControlStateNormal];
}
- (void)setDisplayRedButton:(BOOL)displayRedButton
{
    _displayRedButton = displayRedButton;
    self.paySuccessView.buyButton.hidden = !displayRedButton;
}
- (void)setDisplaygrayButton:(BOOL)displaygrayButton
{
    _displaygrayButton = displaygrayButton;
    self.paySuccessView.lookButton.hidden = !displaygrayButton;
}
- (YTPaySuccessView *)paySuccessView
{
    if (!_paySuccessView) {
        _paySuccessView = [[YTPaySuccessView alloc] init];
        _paySuccessView.delegate = self;
        _paySuccessView.buyButton.hidden = YES;
        _paySuccessView.lookButton.hidden = YES;
    }
    return _paySuccessView;
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
