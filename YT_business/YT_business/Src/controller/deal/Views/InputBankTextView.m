
#import "InputBankTextView.h"
#import "UIImage+HBClass.h"
#import "CCTextField.h"

@interface InputBankTextView ()<UITextFieldDelegate>
@end
@implementation InputBankTextView


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
- (void)doneButonClickde:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = CCCUIColorFromHex(0xf8f8f8);
    [self addSubview:self.doneButton];
    [self addSubview:self.textField];

    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.bottom.mas_equalTo(_doneButton);
        make.right.mas_equalTo(_doneButton.left).offset(-10);
    }];
}

#pragma mark - Getters & Setters
- (CCTextField *)textField
{
    if (!_textField) {
        _textField = [[CCTextField alloc] init];
        _textField.layer.masksToBounds = YES;
        _textField.layer.cornerRadius = 4;
        _textField.layer.borderWidth = 0.5f;
        _textField.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.tintColor = [UIColor redColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.enablesReturnKeyAutomatically = YES;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.delegate = self;
        _textField.placeholder = @"其他银行请输入";
    }
    return _textField;
}
- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.layer.masksToBounds = YES;
        _doneButton.layer.cornerRadius = 4;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_doneButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton setTitle:@"确认" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButonClickde:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
}
@end
