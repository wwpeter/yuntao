#import "THMerchatUnPassFootView.h"
#import "UIImage+HBClass.h"
#import "UITextView+PlaceHolder.h"

@interface THMerchatUnPassFootView () <UITextViewDelegate>
@property (strong, nonatomic) UIView* textBackView;
@property (strong, nonatomic) UIImageView* horizontalLine;
@property (strong, nonatomic) UIImageView* bhorizontalLine;
@end
@implementation THMerchatUnPassFootView
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
    if ([self.delegate respondsToSelector:@selector(merchatUnPassFootView:textViewShouldBeginEditing:)])
        [self.delegate merchatUnPassFootView:self textViewShouldBeginEditing:textView];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    if ([self.delegate respondsToSelector:@selector(merchatUnPassFootView:textViewShouldEndEditing:)])
        [self.delegate merchatUnPassFootView:self textViewShouldEndEditing:textView];
    return YES;
}
#pragma mark - Event response
- (void)submitButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(merchatUnPassFootViewDidSubmit:)])
        [self.delegate merchatUnPassFootViewDidSubmit:self];
}
#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.textBackView];
    [self.textBackView addSubview:self.horizontalLine];
    [self.textBackView addSubview:self.bhorizontalLine];
    [self.textBackView addSubview:self.textView];
    [self addSubview:self.submitButton];
    [_textBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(80);
    }];
    [_horizontalLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(_textBackView);
        make.height.mas_equalTo(1);
    }];
    [_bhorizontalLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.mas_equalTo(_textBackView);
        make.height.mas_equalTo(1);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(2, 10, 0, 0));
    }];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(_textBackView.bottom).offset(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
    }];
    [self.textView addPlaceHolder:@"请输入原因(可不填)"];
}

#pragma mark - Setter & Getter
- (UIView*)textBackView
{
    if (!_textBackView) {
        _textBackView = [[UIView alloc] init];
        _textBackView.backgroundColor = [UIColor whiteColor];
    }
    return _textBackView;
}
- (UITextView*)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
    }
    return _textView;
}
- (UIButton*)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 4;
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfa5e66)] forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (UIImageView*)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    }
    return _horizontalLine;
}
- (UIImageView*)bhorizontalLine
{
    if (!_bhorizontalLine) {
        _bhorizontalLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    }
    return _bhorizontalLine;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
