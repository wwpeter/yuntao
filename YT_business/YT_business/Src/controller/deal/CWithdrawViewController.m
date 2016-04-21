#import "CWithdrawViewController.h"
#import "XLForm.h"
#import "UIImage+HBClass.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "UIAlertView+TTBlock.h"
#import "MBProgressHUD+Add.h"

NSString *const kCardName = @"userName";
NSString *const kCardNumber = @"account";
NSString *const kAmount = @"amount";

@interface CWithdrawViewController ()

@end

@implementation CWithdrawViewController

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
    
    XLFormDescriptor * form = [XLFormDescriptor formDescriptorWithTitle:@"余额提现"];
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCardName rowType:XLFormRowDescriptorTypeText title:@"持卡人"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入持卡人姓名" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kCardNumber rowType:XLFormRowDescriptorTypeInteger title:@"卡号"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入银行卡号" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:kAmount rowType:XLFormRowDescriptorTypeDecimal title:@"提现金额"];
    [row.cellConfig setObject:textFont forKey:@"textLabel.font"];
    [row.cellConfig setObject:textFont forKey:@"textField.font"];
    [row.cellConfig setObject:@"请输入提现金额" forKey:@"textField.placeholder"];
    [row.cellConfig setObject:[UIColor redColor] forKey:@"self.tintColor"];
    [section addFormRow:row];
    
    self.form = form;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    self.navigationItem.title = @"余额提现";
    self.view.tintColor = [UIColor redColor];
    self.tableView.tableFooterView = ({
        UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 65)];
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(15, 20, kDeviceWidth-30, 45);
        submitBtn.layer.masksToBounds = YES;
        submitBtn.layer.cornerRadius = 4;
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [submitBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [footview addSubview:submitBtn];
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
- (void)submitButtonClicked:(id)sender
{
    if ([self checkTextDidValid]) {
        [MBProgressHUD showMessag:@"请稍后..." toView:self.view];
        NSInteger amount = [[self.formValues objectForKey:kAmount] doubleValue]*100;
        self.requestParas = @{@"userName" : [self.formValues objectForKey:kCardName],
                              @"userName" : [self.formValues objectForKey:kCardNumber],
                              @"amount" : @(amount)};
        self.requestURL = applyCashoutURL;
    }
}
#pragma mark -override FetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (parserObject.success) {
        wSelf(wSelf);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提现成功" message:@"业务人员将在5个工作日内处理" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            __strong __typeof(wSelf)strongSelf = wSelf;
            if (buttonIndex == 0) {
//                if ([strongSelf.delegate respondsToSelector:@selector(assistanterAddSuccess:)]) {
//                    [strongSelf.delegate assistanterAddSuccess:strongSelf];
//                }
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
