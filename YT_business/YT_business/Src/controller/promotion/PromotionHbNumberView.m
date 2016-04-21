

#import "YTPromotionModel.h"
#import "PromotionHbNumberView.h"


static const NSInteger kRightMaxWidth = 120;

@implementation PromotionHbNumberView

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
#pragma mark - Public methods
- (void)configPromotionHbNumberViewWithModel:(YTPromotionHongbao *)promotionHongbao {
    self.provideLabel.text = [NSString stringWithFormat:@"%d",promotionHongbao.num-promotionHongbao.remainNum];
    self.thanLabel.text = [NSString stringWithFormat:@"%d",promotionHongbao.remainNum];
    self.consumeLabel.text = [NSString stringWithFormat:@"%.2f",promotionHongbao.userConsume/100.];
}
#pragma mark - SubViews
- (void)configSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.consumeLabel];
    [self addSubview:self.consumeBottomLabel];
    [self addSubview:self.provideLabel];
    [self addSubview:self.provideBottomLabel];
    [self addSubview:self.thanLabel];
    [self addSubview:self.thanBottomLabel];
    
    [_provideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(kRightMaxWidth);
    }];
    [_provideBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_provideLabel.bottom).offset(2);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(_provideLabel);
    }];
    [_thanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(70+10);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(_provideLabel);
    }];
    [_thanBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_thanLabel.bottom).offset(2);
        make.right.mas_equalTo(self);
        make.width.mas_equalTo(_thanLabel);
    }];
    [_consumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-kRightMaxWidth);
        make.centerY.mas_equalTo(self).offset(-10);
    }];
    [_consumeBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_consumeLabel);
        make.top.mas_equalTo(_consumeLabel.bottom).offset(5);
    }];
}

#pragma mark - Setter & Getter
- (UILabel *)consumeLabel
{
    if (!_consumeLabel) {
        _consumeLabel = [[UILabel alloc] init];
        _consumeLabel.textColor = YTDefaultRedColor;
        _consumeLabel.font = [UIFont systemFontOfSize:50];
        _consumeLabel.numberOfLines = 1;
        _consumeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _consumeLabel;
}
- (UILabel *)consumeBottomLabel
{
    if (!_consumeBottomLabel) {
        _consumeBottomLabel = [[UILabel alloc] init];
        _consumeBottomLabel.textColor = CCCUIColorFromHex(0x666666);
        _consumeBottomLabel.font = [UIFont systemFontOfSize:13];
        _consumeBottomLabel.numberOfLines = 1;
        _consumeBottomLabel.textAlignment = NSTextAlignmentCenter;
        _consumeBottomLabel.text = @"客户消费(元)";
    }
    return _consumeBottomLabel;
}
- (UILabel *)provideLabel
{
    if (!_provideLabel) {
        _provideLabel = [[UILabel alloc] init];
        _provideLabel.textColor = YTDefaultRedColor;
        _provideLabel.font = [UIFont systemFontOfSize:25];
        _provideLabel.numberOfLines = 1;
        _provideLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _provideLabel;
}
- (UILabel *)provideBottomLabel
{
    if (!_provideBottomLabel) {
        _provideBottomLabel = [[UILabel alloc] init];
        _provideBottomLabel.textColor = CCCUIColorFromHex(0x666666);
        _provideBottomLabel.font = [UIFont systemFontOfSize:13];
        _provideBottomLabel.numberOfLines = 1;
        _provideBottomLabel.textAlignment = NSTextAlignmentCenter;
        _provideBottomLabel.text = @"发放红包";
    }
    return _provideBottomLabel;
}
- (UILabel *)thanLabel
{
    if (!_thanLabel) {
        _thanLabel = [[UILabel alloc] init];
        _thanLabel.textColor = YTDefaultRedColor;
        _thanLabel.font = [UIFont systemFontOfSize:25];
        _thanLabel.numberOfLines = 1;
         _thanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thanLabel;
}
- (UILabel *)thanBottomLabel
{
    if (!_thanBottomLabel) {
        _thanBottomLabel = [[UILabel alloc] init];
        _thanBottomLabel.textColor = CCCUIColorFromHex(0x666666);
        _thanBottomLabel.font = [UIFont systemFontOfSize:13];
        _thanBottomLabel.numberOfLines = 1;
        _thanBottomLabel.textAlignment = NSTextAlignmentCenter;
        _thanBottomLabel.text = @"剩余红包";
    }
    return _thanBottomLabel;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),0)];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),CGRectGetHeight(rect))];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    CGFloat vx = CGRectGetWidth(rect) - kRightMaxWidth;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(vx, 0)];
    [bezierPath addLineToPoint:CGPointMake(vx,CGRectGetHeight(rect))];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(vx, 70)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),70)];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
}

@end
