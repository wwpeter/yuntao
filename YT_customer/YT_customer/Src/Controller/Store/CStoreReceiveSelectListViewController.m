
#import "CStoreReceiveSelectListViewController.h"
#import "UIActionSheet+TTBlock.h"
#import "HbStoreStatsView.h"
#import "HbIntroModel.h"
#import "CStoreReceiveSelectListTableCell.h"
#import "UIViewController+Helper.h"

static NSString *CellIdentifier = @"StoreReceiveSelectListCellIdentifier";

@interface CStoreReceiveSelectListViewController ()<HbStoreStatsViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) CGFloat statsCost;
@property (strong, nonatomic) HbStoreStatsView *statsView;

@end

@implementation CStoreReceiveSelectListViewController

#pragma mark - Life cycle
- (id)initWithSelectHbModels:(NSArray *)models
{
    self = [super init];
    if (self) {
        _selectHbModels = [[NSMutableArray alloc] initWithArray:models];
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_delegate hbSelectListViewController:self didChangeStoreHbModels:self.selectHbModels];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"红包清单";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self initializeData];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectHbModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CStoreReceiveSelectListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    HbIntroModel *introModel = _selectHbModels[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%@元",introModel.hbName,introModel.price];
    cell.costLabel.text = @"x1";

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
        //        NSDictionary *items = _hbStoreModels[indexPath.row];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定删除吗？" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        __weak __typeof(self)weakSelf = self;
        [sheet setCompletionBlock:^(UIActionSheet *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                HbIntroModel *hbModel = _selectHbModels[indexPath.row];
                [weakSelf minusWithHbStoreListModel:hbModel];
                [weakSelf.selectHbModels removeObject:hbModel];
                [weakSelf setupShowStatsView];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
}

#pragma mark - Public methods

#pragma mark - Private methods
- (void)minusWithHbStoreListModel:(HbIntroModel *)introModel
{
    CGFloat costValue = [introModel.price doubleValue];
    self.statsCost -= costValue;
}
- (void)setupShowStatsView
{
    self.statsView.badgeText = [NSString stringWithFormat:@"%@",@(self.selectHbModels.count)];
    self.statsView.cost = [NSString stringWithFormat:@"%@",@(self.statsCost)];
    if (self.selectHbModels.count > 0) {
        self.statsView.doneButton.enabled = YES;
    } else {
         self.statsView.doneButton.enabled = NO;
    }
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
    self.statsCost = 0;
    for(HbIntroModel *model in _selectHbModels) {
        CGFloat costValue = [model.price doubleValue];
        self.statsCost += costValue;
    }
}
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.statsView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 50, 0));
    }];
    [_statsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self setExtraCellLineHidden:self.tableView];
    [self setupShowStatsView];
}
#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        [_tableView registerClass:[CStoreReceiveSelectListTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (HbStoreStatsView *)statsView
{
    if (!_statsView) {
        _statsView = [[HbStoreStatsView alloc] init];
        _statsView.buttonTitle = @"买单拿红包";
        _statsView.delegate = self;
    }
    return _statsView;
}


#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif
@end
