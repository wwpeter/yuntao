#import "YTEditPsdViewController.h"
#import "XLForm.h"
#import "UIImage+HBClass.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "UIAlertView+TTBlock.h"
#import "MBProgressHUD+Add.h"

NSString* const kEditPsdOld = @"oldPsd";
NSString* const kEditPsdNpsd = @"nPsd";
NSString* const kEditPsdApsd = @"aPsd";

@interface YTEditPsdViewController ()

@end

@implementation YTEditPsdViewController

#pragma mark - Life cycle
- (instancetype)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initializeForm];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeForm];
    }
    return self;
}
- (void)initializeForm
{
    UIFont* textFont = [UIFont systemFontOfSize:14];

    XLFormDescriptor* form = [XLFormDescriptor formDescriptorWithTitle:@"修改密码"];
    XLFormSectionDescriptor* section;
    XLFormRowDescriptor* row;

    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditPsdOld rowType:XLFormRowDescriptorTypePassword title:@"旧密码"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入旧密码" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditPsdNpsd rowType:XLFormRowDescriptorTypePassword title:@"新密码"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入新密码" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kEditPsdApsd rowType:XLFormRowDescriptorTypePassword title:@"确认密码"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请再次输入新密码" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];

    self.form = form;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.view.tintColor = [UIColor redColor];
    self.navigationItem.title = @"修改密码";
    self.tableView.tableFooterView = ({
        UIView* footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 65)];
        UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(15, 20, kDeviceWidth - 30, 45);
        saveBtn.layer.masksToBounds = YES;
        saveBtn.layer.cornerRadius = 4;
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [saveBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:saveBtn];
        footview;
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (parserObject.success) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"密码修改成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        wSelf(wSelf);
        [alert setCompletionBlock:^(UIAlertView* alertView, NSInteger buttonIndex) {
            __strong __typeof(wSelf) strongSelf = wSelf;
            if (buttonIndex == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }];

        [alert show];
    }
    else {
        [self showAlert:parserObject.message title:@""];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - Event response
- (void)saveButtonClicked:(id)sender
{
    if (![self checkTextDidValid]) {
        return;
    }
    [self.tableView endEditing:YES];
    NSString* oPsd = [self.formValues objectForKey:kEditPsdOld];
    NSString* nPsd = [self.formValues objectForKey:kEditPsdNpsd];
    self.requestParas = @{ @"oldPassWord" : [oPsd GetMD5],
        @"newPassWord" : [nPsd GetMD5],
        loadingKey : @(YES) };
    self.requestURL = updatePassWordURL;
}

#pragma mark - Private methods
- (BOOL)checkTextDidValid
{
    NSArray* keys = [self.formValues allKeys];
    for (NSString* key in keys) {
        NSString* str = self.formValues[key];
        if ([NSStrUtil isEmptyOrNull:str]) {
            [self showAlert:@"密码尚未填写完整哦~" title:@""];
            return NO;
        }
    }
    NSString* nPsd = [self.formValues objectForKey:kEditPsdNpsd];
    NSString* aPsd = [self.formValues objectForKey:kEditPsdApsd];

    if (![nPsd isEqualToString:aPsd]) {
        [self showAlert:@"2次新密码不一样哦~" title:@""];
        return NO;
    }
    return YES;
}
@end
