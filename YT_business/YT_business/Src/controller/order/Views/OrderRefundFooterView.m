#import "OrderRefundFooterView.h"
#import "UIImage+HBClass.h"

@implementation OrderRefundFooterView

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
- (void)refundButtonClicked:(id)sender
{
    if (self.refundBlock) {
        self.refundBlock();
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.refundMesLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.hongbaoNumLabel];
    [self addSubview:self.refundBtn];
    
    [_refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(126);
    }];
    
    [_refundMesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(66);
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_refundMesLabel.right);
        make.top.mas_equalTo(_refundMesLabel);
        make.right.mas_equalTo(_refundBtn.left).priorityLow();
    }];
    [_hongbaoNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_refundMesLabel);
        make.top.mas_equalTo(_refundMesLabel.bottom).offset(4);
        make.right.mas_equalTo(_amountLabel).priorityLow();
    }];
}
#pragma mark - Setter & Getter
- (void)setAmount:(CGFloat)amount
{
    _amount = amount;
    _amountLabel.text = [NSString stringWithFormat:@"¥%.2f",amount];
}
- (void)setHongbaoNum:(NSInteger)hongbaoNum
{
    _hongbaoNum = hongbaoNum;
    _hongbaoNumLabel.text = [NSString stringWithFormat:@"退回红包%@个",@(hongbaoNum)];
}
- (void)setRefundEnabled:(BOOL)refundEnabled
{
    _refundEnabled = refundEnabled;
}
- (UILabel*)refundMesLabel
{
    if (!_refundMesLabel) {
        _refundMesLabel = [[UILabel alloc] init];
        _refundMesLabel.numberOfLines = 1;
        _refundMesLabel.font = [UIFont systemFontOfSize:14];
        _refundMesLabel.textAlignment = NSTextAlignmentLeft;
        _refundMesLabel.textColor = CCCUIColorFromHex(0x999999);
        _refundMesLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _refundMesLabel.text = @"退款总额:";
    }
    return _refundMesLabel;
}
- (UILabel*)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.numberOfLines = 1;
        _amountLabel.font = [UIFont systemFontOfSize:15];
        _amountLabel.textAlignment = NSTextAlignmentLeft;
        _amountLabel.textColor = YTDefaultRedColor;
        _amountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _amountLabel;
}
- (UILabel*)hongbaoNumLabel
{
    if (!_hongbaoNumLabel) {
        _hongbaoNumLabel = [[UILabel alloc] init];
        _hongbaoNumLabel.numberOfLines = 1;
        _hongbaoNumLabel.font = [UIFont systemFontOfSize:14];
        _hongbaoNumLabel.textAlignment = NSTextAlignmentLeft;
        _hongbaoNumLabel.textColor = CCCUIColorFromHex(0x999999);
        _hongbaoNumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _hongbaoNumLabel;
}
- (UIButton *)refundBtn
{
    if (!_refundBtn) {
        _refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refundBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_refundBtn setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_refundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_refundBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        [_refundBtn addTarget:self action:@selector(refundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refundBtn;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];

}

@end
