#import "RGFieldView.h"
#import "NSStrUtil.h"
#import "UIView+DKAddition.h"

static const NSInteger kDefaultPadding = 10;

#define RGTextFont [UIFont systemFontOfSize:14]

@implementation RGFieldView
- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configureWithTitle:title frame:frame];
    return self;
}

-(void)configureWithTitle:(NSString *)title frame:(CGRect)frame
{
    _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 1)];
    _topLine.image = YTlightGrayTopLineImage;
    _topLine.hidden = !_displayTopLine;
    [self addSubview:_topLine];
    
    _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
    _bottomLine.image = YTlightGrayBottomLineImage;
    [self addSubview:_bottomLine];
    
    CGFloat width = [NSStrUtil stringWidthWithString:title stringFont:RGTextFont];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, width, CGRectGetHeight(frame))];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = RGTextFont;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.text = title;
    [self addSubview:_titleLabel];
    
    CGFloat FX = 2*kDefaultPadding+width;
    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(FX, 5, CGRectGetWidth(frame)-FX-kDefaultPadding, CGRectGetHeight(frame)-10)];
    _textFiled.borderStyle = UITextBorderStyleNone;
    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled.returnKeyType = UIReturnKeyDone;
    _textFiled.enablesReturnKeyAutomatically = YES;
    _textFiled.font = RGTextFont;
    _textFiled.delegate = self;
    [self addSubview:_textFiled];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(rgfiledView:textFieldDidBeginEditing:)]) {
        [self.delegate rgfiledView:self textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(rgfiledView:textFieldDidEndEditing:)]) {
        [self.delegate rgfiledView:self textFieldDidEndEditing:textField];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(rgfiledView:textFieldShouldReturn:)]) {
        [self.delegate rgfiledView:self textFieldShouldReturn:textField];
    }
    return YES;
}
#pragma mark - Setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _textFiled.placeholder = _placeholder;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    _textFiled.keyboardType = keyboardType;
}
- (void)setLeftMargin:(CGFloat)leftMargin
{
    _leftMargin = leftMargin;
    [_bottomLine setDk_x:leftMargin];
}
- (void)setDisplayTopLine:(BOOL)displayTopLine
{
    _displayTopLine = displayTopLine;
    if (displayTopLine) {
        _topLine.hidden = !displayTopLine;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
