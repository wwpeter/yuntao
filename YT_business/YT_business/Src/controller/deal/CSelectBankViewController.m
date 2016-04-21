#import "CSelectBankViewController.h"
#import "UIViewController+Helper.h"
#import "InputBankTextView.h"
#import "YTBankModel.h"
#import "MBProgressHUD+Add.h"
#import "CCTextField.h"
#import "NSStrUtil.h"

static NSString* CellIdentifier = @"SelectBankViewIdentifier";

@interface CSelectBankViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) InputBankTextView* bankTextView;
@property (strong, nonatomic) YTBankModel *bankModel;

@end

@implementation CSelectBankViewController

#pragma mark - Life cycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"选择银行";
    [self initializePageSubviews];
    self.requestParas = @{loadingKey : @(YES)};
    self.requestURL = bankListURL;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.bankTextView endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
        self.bankModel = (YTBankModel *)parserObject;
        [self.tableView reloadData];
    }else {
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
    return self.bankModel.banks.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.tintColor = [UIColor redColor];
    if (indexPath.row < self.bankModel.banks.count) {
        YTBank *bank = self.bankModel.banks[indexPath.row];
        cell.textLabel.text = bank.name;
        if ([bank.name isEqualToString:self.selectBankName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* selectCell = [tableView cellForRowAtIndexPath:indexPath];
    selectCell.tintColor = [UIColor redColor];
    selectCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if ([self.delegate respondsToSelector:@selector(selectBankViewController:disSelectBankName:)]) {
         YTBank *bank = self.bankModel.banks[indexPath.row];
        [_delegate selectBankViewController:self disSelectBankName:bank.name];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self.bankTextView endEditing:YES];
}
#pragma mark - Private methods
- (void)userDidInputBank
{
    if ([NSStrUtil isEmptyOrNull:self.bankTextView.textField.text]) {
        [self showAlert:@"您还未输入银行哦" title:@""];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(selectBankViewController:disSelectBankName:)]) {
        [_delegate selectBankViewController:self disSelectBankName:self.bankTextView.textField.text];
    }
      [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - KeyboardAnimation
- (void)keyboardWillShow:(NSNotification*)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber* duration = (note.userInfo)[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber* curve = (note.userInfo)[UIKeyboardAnimationCurveUserInfoKey];

    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

    CGRect containerFrame = self.bankTextView.frame;
    CGFloat moveHeight = keyboardBounds.size.height;
    containerFrame.origin.y = KDeviceHeight - (moveHeight + containerFrame.size.height) - 64;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.bankTextView.frame = containerFrame;

    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification*)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber* duration = (note.userInfo)[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber* curve = (note.userInfo)[UIKeyboardAnimationCurveUserInfoKey];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

    self.bankTextView.frame = CGRectMake(0, KDeviceHeight - 50 - 64, kDeviceWidth, 50);

    [UIView commitAnimations];
}

#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bankTextView];
    [self setExtraCellLineHidden:self.tableView];
    
    wSelf(wSelf);
    _bankTextView.actionBlock = ^(){
        __strong __typeof(wSelf)strongSelf = wSelf;
        [strongSelf userDidInputBank];
    };
}
#pragma mark - Getters & Setters
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    }
    return _tableView;
}
- (InputBankTextView*)bankTextView
{
    if (!_bankTextView) {
        _bankTextView = [[InputBankTextView alloc] initWithFrame:CGRectMake(0, KDeviceHeight - 50 - 64, kDeviceWidth, 50)];
    }
    return _bankTextView;
}
@end
