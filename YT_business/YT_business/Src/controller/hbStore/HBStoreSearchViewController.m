#import "HBStoreSearchViewController.h"
#import "UIView+DKAddition.h"
#import "CacheDataUtil.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "UIAlertView+TTBlock.h"
#import "HBStoreSearchResultViewController.h"

static NSString* CellIdentifier = @"StoreSearchCellIdentifier";

@interface HBStoreSearchViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* dataArray;

@end

@implementation HBStoreSearchViewController

#pragma mark - Life cycle
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
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    self.dataArray = [[NSMutableArray alloc] init];
    [self initializePageSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_dataArray.count < 5) {
        [self.searchBar becomeFirstResponder];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

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
    return 45;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 45;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self sectionTextView:@"历史记录" textAlignment:NSTextAlignmentLeft];
}
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataArray.count == 0) {
        return nil;
    }
    UIView* footerView = [self sectionTextView:@"清除历史记录" textAlignment:NSTextAlignmentCenter];
    UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, footerView.dk_height - 1, footerView.dk_width, 1)];
    line.image = YTlightGrayBottomLineImage;
    [footerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cleanFooterViewTap:)]];
    [footerView addSubview:line];
    return footerView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section < self.dataArray.count) {
        cell.textLabel.text = (NSString*)_dataArray[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < self.dataArray.count) {
        NSString* text = (NSString*)_dataArray[indexPath.row];
        [self pushToSearchResultViewWithKeyWord:text];
    }
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar
{
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    if ([NSStrUtil isEmptyOrNull:searchBar.text]) {
        [self showAlert:@"无法搜索空白信息哦~" title:@""];
        return;
    }
    if([self.dataArray indexOfObject:searchBar.text] == NSNotFound) {
        [self.dataArray addObject:searchBar.text];
        [CacheDataUtil saveData:self.dataArray withFileName:iYTUserSearchStoreData];
    }
    [self pushToSearchResultViewWithKeyWord:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Event response
- (void)cleanFooterViewTap:(UITapGestureRecognizer*)tap
{
    __weak __typeof(self) weakSelf = self;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定清除历史记录吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (buttonIndex == 1) {
            [strongSelf.dataArray removeAllObjects];
            [strongSelf.tableView reloadData];
            [CacheDataUtil cleanCacheWithFileNmae:iYTUserSearchStoreData];
        }
    }];
    [alert show];
}
#pragma mark - Private methods
- (void)pushToSearchResultViewWithKeyWord:(NSString*)keyword
{
    HBStoreSearchResultViewController *searchResultVC = [[HBStoreSearchResultViewController alloc] init];
    searchResultVC.keyword = keyword;
    [self.navigationController pushViewController:searchResultVC animated:YES];
}
- (UIView*)sectionTextView:(NSString*)text textAlignment:(NSTextAlignment)textAlignment
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(textAlignment == NSTextAlignmentLeft ? 15 : 0, 0, kDeviceWidth, 45)];
    label.numberOfLines = 1;
    label.textColor = CCCUIColorFromHex(0x999999);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = textAlignment;
    label.text = text;
    [view addSubview:label];
    return view;
}
#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initializePageSubviews
{
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.tableView];
    NSArray* cacheData = [CacheDataUtil loadCacheObjectWithFileName:iYTUserSearchStoreData];
    if (cacheData) {
        _dataArray = [[NSMutableArray alloc] initWithArray:cacheData];
    }
}
#pragma mark - Getters & Setters
- (UISearchBar*)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 44)];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.backgroundImage = nil;
        _searchBar.searchBarStyle = UISearchBarStyleProminent;
        //        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        if ([_searchBar respondsToSelector:@selector(barTintColor)]) {
            [_searchBar setBarTintColor:CCColorFromRGB(248, 248, 248)];
        }
    }
    return _searchBar;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}


@end
