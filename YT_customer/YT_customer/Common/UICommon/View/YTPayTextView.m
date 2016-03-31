#import "YTPayTextView.h"
#import "XLFormRowNavigationAccessoryView.h"

@interface YTPayTextView ()<UITextFieldDelegate>
@property (nonatomic) XLFormRowNavigationAccessoryView * navigationAccessoryView;
@end

@implementation YTPayTextView

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
#pragma mark - Event response
- (void)doneButtonDidClicked:(id)sender
{
    [self.textField resignFirstResponder];
}
- (void)textFieldDidChange:(UITextField *)textField
{
    NSRange foundPoint =[textField.text rangeOfString:@"." options:NSCaseInsensitiveSearch];
    if (foundPoint.location == NSNotFound) {
        return;
    }
    NSArray* textArray = [textField.text componentsSeparatedByString:@"."];
    NSString *pointStr = [textArray lastObject];
        if (pointStr.length > 2) {
            pointStr = [pointStr substringToIndex:2];
        }
    textField.text = [NSString stringWithFormat:@"%@.%@",[textArray firstObject],pointStr];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(ytPayTextView:textFieldShouldBeginEditing:)]) {
       return [self.delegate ytPayTextView:self textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(ytPayTextView:textFieldDidBeginEditing:)]) {
        [self.delegate ytPayTextView:self textFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    if ([self.delegate respondsToSelector:@selector(ytPayTextView:textFieldWillEndEditing:)]) {
        [self.delegate ytPayTextView:self textFieldWillEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(ytPayTextView:textFieldDidEndEditing:)]) {
        [self.delegate ytPayTextView:self textFieldDidEndEditing:textField];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(ytPayTextView:textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate ytPayTextView:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(ytPayTextView:textFieldDidClear:)]) {
        [self.delegate ytPayTextView:self textFieldDidClear:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(ytPayTextView:textFieldDidReturn:)]) {
        [self.delegate ytPayTextView:self textFieldDidReturn:textField];
    }
    return YES;
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textBackView];
    [self.textBackView addSubview:self.titleLabel];
    [self.textBackView addSubview:self.textField];
    [_textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(_textBackView);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(_textBackView);
        make.right.mas_equalTo(_textBackView).offset(-15);
        make.width.mas_equalTo(_textBackView).multipliedBy(0.5);
    }];
}
#pragma mark - Getters & Setters
- (void)setTextTitle:(NSString *)textTitle
{
    _textTitle = textTitle;
    _titleLabel.text= textTitle;
}
- (void)setTextplaceholder:(NSString *)textplaceholder
{
    _textplaceholder = textplaceholder;
    _textField.placeholder = textplaceholder;
}
- (UIView *)textBackView
{
    if (!_textBackView) {
        _textBackView = [[UIView alloc] init];
        _textBackView.backgroundColor = [UIColor whiteColor];
        _textBackView.layer.masksToBounds = YES;
        _textBackView.layer.cornerRadius = 3;
        _textBackView.layer.borderWidth = 1;
        _textBackView.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:0.5].CGColor;
    }
    return _textBackView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text= @"消费总额";
    }
    return _titleLabel;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tintColor = [UIColor redColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.inputAccessoryView =self.navigationAccessoryView;
        _textField.placeholder = @"请输入到店消费总额";
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(XLFormRowNavigationAccessoryView *)navigationAccessoryView
{
    if (_navigationAccessoryView) return _navigationAccessoryView;
    _navigationAccessoryView = [XLFormRowNavigationAccessoryView new];
    _navigationAccessoryView.doneButton.target = self;
    _navigationAccessoryView.doneButton.action = @selector(doneButtonDidClicked:);
    _navigationAccessoryView.tintColor = [UIColor redColor];
    [_navigationAccessoryView.previousButton setCustomView:[UIView new]];
    [_navigationAccessoryView.nextButton setCustomView:[UIView new]];
    return _navigationAccessoryView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
