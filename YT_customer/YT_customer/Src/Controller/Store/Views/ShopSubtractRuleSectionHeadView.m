#import "ShopSubtractRuleSectionHeadView.h"
#import "SubtractFullModel.h"

@implementation ShopSubtractRuleSectionHeadView

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
#pragma mark - Public methods
- (void)configSubtractRule:(SubtractFullRule *)fullRule nowRule:(SubtractFullRule *)nowRule
{
    self.title = [NSString stringWithFormat:@"每满%@元减%@元,最高减%@元",@(fullRule.subtractFull),@(fullRule.subtractCur),@(fullRule.subtractMax)];
    if (nowRule&&(fullRule == nowRule)) {
        self.descirbe = @"进行中";
        self.desTextColor = [UIColor redColor];
    }else{
        self.descirbe = @"未开始";
        self.desTextColor = CCCUIColorFromHex(0x999999);
    }

}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.describeLabel];
}

#pragma mark - Setter & Getter
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = title;
}
- (void)setDescirbe:(NSString *)descirbe
{
    _descirbe = [descirbe copy];
    _describeLabel.text = descirbe;
}
- (void)setDesTextColor:(UIColor *)desTextColor
{
    _desTextColor = desTextColor;
    _describeLabel.textColor = desTextColor;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-100, 0, 85, CGRectGetHeight(self.bounds))];
        _describeLabel.numberOfLines = 1;
        _describeLabel.font = [UIFont systemFontOfSize:14];
        _describeLabel.textColor = CCCUIColorFromHex(0x666666);
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _describeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _describeLabel;
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
    if (self.showBottomLine) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
        [ccColor setStroke];
        [bezierPath setLineWidth:1.0];
        [bezierPath stroke];
    }
}

@end
