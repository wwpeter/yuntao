#import "HbSelectListViewController.h"
#import "UIViewController+Helper.h"
#import "HbSelectTableCell.h"
#import "UIActionSheet+TTBlock.h"
#import "HbStoreStatsView.h"
#import "YTHongbaoStoreHelper.h"
#import "YTTradeModel.h"
#import "HbOrderConfirmViewController.h"
#import "YTOrderModel.h"

static NSString *CellIdentifier = @"HbStoreCellIdentifier";

@interface HbSelectListViewController ()<HbStoreStatsViewDelegate>

@property (strong, nonatomic) HbStoreStatsView *statsView;
@property (assign, nonatomic) NSInteger hbNumbers;
@property (assign, nonatomic) CGFloat statsPrice;

@end


@implementation HbSelectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializeData];
    [self initializePageSubviews];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _statsView.hidden = YES;
    [_delegate hbSelectListViewControllerDidChangeStoreHbs:self];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _statsView.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HbSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSMutableArray *hongbaoArray = [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray;
    YTUsrHongBao *useHongbao = hongbaoArray[indexPath.row];
    [cell configHbStoreTableListModel:useHongbao];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定删除吗？" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        __weak __typeof(self)weakSelf = self;
        [sheet setCompletionBlock:^(UIActionSheet *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                YTUsrHongBao *useHongbao = [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray[indexPath.row];
                [weakSelf minusWithHbStoreListModel:useHongbao];
                [[YTHongbaoStoreHelper hongbaoStoreHelper].hbArray removeObject:useHongbao];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        [sheet showInView:self.view];
    }
}

#pragma mark -HbStoreStatsViewDelegate
- (void)hbStoreStatsView:(HbStoreStatsView *)view clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    NSDictionary *orderDic = [[YTHongbaoStoreHelper hongbaoStoreHelper] setupConfimOrder];
    HbOrderConfirmViewController *orderConfirmVC = [[HbOrderConfirmViewController alloc] init];
    YTOrderModel *orderModel = [[YTOrderModel alloc] initWithJSONDict:orderDic];
    orderConfirmVC.orderArray = [[NSArray alloc] initWithArray:orderModel.orderSet.records];
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}
#pragma mark - Public methods

#pragma mark - Private methods
- (void)minusWithHbStoreListModel:(YTUsrHongBao *)hongbao
{
    NSInteger hbNumInt = hongbao.buyNum.integerValue;
    self.hbNumbers -= hbNumInt;
    CGFloat price = (hbNumInt *hongbao.price);
    self.statsPrice -= price;
    hongbao.buyNum = @0;
    [self setupShowStatsView];
}
- (void)setupShowStatsView
{
    self.statsView.badgeText = [NSString stringWithFormat:@"%@",@(self.hbNumbers)];
    self.statsView.cost = [NSString stringWithFormat:@"%.2f",self.statsPrice/100.];
}

#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
    }
}

#pragma mark - Page subviews
- (void)initializeData
{
    self.hbNumbers = 0;
    self.statsPrice = 0;
    for(YTUsrHongBao *hongbao in [YTHongbaoStoreHelper hongbaoStoreHelper].hbArray) {
        NSInteger buyNumInt = hongbao.buyNum.integerValue;
        self.hbNumbers += buyNumInt;
        self.statsPrice += (buyNumInt *hongbao.price);
    }
}
- (void)initializePageSubviews
{
    [self.tableView registerClass:[HbSelectTableCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.rowHeight = 50;
    [self setExtraCellLineHidden:self.tableView];
    [self.navigationController.view addSubview:self.statsView];
    
    
    [self setupShowStatsView];
}
#pragma mark - Getters & Setters
- (HbStoreStatsView *)statsView
{
    if (!_statsView) {
        _statsView = [[HbStoreStatsView alloc] initWithFrame:CGRectMake(0, KDeviceHeight-50, kDeviceWidth, 50)];
        _statsView.delegate = self;
    }
    return _statsView;
}

@end
