#import "CHSearchResponseView.h"
#import "CHStoreTableCell.h"
#import "SVPullToRefresh.h"
#import "UserMationMange.h"
#import "YTHttpClient.h"
#import "MBProgressHUD+Add.h"
#import "YTQueryShopModel.h"
#import "YTQueryShopHelper.h"

static NSString *CellIdentifier = @"ResponseCellIdentifier";

@interface CHSearchResponseView ()<CHStoreTableCellDelegate,UIGestureRecognizerDelegate>

@property(strong,nonatomic)NSDictionary *requestParas;
@end

@implementation CHSearchResponseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(viewHanldTap:)];
        singleTap.delegate = self;
        [self addGestureRecognizer:singleTap];
        _dataArray = [[NSMutableArray alloc] init];
        [self configureSubview:frame];
    }
    return self;
}
#pragma mark - Data
- (void)fetchDataWithIsLoadingMore:(BOOL)isLoadingMore {
    NSInteger currPage = [[self.requestParas objectForKey:@"pageNum"] intValue];
    if (!isLoadingMore) {
        currPage = 1;
    } else {
        ++ currPage;
    }
    CLLocation* currentLocation = [UserMationMange sharedInstance].userLocation;
    NSNumber* latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    NSNumber* longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    self.requestParas = @{@"pageNum":@(currPage),
                          @"lon" : longitude,
                          @"lat" : latitude,
                          @"kw" : _keyword};
    wSelf(wSelf);
    [[YTHttpClient client] requestWithURL:queryShopListURL paras:self.requestParas success:^(AFHTTPRequestOperation *operation, NSObject *parserObject) {
        YTQueryShopModel *queryShopModel = (YTQueryShopModel *)parserObject;
        if (!isLoadingMore) {
            wSelf.dataArray = [NSMutableArray arrayWithArray:queryShopModel.shopSet.records];
        } else {
            [wSelf.dataArray addObjectsFromArray:queryShopModel.shopSet.records];
        }
        [wSelf.tableView reloadData];
        if (!isLoadingMore) {
            [wSelf.tableView.pullToRefreshView stopAnimating];
        } else {
            [wSelf.tableView.infiniteScrollingView stopAnimating];
        }
        if (wSelf.dataArray.count) {
            wSelf.tableView.showsInfiniteScrolling = YES;
        } else {
            wSelf.tableView.showsInfiniteScrolling = NO;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *requestErr) {
        [MBProgressHUD showError:@"连接失败" toView:self];
    }];
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CHStoreTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    YTShop *shop = _dataArray[indexPath.row];
    shop.didSelect = NO;
    NSMutableArray *shopSelectArray = [YTQueryShopHelper queryShopHelper].shopArray;
    for (YTShop *selectShop in shopSelectArray) {
        if ([selectShop.shopId isEqualToString:shop.shopId]) {
            shop.didSelect = YES;
            break;
        }
    }
    [cell configStoreCellWithListModel:shop];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTShop *shop = _dataArray[indexPath.row];
    [_delegate searchResponseView:self didSelectStore:shop];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(searchResponseView:didScroll:)]) {
        [_delegate searchResponseView:self didScroll:scrollView];
    }
}
#pragma mark - CHStoreTableCell delegate
- (void)storeTableCell:(CHStoreTableCell *)cell didSelectStore:(YTShop *)shop
{
    [_delegate searchResponseView:self didSelectStore:shop];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[CHStoreTableCell class]]) {
        return NO;
    }
    return YES;
}
#pragma mark - Event response
- (void)viewHanldTap:(UITapGestureRecognizer*)tap
{
    [_delegate searchResponseViewDidSignTap:self];
}

#pragma mark - subviews
-(void)configureSubview:(CGRect)frame
{
    self.keyword = @"";
    [self addSubview:self.tableView];
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchDataWithIsLoadingMore:NO];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchDataWithIsLoadingMore:YES];
    }];
}
#pragma mark - Getters & Setters
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 86;
        [_tableView registerClass:[CHStoreTableCell class] forCellReuseIdentifier:CellIdentifier];
        UIView *view =[ [UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [_tableView setTableFooterView:view];
    }
    return _tableView;
}

- (void)initializeData
{
    _dataArray = [[NSMutableArray alloc] init];
}
@end
