
#import "DistributeNoticeViewController.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "MBProgressHUD+Add.h"
#import "HbPaySuccessViewController.h"

@interface DistributeNoticeViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UILabel *textBackLabel;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation DistributeNoticeViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布通知";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"发布", @"send") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboard:)]];
    [self initializePageSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -override fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation*)operation result:(YTBaseModel*)parserObject
                     error:(NSError*)requestErr
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if (parserObject.success) {
        HbPaySuccessViewController* successVC = [[HbPaySuccessViewController alloc] init];
        successVC.navigationTitle = @"发布成功";
        successVC.paySuccessTitle = @"发布成功";
        successVC.paySuccessDescribe = @"您的消息已成功推送给您的全部会员";
        successVC.hideButton = YES;
        [self.navigationController pushViewController:successVC animated:YES];
    }
    else {
        NSString *errorMsg = requestErr ? @"服务连接失败" : parserObject.message;
        [MBProgressHUD showError:errorMsg toView:self.view];
    }
}
#pragma mark - Event response
- (void)tapHideKeyboard:(UITapGestureRecognizer*)tap
{
    [_textView resignFirstResponder];
}
#pragma mark - Private methods

#pragma mark - Navigation
- (void)didRightBarButtonItemAction:(id)sender
{
    if ([NSStrUtil isEmptyOrNull:_textView.text]) {
        [self showAlert:@"请输入通知内容" title:@""];
        return;
    }
    self.requestParas = @{ @"shopId" : [YTUsr usr].shop.shopId,
                           @"content" : _textView.text,
                           loadingKey : @(YES)};
    self.requestURL = saveNoticeURL;
    
    [self.view endEditing:YES];
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    UIView *topView = UIView.new;
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *topLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [topView addSubview:topLine];
    UIImageView *topLine2 = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [topView addSubview:topLine2];
    [topView addSubview:self.textView];
    [topView addSubview:self.textBackLabel];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(100);
    }];
    // 线条
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.mas_equalTo(topView);
        make.height.mas_equalTo(1);
    }];
    [topLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.right.mas_equalTo(topView);
        make.height.mas_equalTo(1);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(topView).with.insets(UIEdgeInsetsMake(5, 5, 2, 0));
    }];
    
    [_textBackLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(topView).offset(8);
        make.top.mas_equalTo(topView).offset(13);
        make.right.mas_equalTo(-10);             // need
    }];
    
    _textBackLabel.text = @"在这里请输入一些您想对会员们说的话呦~";
    
}
#pragma mark - textview delegate
- (void)textViewDidChange:(UITextView *)textView;
{
    if (textView.text.length == 0) {
        _textBackLabel.alpha = 1.0;
    }else{
        _textBackLabel.alpha = 0.0;
    }
}

#pragma mark - Getters & Setters
- (UILabel *)textBackLabel
{
    if (!_textBackLabel) {
        _textBackLabel = [[UILabel alloc] init];
        _textBackLabel.numberOfLines = 1;
        _textBackLabel.backgroundColor = [UIColor clearColor];
        _textBackLabel.font = [UIFont systemFontOfSize:13];
        _textBackLabel.textColor = CCCUIColorFromHex(0xAFAFAF);
    }
    return _textBackLabel;
}
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.keyboardType = UIKeyboardTypeDefault;
    }
    return _textView;
}
@end
