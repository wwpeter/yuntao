
#import "OrderCellFootView.h"
#import "YTOrderModel.h"

@implementation OrderCellFootView

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
- (void)payButtonClicked:(id)sender
{
    if (self.payBlock) {
        self.payBlock();
    }
}
#pragma mark - Public methods
- (void)configOrderFootViewWithOrder:(YTOrder *)order
{
    NSInteger totalNum = 0;
    for (YTCommonHongBao *commonHongbao in order.shopBuyHongbaos) {
        totalNum += commonHongbao.num;
    }
    NSString *hbNumberStr = [NSString stringWithFormat:@"%lu",(unsigned long)totalNum];
    NSMutableAttributedString* numAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@个红包",hbNumberStr]];
    [numAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1, hbNumberStr.length)];
    self.titleLabel.attributedText = numAttributedStr;
    
    NSString *costStr = [NSString stringWithFormat:@"%.2f",order.totalPrice/100.];
    NSMutableAttributedString* costAttributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"金额:￥%@",costStr]];
    [costAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(3, costStr.length+1)];
    [costAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(3, costStr.length+1)];
    self.rightLabel.attributedText = costAttributedStr;

}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.rightLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.payButton];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(12);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_rightLabel.left).offset(-20);
        make.centerY.mas_equalTo(_rightLabel);
    }];
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-9);
        make.size.mas_equalTo(CGSizeMake(68, 28));
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = kDeviceWidth-120;
    self.rightLabel.preferredMaxLayoutWidth = 100;
    [super layoutSubviews];
}
#pragma mark - Getters & Setters
- (void)setShowPayButton:(BOOL)showPayButton
{
    _showPayButton = showPayButton;
    _payButton.hidden = !showPayButton;
}
- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = CCCUIColorFromHex(0x999999);
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.numberOfLines = 1;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CCCUIColorFromHex(0x999999);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}
- (UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_payButton setTitleColor:YTDefaultRedColor forState:UIControlStateNormal];
        [_payButton setTitle:@"支付" forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_nom"] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"pay_btn_hight"] forState:UIControlStateHighlighted];
        [_payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.hidden = YES;
    }
    return _payButton;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    
    if (_showPayButton) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(15, CGRectGetHeight(rect)/2)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)/2)];
        [ccColor setStroke];
        [bezierPath setLineWidth:0.5f];
        [bezierPath stroke];
    }
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
