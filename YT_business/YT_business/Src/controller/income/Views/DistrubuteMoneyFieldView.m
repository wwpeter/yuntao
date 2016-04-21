
#import "DistrubuteMoneyFieldView.h"
#import "UIView+DKAddition.h"
#import "UITextField+YTLimit.h"

@interface DistrubuteMoneyFieldView () <UITextFieldDelegate>
@end

@implementation DistrubuteMoneyFieldView
@synthesize text = _text;

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

- (void)addTextTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.textFiled addTarget:target action:action forControlEvents:controlEvents];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(distrubuteMoneyFieldView:textFieldShouldBeginEditing:)]) {
        return [self.delegate distrubuteMoneyFieldView:self textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(distrubuteMoneyFieldView:textFieldDidBeginEditing:)]) {
        [self.delegate distrubuteMoneyFieldView:self textFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField;
{
    if ([self.delegate respondsToSelector:@selector(distrubuteMoneyFieldView:textFieldWillEndEditing:)]) {
        [self.delegate distrubuteMoneyFieldView:self textFieldWillEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(distrubuteMoneyFieldView:textFieldDidEndEditing:)]) {
        [self.delegate distrubuteMoneyFieldView:self textFieldDidEndEditing:textField];
    }
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if ([self.delegate respondsToSelector:@selector(distrubuteMoneyFieldView:textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate distrubuteMoneyFieldView:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    if (textField.keyboardType == UIKeyboardTypeDecimalPad || textField.keyboardType == UIKeyboardTypeNumbersAndPunctuation) {
        return [textField validateNumberReplacementString:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(distrubuteMoneyFieldView:textFieldDidClear:)]) {
        [self.delegate distrubuteMoneyFieldView:self textFieldDidClear:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(distrubuteMoneyFieldView:textFieldDidReturn:)]) {
        [self.delegate distrubuteMoneyFieldView:self textFieldDidReturn:textField];
    }
    return YES;
}

#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.textFiled];
}
#pragma mark - Getters & Setters
- (void)setTitle:(NSString*)title
{
    _title = [title copy];
    _titleLabel.text = title;
}
- (void)setTitleAttributedString:(NSAttributedString*)titleAttributedString
{
    _titleAttributedString = [titleAttributedString copy];
    _titleLabel.attributedText = titleAttributedString;
}
- (void)setRightText:(NSString *)rightText
{
    _rightText = [rightText copy];
    _rightLabel.text = rightText;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    _textFiled.keyboardType = keyboardType;
    if (keyboardType == UIKeyboardTypeDecimalPad || keyboardType == UIKeyboardTypeNumbersAndPunctuation) {
        [_textFiled addTextValueChange];
    }
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    _textFiled.placeholder = placeholder;
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    _textFiled.textAlignment = textAlignment;
}
- (void)setHideTitle:(BOOL)hideTitle
{
    _hideTitle = hideTitle;
    _titleLabel.hidden = _rightLabel.hidden = YES;
    _textFiled.dk_x = 15;
    _textFiled.dk_width = CGRectGetWidth(self.bounds) - 30;
}
- (void)setText:(NSString *)text
{
    _text = [text copy];
    _textFiled.text = text;
}
- (NSString *)text
{
    return _textFiled.text;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, CGRectGetHeight(self.bounds))];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel*)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - 44, 0, 44, CGRectGetHeight(self.bounds))];
        _rightLabel.numberOfLines = 1;
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _rightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rightLabel;
}
- (UITextField*)textFiled
{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(_titleLabel.dk_right + 10, 0, CGRectGetWidth(self.bounds) - 44 - _titleLabel.dk_right, CGRectGetHeight(self.bounds))];
        _textFiled.borderStyle = UITextBorderStyleNone;
        _textFiled.returnKeyType = UIReturnKeyDone;
        _textFiled.textAlignment = NSTextAlignmentRight;
        _textFiled.enablesReturnKeyAutomatically = YES;
        _textFiled.font = [UIFont systemFontOfSize:15];
        _textFiled.delegate = self;
    }
    return _textFiled;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
