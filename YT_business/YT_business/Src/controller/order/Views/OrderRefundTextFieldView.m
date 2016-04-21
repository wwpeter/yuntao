#import "OrderRefundTextFieldView.h"
#import "XLFormRowNavigationAccessoryView.h"

@interface OrderRefundTextFieldView ()
@property (nonatomic, strong) XLFormRowNavigationAccessoryView* navigationAccessoryView;
@end

@implementation OrderRefundTextFieldView

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
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if ([_delegate respondsToSelector:@selector(orderRefundTextFieldView:textFieldShouldBeginEditing:)]) {
        [self.delegate orderRefundTextFieldView:self textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if ([_delegate respondsToSelector:@selector(orderRefundTextFieldView:textFieldDidBeginEditing:)]) {
        [self.delegate orderRefundTextFieldView:self textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([_delegate respondsToSelector:@selector(orderRefundTextFieldView:textFieldDidEndEditing:)]) {
        [self.delegate orderRefundTextFieldView:self textFieldDidEndEditing:textField];
    }
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField*)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if ([_delegate respondsToSelector:@selector(orderRefundTextFieldView:textFieldShouldReturn:)]) {
        [self.delegate orderRefundTextFieldView:self textFieldShouldReturn:textField];
    }
    return YES;
}

#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
}
#pragma mark - Setter & Getter
- (void)setPlaceholder:(NSString*)placeholder
{
    _placeholder = [placeholder copy];
    _textField.placeholder = _placeholder;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    _textField.keyboardType = keyboardType;
}
- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    _returnKeyType = returnKeyType;
    _textField.returnKeyType = returnKeyType;
}
- (UITextField*)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.delegate = self;
        _textField.inputAccessoryView = self.navigationAccessoryView;
    }
    return _textField;
}
- (XLFormRowNavigationAccessoryView*)navigationAccessoryView
{
    if (_navigationAccessoryView)
        return _navigationAccessoryView;
    _navigationAccessoryView = [XLFormRowNavigationAccessoryView new];
    _navigationAccessoryView.doneButton.target = self;
    _navigationAccessoryView.doneButton.action = @selector(doneButtonDidClicked:);
    _navigationAccessoryView.tintColor = [UIColor redColor];
    [_navigationAccessoryView.previousButton setCustomView:[UIView new]];
    [_navigationAccessoryView.nextButton setCustomView:[UIView new]];
    return _navigationAccessoryView;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
