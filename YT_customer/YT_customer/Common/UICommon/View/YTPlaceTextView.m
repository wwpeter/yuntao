
#import "YTPlaceTextView.h"

@implementation YTPlaceTextView

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
#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    if ([self.delegate respondsToSelector:@selector(placeTextView:textViewShouldBeginEditing:)]) {
        [_delegate placeTextView:self textViewShouldBeginEditing:textView];
    }

    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    if ([self.delegate respondsToSelector:@selector(placeTextView:textViewShouldEndEditing:)]) {
        [_delegate placeTextView:self textViewShouldEndEditing:textView];
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView*)textView
{
    if ([self.delegate respondsToSelector:@selector(placeTextView:textViewDidEndEditing:)]) {
        [_delegate placeTextView:self textViewDidEndEditing:textView];
    }
}
- (void)textViewDidChange:(UITextView*)textView;
{
    if (textView.text.length == 0) {
        _placeLabel.alpha = 1.0;
    }
    else {
        _placeLabel.alpha = 0.0;
    }
}
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.textView];
    [self addSubview:self.placeLabel];

    [_textView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 0, 0));
    }];
    [_placeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(13);
        make.right.mas_equalTo(self);
    }];
}
#pragma mark - Getters & Setters
- (void)setPlaceholder:(NSString*)placeholder
{
    _placeholder = placeholder;
    _placeLabel.text = placeholder;
}
- (UITextView*)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor blackColor];
        _textView.userInteractionEnabled = YES;
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
    }
    return _textView;
}
- (UILabel*)placeLabel
{
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.numberOfLines = 2;
        _placeLabel.backgroundColor = [UIColor clearColor];
        _placeLabel.font = [UIFont systemFontOfSize:14];
        _placeLabel.textColor = CCCUIColorFromHex(0xAFAFAF);
    }
    return _placeLabel;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UIColor* ccColor = [UIColor colorWithWhite:0.5f alpha:0.5f];

    UIBezierPath* bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
