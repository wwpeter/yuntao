#import "AssistanterMangeViewController.h"
#import "UIViewController+Helper.h"
#import "UIActionSheet+TTBlock.h"
#import "UIImage+HBClass.h"
#import "AssistanterAddViewController.h"
#import "AsstanterEditViewController.h"
#import "YTAssistanterModel.h"
#import "MBProgressHUD+Add.h"

static NSString* CellIdentifier = @"AssistanterMangeViewCellIdentifier";

@interface AssistanterMangeViewController () <UITableViewDataSource, UITableViewDelegate,AssistanterAddViewControllerDelegate,AsstanterEditViewControllerDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;
@property (strong, nonatomic) NSIndexPath* delIndexPath;
@end

@implementation AssistanterMangeViewController
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"营业员管理";

    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    _dataArray = [[NSMutableArray alloc] init];
    [self initializePageSubviews];

    wSelf(wSelf);
    [_tableView addPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchData];
    }];
    _tableView.showsInfiniteScrolling = NO;
    [self fetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchData
{
    self.requestParas = @{};
    self.requestURL = shopSaleListURL;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:shopSaleListURL]) {
            YTAssistanterModel* assistanterModel = (YTAssistanterModel*)parserObject;
            _dataArray = [NSMutableArray arrayWithArray:assistanterModel.assistanters];
            [_tableView reloadData];
        }
        else if ([operation.urlTag isEqualToString:delSaleByIdURL]) {
        }
    }
    else {
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
    if ([operation.urlTag isEqualToString:shopSaleListURL]) {
        [_tableView.pullToRefreshView stopAnimating];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row < _dataArray.count) {
        YTAssistanter* assistanter = _dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", assistanter.userName, assistanter.mobile];
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < _dataArray.count) {
         YTAssistanter* assistanter = _dataArray[indexPath.row];
        AsstanterEditViewController* asstanterVC = [[AsstanterEditViewController alloc] init];
        asstanterVC.delegate = self;
        asstanterVC.assistanter = assistanter;
        [self.navigationController pushViewController:asstanterVC animated:YES];
    }
}
- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @"删除";
}
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"确定删除吗？" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        __weak __typeof(self) weakSelf = self;
        [sheet setCompletionBlock:^(UIActionSheet* alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [weakSelf deleteShopAssistanter:indexPath.row];
                weakSelf.delIndexPath = indexPath;
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        [sheet showInView:self.view];
    }
}
#pragma mark - AssistanterAddViewControllerDelegate
- (void)assistanterAddSuccess:(AssistanterAddViewController *)viewController
{
    [self fetchData];
}
#pragma mark - AsstanterEditViewControllerDelegate
- (void)assistanterEditSuccess:(AsstanterEditViewController *)viewController
{
    [self fetchData];
}
#pragma mark - Private methods
- (void)deleteShopAssistanter:(NSInteger)index
{
    YTAssistanter* assistanter = _dataArray[index];
    self.requestParas = @{ @"saleUserId" : assistanter.assistanterId,
        loadingKey : @(YES) };
    self.requestURL = delSaleByIdURL;
}
#pragma mark - Event response
- (void)addButtonClicked:(id)sender
{
    AssistanterAddViewController* assistanterAddVC = [[AssistanterAddViewController alloc] init];
    assistanterAddVC.delegate = self;
    [self.navigationController pushViewController:assistanterAddVC animated:YES];
}
#pragma mark - Navigation
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    self.tableView.tableFooterView = ({
        UIView* footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 65)];
        UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(15, 20, kDeviceWidth - 30, 45);
        addBtn.layer.masksToBounds = YES;
        addBtn.layer.cornerRadius = 4;
        addBtn.layer.borderWidth = 1;
        addBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [addBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xf5f5f5)] forState:UIControlStateNormal];
        [addBtn setTitleColor:CCCUIColorFromHex(0x333333) forState:UIControlStateNormal];
        [addBtn setTitle:@"添加营业员" forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:addBtn];
        footview;
    });
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
@end
