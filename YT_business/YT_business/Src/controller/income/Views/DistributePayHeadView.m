
#import "DistributePayHeadView.h"

static const NSInteger kLeftPadding = 15;

@implementation DistributePayHeadView

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
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(100);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kLeftPadding);
        make.centerY.mas_equalTo(self);
    }];
}
#pragma mark - Getters & Setters
- (void)setDetailText:(NSString *)detailText
{
    _detailText = [detailText copy];
    _detailLabel.text = detailText;
}
- (void)setDetailAttributedString:(NSAttributedString *)detailAttributedString
{
    _detailAttributedString = [detailAttributedString copy];
    _detailLabel.attributedText = detailAttributedString;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CCCUIColorFromHex(0x666666);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"选择支付方式";
        
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = CCCUIColorFromHex(0x666666);
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.numberOfLines = 1;
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}
- (void)drawRect:(CGRect)rect {
    
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
}


@end
