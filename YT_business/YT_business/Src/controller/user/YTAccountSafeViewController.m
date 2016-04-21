#import "YTAccountSafeViewController.h"
#import "YTDetailActionView.h"
#import "YTEditPhoneViewController.h"
#import "YTEditPsdViewController.h"

@interface YTAccountSafeViewController ()

@end

@implementation YTAccountSafeViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"账户安全";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
      [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _phoneView.detailLabel.text = [YTUsr usr].mobile;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.passwordView];
    [_phoneView makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view.top).offset(15);
        make.left.right.equalTo(self.view);
        make.height.offset(50);
    }];
    
    [_passwordView makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(self.view);
        make.height.offset(50);
        make.top.equalTo(_phoneView.bottom);
    }];
    __weak __typeof(self) weakSelf = self;
    _phoneView.actionBlock = ^(void) {
        YTEditPhoneViewController *editPhoneVC = [[YTEditPhoneViewController alloc] init];
        [weakSelf.navigationController pushViewController:editPhoneVC animated:YES];
    };
    _passwordView.actionBlock = ^(void) {
        YTEditPsdViewController *editPsdVC = [[YTEditPsdViewController alloc] init];
        [weakSelf.navigationController pushViewController:editPsdVC animated:YES];
    };
}

#pragma mark -Getters && Setters
- (YTDetailActionView*)phoneView
{
    if (!_phoneView) {
        _phoneView = [[YTDetailActionView alloc] init];
        _phoneView.titleLabel.text = @"手机号";
        _phoneView.bottomLeftMargin = 15;
    }
    return _phoneView;
}

- (YTDetailActionView*)passwordView
{
    if (!_passwordView) {
        _passwordView = [[YTDetailActionView alloc] init];
        _passwordView.titleLabel.text = @"密码";
        _passwordView.detailLabel.text = @"修改";
        [_passwordView displayTopLine:NO bottomLine:YES];
    }
    return _passwordView;
}


@end
