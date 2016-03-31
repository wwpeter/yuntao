#import "OpenHongbaoViewController.h"
#import "OpenHongbaoHeadView.h"
#import "UIViewController+Helper.h"
#import "UINavigationBar+Awesome.h"
#import "UIBarButtonItem+Addition.h"
#import "MoneyHbDetailViewController.h"
#import "YTPublishListModel.h"
#import "UserMationMange.h"
#import "YTOpenPsqHbModel.h"

@interface OpenHongbaoViewController ()
@property (nonatomic, strong) OpenHongbaoHeadView* headView;

@end

@implementation OpenHongbaoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomImage:[UIImage imageNamed:@"yt_navigation_backBtn_normal02.png"] highlightImage:[UIImage imageNamed:@"yt_navigation_backBtn_high02.png"] target:self action:@selector(didLeftBarButtonItemAction:)];
    if (self.publish.hongbaoLx == YTDistributeHongbaoTypePsqhb) {
        self.navigationItem.title = @"拼手气红包";
    }else {
        self.navigationItem.title = @"普通红包";
    }
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
        NSShadowAttributeName : [NSShadow new] }];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [self.headView endAnimation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(YTRequestModel*)request result:(YTBaseModel*)parserObject
              errorMessage:(NSString*)errorMessage;
{
    [self.headView endAnimation];
    if (errorMessage) {
        [self showAlert:errorMessage title:@""];
        return;
    }
    if (parserObject.success) {
        YTOpenPsqHbModel* openPsqHbModel = (YTOpenPsqHbModel*)parserObject;
        MoneyHbDetailViewController* moneyHbDetailVC = [[MoneyHbDetailViewController alloc] init];
        moneyHbDetailVC.publish = self.publish;
        moneyHbDetailVC.amount = openPsqHbModel.openPsqHb.amount;
        moneyHbDetailVC.getNum = openPsqHbModel.openPsqHb.getNum;
        [self.navigationController pushViewController:moneyHbDetailVC animated:YES];
    }
}

#pragma mark - Private methods
- (void)openHongbao
{
    NSNumber* userId = [[UserMationMange sharedInstance] userId];
    self.requestParas = @{ @"userId" : userId,
        @"publishId" : self.publish.pId };
    self.requestURL = YC_Request_ChangeHbStatus;
}
#pragma mark - Navigation
- (void)didLeftBarButtonItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    self.view.backgroundColor = CCCUIColorFromHex(0xDE454B);
    [self.view addSubview:self.headView];

    [_headView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(350);
    }];

    [self.headView configHbDetailWithModel:self.publish];
    __weak __typeof(self) weakSelf = self;
    self.headView.actionBlock = ^(OpenHongbaoHeadView* view) {
        [weakSelf openHongbao];
    };
}
#pragma mark - Getters & Setters
- (OpenHongbaoHeadView*)headView
{
    if (!_headView) {
        _headView = [[OpenHongbaoHeadView alloc] init];
    }
    return _headView;
}

#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeAll;
}
#endif
@end
