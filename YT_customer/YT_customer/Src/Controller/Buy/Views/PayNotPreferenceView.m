#import "PayNotPreferenceView.h"
#import "YTPayTextView.h"

@implementation PayNotPreferenceView
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
#pragma mark - YTPayTextViewDelegate
- (BOOL)ytPayTextView:(YTPayTextView*)view textFieldShouldBeginEditing:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(payNotPreferenceView:textFieldShouldBeginEditing:)]) {
        return [self.delegate payNotPreferenceView:self textFieldShouldBeginEditing:textField];
    }

    return YES;
}
- (BOOL)ytPayTextView:(YTPayTextView *)view textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.delegate respondsToSelector:@selector(payNotPreferenceView:textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate payNotPreferenceView:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (void)ytPayTextView:(YTPayTextView*)view textFieldDidBeginEditing:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(payNotPreferenceView:textFieldDidBeginEditing:)]) {
        [self.delegate payNotPreferenceView:self textFieldDidBeginEditing:textField];
    }
}
- (void)ytPayTextView:(YTPayTextView*)view textFieldWillEndEditing:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(payNotPreferenceView:textFieldWillEndEditing:)]) {
        [self.delegate payNotPreferenceView:self textFieldWillEndEditing:textField];
    }
}
- (void)ytPayTextView:(YTPayTextView*)view textFieldDidEndEditing:(UITextField*)textField
{
    if ([self.delegate respondsToSelector:@selector(payNotPreferenceView:textFieldDidEndEditing:)]) {
        [self.delegate payNotPreferenceView:self textFieldDidEndEditing:textField];
    }
}
#pragma mark - Event response
- (void)preButtonClicked:(id)sender
{
    _preButton.selected = !_preButton.selected;
    if (self.selectBlock) {
        self.selectBlock(_preButton.selected);
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.preButton];
    [self addSubview:self.textLabel];
    [self addSubview:self.payTextView];
    [_preButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(1);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_preButton.right).offset(8);
        make.centerY.mas_equalTo(_preButton);
        make.right.mas_equalTo(self);
    }];
    [_payTextView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(33);
        make.height.mas_equalTo(48);
    }];
}

#pragma mark - Getters & Setters
- (UIButton*)preButton
{
    if (!_preButton) {
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setImage:[UIImage imageNamed:@"yt_preferenceBtn_normal.png"] forState:UIControlStateNormal];
        [_preButton setImage:[UIImage imageNamed:@"yt_preferenceBtn_select.png"] forState:UIControlStateSelected];
        [_preButton addTarget:self action:@selector(preButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preButton;
}
- (UILabel*)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 1;
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = CCCUIColorFromHex(0x666666);
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.text = @"输入不参与优惠金额(如酒水、套餐)";
    }
    return _textLabel;
}
- (YTPayTextView*)payTextView
{
    if (!_payTextView) {
        _payTextView = [[YTPayTextView alloc] init];
        _payTextView.delegate = self;
        _payTextView.textTitle = @"不参与优惠金额";
        _payTextView.textplaceholder = @"询问服务员后输入";
    }
    return _payTextView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
