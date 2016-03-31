#import "ReceiveHbSuccessViewController.h"
#import "ReceiveSuccessHeadView.h"
#import "HbIntroTableCell.h"
#import "UIImage+HBClass.h"
#import "HbIntroModel.h"
#import "CMyHbListViewController.h"

static NSString *CellIdentifier = @"ReceiveHbSuccessCellIdentifier";

@interface ReceiveHbSuccessViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) ReceiveSuccessHeadView *receiveHeadView;
@property (strong, nonatomic) UIButton *lookButton;
@end

@implementation ReceiveHbSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成", @"Done") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = nil;
    [self initializeData];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HbIntroTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    HbIntroModel *introModel = _dataArray[indexPath.section];
    introModel.isUserHB = YES;
    [cell configHbIntroCellWithIntroModel:introModel];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Event response
- (void)lookButtonButtonClicked:(id)sender
{
    CMyHbListViewController *myHbListVC = [[CMyHbListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    myHbListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController pushViewController:myHbListVC animated:YES];

}

#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Page subviews
- (void)initializeData
{
    _dataArray = [[NSMutableArray alloc] init];
    if (_receiveArr) {
        [_dataArray addObjectsFromArray:_receiveArr];
    }
}
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.lookButton];
    self.tableView.tableHeaderView = self.receiveHeadView;
    self.receiveHeadView.titleLabel.text = @"领取成功";
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    [_lookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    __block CGFloat priceFee = 0;
    [_dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HbIntroModel *model = (HbIntroModel *)obj;
        priceFee +=  model.cost.floatValue;
    }];
    self.receiveHeadView.describeLabel.text = [NSString stringWithFormat:@"您已领取了价值%.2f元的红包,请及时到店消费",priceFee];
}

#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 70;
        [_tableView registerClass:[HbIntroTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (ReceiveSuccessHeadView *)receiveHeadView
{
    if (!_receiveHeadView) {
        _receiveHeadView = [[ReceiveSuccessHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
    }
    return _receiveHeadView;
}
- (UIButton *)lookButton
{
    if (!_lookButton) {
        _lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_lookButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_lookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_lookButton setTitle:@"查看全部红包" forState:UIControlStateNormal];
        [_lookButton addTarget:self action:@selector(lookButtonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookButton;
}
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
