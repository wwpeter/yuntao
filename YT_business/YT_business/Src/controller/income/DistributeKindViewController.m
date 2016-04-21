
#import "DistributeKindViewController.h"
#import "UIViewController+Helper.h"
#import "UIBarButtonItem+Addition.h"
#import "DistributeKindTableCell.h"
#import "UIAlertView+TTBlock.h"
#import "HbPaySuccessViewController.h"
#import "YTHongbaoStoreModel.h"
#import "MBProgressHUD+Add.h"
#import "YTChooseHbTempModel.h"

static NSString* CellIdentifier = @"VipManageCellIdentifier";

@interface DistributeKindViewController () <UITableViewDelegate,
    UITableViewDataSource> {
    NSMutableArray* _selectHbNames;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) NSMutableArray* selectArr;
@end

@implementation DistributeKindViewController
#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择现金/实物红包";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"确定", @"Done") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:1];
    self.selectArr = [[NSMutableArray alloc] initWithCapacity:1];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -fetchDataWithIsLoadingMore
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore
{
    int currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        currPage = 1;
    }
    else {
        ++currPage;
    }
    self.requestParas = @{ @"userId" : [YTUsr usr].usrId,
        @"pageSize" : @(20),
        @"pageNum" : @(currPage),
        isLoadingMoreKey : @(isLoadingMore) };
    self.requestURL = toChooseXjswhbListURL;
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    wSelf(wSelf);
    if (parserObject.success) {
        if ([operation.urlTag isEqualToString:toChooseXjswhbListURL]) {
            YTHongbaoStoreModel* hongbaoStoreModel = (YTHongbaoStoreModel*)parserObject;
            if (!operation.isLoadingMore) {
                _dataArray = [NSMutableArray arrayWithArray:hongbaoStoreModel.hongbaoStore.records];
            }
            else {
                [_dataArray addObjectsFromArray:hongbaoStoreModel.hongbaoStore.records];
            }
            [self.tableView reloadData];
            if (!operation.isLoadingMore) {
                [self.tableView.pullToRefreshView stopAnimating];
            }
            else {
                [self.tableView.infiniteScrollingView stopAnimating];
            }
            if (hongbaoStoreModel.hongbaoStore.totalCount > _dataArray.count) {
                self.tableView.showsInfiniteScrolling = YES;
            }
            else {
                self.tableView.showsInfiniteScrolling = NO;
            }
        }
        else if ([operation.urlTag isEqualToString:saveChooseHbTempURL] ||
                 [operation.urlTag isEqualToString:saveChoosedHbURL]) {
            NSString * againYN = [self.requestParas objectForKey:@"YN"];
            if ([againYN isEqualToString:@"N"]) {
                return;
            }
            [wSelf toDistributeSuccessViewController];
        }
        else {
        }
    }
    else {
        if ([operation.urlTag isEqualToString:saveChooseHbTempURL]) {
            YTChooseHbTempModel* tempModel = (YTChooseHbTempModel*)parserObject;
            if (tempModel.data.count > 0) {
                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
                for (NSInteger i = 0; i < tempModel.data.count; i++) {
                    NSString* hongbaoIdKey = [NSString stringWithFormat:@"hongbaoIds[%@]", @(i)];
                    mutableDict[hongbaoIdKey] = tempModel.data[i];
                }
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:parserObject.message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
                    mutableDict[@"shopId"] = [YTUsr usr].shop.shopId;
                    mutableDict[@"YN"] = buttonIndex == 1 ? @"Y" : @"N";
                    mutableDict[loadingKey] = @(YES);
                    self.requestParas = [NSDictionary dictionaryWithDictionary:mutableDict];
                    self.requestURL = saveChoosedHbURL;
                }];
                [alert show];
                return;
            }
        }
        [MBProgressHUD showError:parserObject.message toView:self.view];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    DistributeKindTableCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row < _dataArray.count) {
        YTUsrHongBao* hongbao = (YTUsrHongBao*)[_dataArray objectAtIndex:indexPath.row];
        [cell configDistributeKindCellWithModel:hongbao];
    }
    for (NSNumber* selectNum in self.selectArr) {
        if (selectNum.integerValue == indexPath.row) {
            cell.leftButton.selected = YES;
            break;
        }
        else {
            cell.leftButton.selected = NO;
        }
    }
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DistributeKindTableCell* selectCell = (DistributeKindTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (selectCell.leftButton.selected) {
        if ([self.selectArr containsObject:@(indexPath.row)]) {
             [self.selectArr removeObject:@(indexPath.row)];
        }
    }
    selectCell.leftButton.selected = !selectCell.leftButton.selected;
    if (selectCell.leftButton.selected) {
        [self.selectArr addObject:@(indexPath.row)];
    }
}

#pragma mark - Public methods
- (void)toDistributeSuccessViewController
{
    NSString* names = [_selectHbNames componentsJoinedByString:@"、"];
    HbPaySuccessViewController* successVC = [[HbPaySuccessViewController alloc] init];
    successVC.navigationTitle = @"发布成功";
    successVC.paySuccessTitle = @"发布成功";
    successVC.paySuccessDescribe = [NSString stringWithFormat:@"您的会员每人将收到%@各一个", names];
    successVC.hideButton = YES;
    [self.navigationController pushViewController:successVC animated:YES];
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    if (self.selectArr.count == 0) {
        [self showAlert:@"您还未选择红包" title:@""];
        return;
    }
    _selectHbNames = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i < self.selectArr.count; i++) {
        NSInteger selectIndex = [self.selectArr[i] integerValue];
        if (self.dataArray.count < selectIndex) {
            [self showAlert:@"选择包含失效的红包" title:@""];
            return;
        }
        YTUsrHongBao* hongbao = self.dataArray[selectIndex];
        NSString* hongbaoIdKey = [NSString stringWithFormat:@"hongbaoIds[%@]", @(i)];
        mutableDict[hongbaoIdKey] = hongbao.hongbaoId;
        [_selectHbNames addObject:[NSString stringWithFormat:@"“%@”", hongbao.name]];
    }
    mutableDict[@"shopId"] = [YTUsr usr].shop.shopId;
    mutableDict[@"hongbaoLx"] = @1;
    mutableDict[loadingKey] = @(YES);
    self.requestParas = [NSDictionary dictionaryWithDictionary:mutableDict];
    self.requestURL = saveChooseHbTempURL;
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self setExtraCellLineHidden:self.tableView];
    wSelf(wSelf);
    [self.tableView addYTPullToRefreshWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:NO];
    }];
    // loadingMore
    [self.tableView addYTInfiniteScrollingWithActionHandler:^{
        if (!wSelf) {
            return;
        }
        [wSelf fetchDataWithIsLoadingMore:YES];
    }];
    self.tableView.showsInfiniteScrolling = NO;
    [self.tableView triggerPullToRefresh];
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.rowHeight = 70;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView registerClass:[DistributeKindTableCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
@end
