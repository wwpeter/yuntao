
#import "PayOrderViewController.h"
#import "HbIntroTableCell.h"
#import "HbIntroModel.h"
#import "CMyHbDetailViewController.h"
#import "StoryBoardUtilities.h"
#import "MBProgressHUD+Add.h"
#import "PayOrderHeadView.h"
#import "PayOrderSectionHeadView.h"

static NSString* CellIdentifier = @"PayOrderViewCellIdentifier";

@interface PayOrderViewController ()<UITableViewDelegate,
UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;

@end


@implementation PayOrderViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    [self initializePageSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page subviews

- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = ({
        PayOrderHeadView* headView = [[PayOrderHeadView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 230)];
        [headView configPayOrderHeadViewWithIntroModel:Nil];
        headView;
    });
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    
    return 0;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return nil;
    }
    PayOrderSectionHeadView* headView = [[PayOrderSectionHeadView alloc] init];
    headView.titleLeftOffset = 10;
    headView.titleLabel.textColor = CCCUIColorFromHex(0x999999);
    headView.titleLabel.text = @"领取红包";
    headView.hideBottomLine = YES;
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    HbIntroTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    HbIntroModel *introModel = _dataArray[indexPath.section];
    [cell configHbIntroCellWithIntroModel:introModel];
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];

    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
            _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HbIntroTableCell class] forCellReuseIdentifier:CellIdentifier];

    }
    return _tableView;
}
@end
