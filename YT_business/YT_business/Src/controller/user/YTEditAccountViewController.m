#import "YTEditAccountViewController.h"
#import "UIImage+HBClass.h"
#import "NSStrUtil.h"
#import "UIViewController+Helper.h"

@interface YTEditAccountViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView *whiteBackView;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIButton *doneButton;

@property (nonatomic, copy) void (^completionBlock) (NSString *);

@end

@implementation YTEditAccountViewController

#pragma mark - Life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"修改";
        self.view.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self initializePageSubviews];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Public methods
- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString))completionBlock
{
    self.completionBlock = completionBlock;
}
#pragma mark - Event response
- (void)doneButtonDidClicked:(id)sender
{
    if ([NSStrUtil isEmptyOrNull:_textField.text]) {
        [self showAlert:@"您还未输入任何内容~" title:@""];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (_completionBlock) {
        _completionBlock(_textField.text);
    }
}
#pragma mark - Page subviews
- (void)initializePageSubviews
{
    [self.view addSubview:self.whiteBackView];
    UIImageView *topLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [self.whiteBackView addSubview:topLine];
    UIImageView *bottomLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    [self.whiteBackView addSubview:bottomLine];
    [self.whiteBackView addSubview:self.textField];
    [self.view addSubview:self.doneButton];
    [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(15);
        make.height.mas_equalTo(50);
    }];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(_whiteBackView);
        make.height.mas_equalTo(1);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(_whiteBackView);
        make.height.mas_equalTo(1);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.right.mas_equalTo(_whiteBackView);
    }];
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_whiteBackView.bottom).offset(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(45);
    }];
}
#pragma mark - Getters & Setters
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _textField.placeholder = placeholder;
}
- (void)setFieldText:(NSString *)fieldText
{
    _fieldText = fieldText;
    _textField.text = fieldText;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    _textField.keyboardType = keyboardType;
}
- (UIView *)whiteBackView
{
    if (!_whiteBackView) {
        _whiteBackView = [[UIView alloc] init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBackView;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.delegate = self;
    }
    return _textField;
}
- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.layer.masksToBounds = YES;
        _doneButton.layer.cornerRadius = 3;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_doneButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_doneButton setTitle:@"确定" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}
@end
