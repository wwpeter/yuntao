#import "AssistanterAddViewController.h"
#import "XLForm.h"
#import "UIImage+HBClass.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "UIAlertView+TTBlock.h"
#import "MBProgressHUD+Add.h"

NSString *const kAsstanterName = @"name";
NSString *const kAsstanterPhone = @"mobile";
NSString *const kAsstanterPsd = @"password";

@interface AssistanterAddViewController ()

@end

@implementation AssistanterAddViewController
#pragma mark - Life cycle
- (instancetype)initWithCoder:(NSCoder *)coder
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
    UIFont *textFont = [UIFont systemFontOfSize:14];
    
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"添加营业员"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAsstanterName rowType:XLFormRowDescriptorTypeText title:@"姓名"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
     [row.cellConfig setObject:@"请输入营业员真实姓名" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAsstanterPhone rowType:XLFormRowDescriptorTypePhone title:@"手机号"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"手机号为登录账号" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAsstanterPsd rowType:XLFormRowDescriptorTypeAccount title:@"密码"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入登录密码" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];
    
    self.form = form;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.view.tintColor = [UIColor redColor];
    self.navigationItem.title = @"添加营业员";
    self.tableView.tableFooterView = ({
        UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 65)];
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(15, 20, kDeviceWidth-30, 45);
        saveBtn.layer.masksToBounds = YES;
        saveBtn.layer.cornerRadius = 4;
        saveBtn.layer.borderWidth = 1;
        saveBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [saveBtn setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xf5f5f5)] forState:UIControlStateNormal];
        [saveBtn setTitleColor:CCCUIColorFromHex(0x333333) forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:saveBtn];
        footview;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
#pragma mark - Event response
- (void)saveButtonClicked:(id)sender
{
    [self addAssistanter];
}
#pragma mark - Private methods
- (void)addAssistanter
{
    if ([self checkTextDidValid]) {
        [MBProgressHUD showMessag:@"请稍后..." toView:self.view];
        NSString *password = [self.formValues objectForKey:kAsstanterPsd];
        NSString *name = [self.formValues objectForKey:kAsstanterName];
        NSString *mobile = [self.formValues objectForKey:kAsstanterPhone];
        self.requestParas = @{@"name" : name,
                              @"mobile" : mobile,
                              @"password":[password GetMD5]};
        self.requestURL = addShopSaleURL;
    }
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (parserObject.success) {
        wSelf(wSelf);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"添加成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            __strong __typeof(wSelf)strongSelf = wSelf;
            if (buttonIndex == 0) {
                if ([strongSelf.delegate respondsToSelector:@selector(assistanterAddSuccess:)]) {
                    [strongSelf.delegate assistanterAddSuccess:strongSelf];
                }
                [strongSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
            
        [alert show];
    }else{
        [self showAlert:parserObject.message title:@""];
    }
}
- (BOOL)checkTextDidValid
{
    NSArray *keys = [self.formValues allKeys];
    for (NSString *key in keys) {
        NSString *str = self.formValues[key];
        if ([NSStrUtil isEmptyOrNull:str]) {
            [self showAlert:@"信息尚未填写完整哦~" title:@""];
            return NO;
        }
    }
    return YES;
}
@end
