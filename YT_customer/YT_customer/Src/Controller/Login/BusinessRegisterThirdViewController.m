#import "BusinessRegisterThirdViewController.h"
#import "TopRedView.h"
#import "RGTextCodeView.h"

@interface BusinessRegisterThirdViewController ()

@property (strong, nonatomic)RGTextCodeView *rgView;

@end

@implementation BusinessRegisterThirdViewController

#pragma mark - Life cycle
- (id)init {
    if ((self = [super init])) {
        self.navigationItem.title = @"注册3/3";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"Done") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializePageSubviews];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginSuccessNotification
                                                            object:nil];
    }];
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    TopRedView *redView = [[TopRedView alloc] init];
    redView.index = 3;
    [self.view addSubview:redView];
    
    _rgView = [[RGTextCodeView alloc] init];
    [self.view addSubview:_rgView];
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    [_rgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(redView.bottom).offset(15);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
    }];
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

@end
