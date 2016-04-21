
#import "PromotionHbSignBuyView.h"
#import "XLFormRowNavigationAccessoryView.h"

static const NSInteger kTopPadding = 10;

@interface PromotionHbSignBuyView ()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *lineImageView;
@property (strong, nonatomic) UIView *fieldBackView;
@property (strong, nonatomic) UIImageView *fieldbackImageView;
@property (strong, nonatomic) XLFormRowNavigationAccessoryView * navigationAccessoryView;
@end

@implementation PromotionHbSignBuyView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self configSubviews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self configSubviews];
    return self;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(promotionHbSignBuyView:textFieldShouldBeginEditing:)]) {
        [_delegate promotionHbSignBuyView:self textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(promotionHbSignBuyView:textFieldDidEndEditing:)]) {
        [_delegate promotionHbSignBuyView:self textFieldDidEndEditing:textField];
    }
}
#pragma mark - Event response
- (void)addButtonDidClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(promotionHbSignBuyViewDidAddHb:)]) {
        [_delegate promotionHbSignBuyViewDidAddHb:self];
    }
}
- (void)minusButtonDidClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(promotionHbSignBuyViewDidMinushb:)]) {
        [_delegate promotionHbSignBuyViewDidMinushb:self];
    }
}
- (void)doneButtonDidClicked:(id)sender
{
    [self.textFiled resignFirstResponder];
}
- (void)askButtonDidClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(promotionHbSignBuyViewAskAction:)]) {
        [_delegate promotionHbSignBuyViewAskAction:self];
    }
}
#pragma mark - SubViews
- (void)configSubviews
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lineImageView];
    [self addSubview:self.costLabel];
    [self addSubview:self.fieldBackView];
    [self addSubview:self.askButton];
    [self addSubview:self.sameLabel];
    [self.fieldBackView addSubview:self.fieldbackImageView];
    [self.fieldBackView addSubview:self.textFiled];
    [self.fieldBackView addSubview:self.addButton];
    [self.fieldBackView addSubview:self.minusButton];
    
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-160);
    }];
    [_fieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kTopPadding);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(98, 30));
    }];
    [_fieldbackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_fieldBackView);
    }];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(_fieldBackView);
        make.width.mas_equalTo(30);
    }];
    [_minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(_fieldBackView);
        make.width.mas_equalTo(30);
    }];
    [_textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_minusButton.right).offset(3);
        make.right.mas_equalTo(_addButton.left);
        make.top.bottom.mas_equalTo(_fieldBackView);
    }];
    [_askButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kTopPadding);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [_sameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_askButton);
        make.right.mas_equalTo(_askButton.left).offset(-5);
    }];

}
#pragma mark - Setter & Getter
- (void)setDisableField:(BOOL)disableField
{
    _disableField = disableField;
    _fieldBackView.hidden = disableField;
}
- (void)setDisplaySameOccupation:(BOOL)displaySameOccupation
{
    _displaySameOccupation = displaySameOccupation;
    _fieldBackView.hidden = displaySameOccupation;
    _askButton.hidden = _sameLabel.hidden = !displaySameOccupation;
}
- (UIView *)fieldBackView
{
    if (!_fieldBackView) {
        _fieldBackView = [[UIView alloc] init];
    }
    return _fieldBackView;
}

- (UIImageView *)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    }
    return _lineImageView;
}
- (UIImageView *)fieldbackImageView
{
    if (!_fieldbackImageView) {
        _fieldbackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb_store_textBackground.png"]];
    }
    return _fieldbackImageView;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x999999);
        _costLabel.font = [UIFont systemFontOfSize:13];
        _costLabel.numberOfLines = 1;
    }
    return _costLabel;
}
- (UITextField *)textFiled
{
    if (!_textFiled) {
        _textFiled = [[UITextField alloc] init];
        _textFiled.borderStyle = UITextBorderStyleNone;
        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
        _textFiled.returnKeyType = UIReturnKeyDone;
        _textFiled.enablesReturnKeyAutomatically = YES;
        _textFiled.font = [UIFont systemFontOfSize:13];
        _textFiled.textAlignment = NSTextAlignmentCenter;
        _textFiled.delegate = self;
        _textFiled.inputAccessoryView =self.navigationAccessoryView;
    }
    return _textFiled;
}
- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"hb_store_addButton.png"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}
- (UIButton *)minusButton
{
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setImage:[UIImage imageNamed:@"hb_store_minusButton.png"] forState:UIControlStateNormal];
        [_minusButton addTarget:self action:@selector(minusButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusButton;
}
- (UILabel *)sameLabel
{
    if (!_sameLabel) {
        _sameLabel = [[UILabel alloc] init];
        _sameLabel.textColor = CCCUIColorFromHex(0x999999);
        _sameLabel.font = [UIFont systemFontOfSize:14];
        _sameLabel.numberOfLines = 1;
        _sameLabel.textAlignment = NSTextAlignmentRight;
        _sameLabel.text = @"同行红包";
        _sameLabel.hidden = YES;
    }
    return _sameLabel;
}
- (UIButton *)askButton
{
    if (!_askButton) {
        _askButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_askButton setImage:[UIImage imageNamed:@"hb_store_askButton.png"] forState:UIControlStateNormal];
        [_askButton addTarget:self action:@selector(askButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _askButton.hidden = YES;
    }
    return _askButton;
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
