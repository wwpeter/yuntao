#import "YTFeedbackViewController.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"
#import "DeviceUtil.h"
#import "ApplyUntil.h"
#import "MBProgressHUD+Add.h"
#import "UIAlertView+TTBlock.h"

@interface YTFeedbackViewController ()<UITextViewDelegate>
@property (strong, nonatomic) UILabel *textBackLabel;
@property (strong, nonatomic) UITextView *textView;
@end

@implementation YTFeedbackViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"问题反馈";
    self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"发送", @"send") style:UIBarButtonItemStylePlain target:self action:@selector(didRightBarButtonItemAction:)];
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
#pragma mark -fetchData
- (void)actionFetchRequest:(AFHTTPRequestOperation *)operation result:(YTBaseModel *)parserObject
                     error:(NSError *)requestErr {
    if (parserObject.success) {
//        wSelf(wSelf);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"意见发送成功" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alert setCompletionBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                    [[self navigationController] popViewControllerAnimated:YES];
                });
            }
        }];
        [alert show];
        
    }else{
        [MBProgressHUD showError:parserObject.message toView:self.view];
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
        [self showAlert:@"请输入您的宝贵意见吧~" title:@""];
        return;
    }
    [self.view endEditing:YES];
    NSString *client = [NSString stringWithFormat:@"shop-%@",[ApplyUntil version]];
    NSString *clientProperties = [NSString stringWithFormat:@"%@,%@%@",[DeviceUtil deviceVersion],[DeviceUtil deviceSystemName],[DeviceUtil deviceSystemVersion]];
    self.requestParas = @{@"client" : client,
                          @"clientProperties" : clientProperties,
                          @"content" : _textView.text};
    self.requestURL = suggestURL;
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
    
    _textBackLabel.text = @"请输入你的意见/建议";

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
