#import "KindHbDetailViewController.h"
#import "UIViewController+Helper.h"
#import "YTHorizontalHeadView.h"
#import "KindHongbaoTableCell.h"
#import "YTVipManageModel.h"
#import "PromotionHbDetailViewController.h"

static NSString *CellIdentifier = @"KindHbDetailCellIdentifier";

@interface KindHbDetailViewController () <UITableViewDataSource,
                                          UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) YTHorizontalHeadView *headView;
@end

@implementation KindHbDetailViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"现金/实物红包详情";
  [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 10;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  KindHongbaoTableCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  [cell configKindHongbaoCellWithModel:self.vipManage.hongbao];

  return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PromotionHbDetailViewController *hbDetailVC = [[PromotionHbDetailViewController alloc] initWithHbId:self.vipManage.hongbao.hongbaoId];
    [self.navigationController pushViewController:hbDetailVC animated:YES];
}
#pragma mark - Event response

#pragma mark - Page subviews
- (void)initializePageSubviews {
  [self.view addSubview:self.tableView];
  [self setExtraCellLineHidden:self.tableView];
  _tableView.tableHeaderView = ({
    NSArray<YTNumerical> *numercals = (NSArray<YTNumerical> *)[[NSArray alloc]
        initWithObjects:
            [[YTNumerical alloc] initWithCaption:[NSString stringWithFormat:@"%@",@(self.vipManage.totalNum)] message:@"发送数"],
            [[YTNumerical alloc] initWithCaption:[NSString stringWithFormat:@"%@",@(self.vipManage.readNum)] message:@"已读数"],
            [[YTNumerical alloc] initWithCaption:[NSString stringWithFormat:@"%@",@(self.vipManage.getNum)] message:@"领取数"],
            nil];
    _headView = [[YTHorizontalHeadView alloc] initWithNumercals:numercals];
    _headView.frame = CGRectMake(0, 0, kDeviceWidth, 60);
    _headView;
  });
}
#pragma mark - Getters & Setters
- (UITableView *)tableView {
  if (!_tableView) {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView registerClass:[KindHongbaoTableCell class]
        forCellReuseIdentifier:CellIdentifier];
  }
  return _tableView;
}

@end
