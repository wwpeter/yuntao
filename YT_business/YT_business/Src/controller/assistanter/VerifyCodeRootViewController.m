#import "VerifyCodeRootViewController.h"
#import "UIAlertView+TTBlock.h"
#import "UIViewController+Helper.h"
#import "VerifyCodeViewController.h"
#import "UIBarButtonItem+Addition.h"
#import "RESideMenu.h"
#import "YTHttpClient.h"
#import "HbPaySuccessViewController.h"
#import "StoryBoardUtilities.h"
#import "MBProgressHUD+Add.h"

@interface VerifyCodeRootViewController ()<VerifyCodeViewControllerDelegate>
@property (strong, nonatomic)UIImageView *logoImageView;
@property (strong, nonatomic)UIButton *scanButton;
@end

@implementation VerifyCodeRootViewController

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
    self.navigationItem.title = @"验证";
    if ([YTUsr usr].type == LoginViewTypeAsstanter) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithYunTaoSideLefttarget:self action:@selector(presentLeftMenuViewController:)];
    }
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr
{
    if (parserObject.success) {
        HbPaySuccessViewController *paySuccessVC = [StoryBoardUtilities viewControllerForMainStoryboard:[HbPaySuccessViewController class]];
        paySuccessVC.hideButton = YES;
        paySuccessVC.paySuccessTitle = @"验证成功";
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }else{
        [self showAlert:parserObject.message title:@""];
    }
}
#pragma mark - VerifyCodeViewControllerDelegate
- (void)verifyCodeViewController:(VerifyCodeViewController *)controller didverifyResult:(NSString *)result
{
    self.requestParas = @{loadingKey:@(YES)};
    self.requestURL = result;
}
#pragma mark - Event response
- (void)scanButtonClicked:(id)sender
{
    VerifyCodeViewController *veriyCodeVC = [[VerifyCodeViewController alloc] init];
    veriyCodeVC.delegate = self;
    [self.navigationController pushViewController:veriyCodeVC animated:YES];
}
#pragma mark - Navigation

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.view.backgroundColor = CCCUIColorFromHex(0xeef8ff);
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.scanButton];
    
    CGFloat multiple = 15 * iPhoneMultiple;
    CGFloat topPadding = iPhone4 ? 30 : 40;
    NSString* logoImageName = iPhone4 ? @"yt_hb_logo_p4.png" : @"yt_hb_logo.png";
    UIImage* logoImage = [UIImage imageNamed:logoImageName];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(topPadding);
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(logoImage.size.width, logoImage.size.height));
    }];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(_logoImageView.bottom).offset(50);
        make.left.mas_equalTo(multiple);
        make.right.mas_equalTo(-multiple);
        make.height.mas_equalTo(49);
    }];
    _logoImageView.image = logoImage;
}

#pragma mark - Getters & Setters
- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
    }
    return _logoImageView;
}
- (UIButton *)scanButton
{
    if (!_scanButton) {
        UIImage* normalImage = [[UIImage imageNamed:@"yt_buy_redButton_normal.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        UIImage* highImage = [[UIImage imageNamed:@"yt_buy_redButton_high.png"] stretchableImageWithLeftCapWidth:50 topCapHeight:10];
        _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _scanButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _scanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_scanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_scanButton setTitle:@"扫一扫验证" forState:UIControlStateNormal];
        [_scanButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [_scanButton setBackgroundImage:highImage forState:UIControlStateHighlighted];
        [_scanButton setImage:[UIImage imageNamed:@"yt_scan_button_icon.png"] forState:UIControlStateNormal];
        [_scanButton setImage:[UIImage imageNamed:@"yt_scan_button_icon.png"] forState:UIControlStateHighlighted];
        [_scanButton addTarget:self action:@selector(scanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanButton;
}


@end
