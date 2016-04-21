#import "THMerchantUnPassViewController.h"
#import "THMerchatUnPassFootView.h"
#import "UIViewController+YTUrl.h"
#import "MBProgressHUD+Add.h"
#import "UIViewController+Helper.h"

static NSString *CellIdentifier = @"THMerchantUnPassCellIdentifier";

@interface THMerchantUnPassViewController ()<THMerchatUnPassFootViewDelegate>

@property (strong, nonatomic)THMerchatUnPassFootView *footView;
@property (assign, nonatomic) NSInteger selectIndex;
@end

@implementation THMerchantUnPassViewController

#pragma mark - Life cycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"提交原因";
    [self initializeData];
    [self initializePageSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *imageName = indexPath.row == self.selectIndex ? @"yt_cell_left_select.png" : @"yt_cell_left_normal.png";
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = _dataArray[indexPath.row];

    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.footView.textView resignFirstResponder];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
    lastCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_cell_left_normal.png"]];
    
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_cell_left_select.png"]];
    _selectIndex = indexPath.row;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [self.footView.textView resignFirstResponder];
}
#pragma mark - THMerchatUnPassFootViewDelegate
- (void)merchatUnPassFootView:(THMerchatUnPassFootView *)view textViewShouldBeginEditing:(UITextView *)textView
{
    [self.tableView setContentOffset:CGPointMake(0, 125) animated:YES];
}
- (void)merchatUnPassFootViewDidSubmit:(THMerchatUnPassFootView *)view
{
    wSelf(wSelf);
    if (_selectIndex > 0 && _selectIndex < _dataArray.count) {
        NSDictionary *parameters = @{@"id":_unId,
                                     @"reason":_dataArray[_selectIndex],
                                     loadingKey : @(YES)};
        [self postRequestParas:parameters requestURL:stockHongbaoURL success:^(AFHTTPRequestOperation *operation, YTBaseModel *parserObject) {
            if (parserObject.success) {
                [wSelf.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:parserObject.message toView:self.view];
            }
            
        } failure:^(NSString *errorMessage) {
            
        }];
    } else{
        [self showAlert:@"请提交理由" title:@""];
    }
}
#pragma mark - Page subviews
- (void)initializeData
{
    self.selectIndex = -1;
}
- (void)initializePageSubviews
{
    self.tableView.rowHeight = 44;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.tableFooterView = self.footView;

}
#pragma mark - Setter & Getter
- (THMerchatUnPassFootView *)footView
{
    if (!_footView) {
        _footView = [[THMerchatUnPassFootView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
        _footView.delegate = self;
    }
    return _footView;
}

@end
