
#import "ShopDetailBottomView.h"
#import "UIImage+HBClass.h"

@implementation ShopDetailBottomView

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
- (void)buyButtonClicked:(id)sender
{
    if (self.buyBlock) {
        self.buyBlock();
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    [self addSubview:self.textLabel];
    [self addSubview:self.buyButton];
    [_textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    [_buyButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(125, 40));
    }];
}
#pragma mark - Setter & Getter
- (UILabel*)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 1;
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = CCCUIColorFromHex(0x333333);
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.text = @"买单享折扣送红包";
    }
    return _textLabel;
}
- (UIButton*)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.layer.masksToBounds = YES;
        _buyButton.layer.cornerRadius = 3;
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_buyButton setTitle:@"去买单" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}
- (void)drawRect:(CGRect)rect
{
    UIBezierPath* bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
