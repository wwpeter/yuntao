#import "PromotionTableHeadView.h"
#import "YTYellowBackgroundView.h"

@implementation PromotionTableHeadView

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
- (void)startActivityAnimating
{
    [self.indicator startAnimating];
}
- (void)stopActivityAnimating
{
    [self.indicator stopAnimating];
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.yellowView];
    [self addSubview:self.consumeLabel];
    [self addSubview:self.consumeMesLabel];
    [self addSubview:self.statisticsView];
    [self addSubview:self.indicator];
    [_yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(30);
    }];
    [_consumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_yellowView.bottom).offset(5);
    }];
    [_statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(130);
    }];
    [_consumeMesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(100);
    }];
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

#pragma mark - Event response

#pragma mark - Getters & Setters
- (UILabel *)consumeLabel
{
    if (!_consumeLabel) {
        _consumeLabel = [[UILabel alloc] init];
        _consumeLabel.numberOfLines = 1;
        _consumeLabel.font = [UIFont systemFontOfSize:50];
        _consumeLabel.textColor = CCCUIColorFromHex(0xfd5c63);
        _consumeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _consumeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _consumeLabel;
}
- (UILabel *)consumeMesLabel
{
    if (!_consumeMesLabel) {
        _consumeMesLabel = [[UILabel alloc] init];
        _consumeMesLabel.numberOfLines = 1;
        _consumeMesLabel.font = [UIFont systemFontOfSize:12];
        _consumeMesLabel.textColor = CCCUIColorFromHex(0x666666);
        _consumeMesLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _consumeMesLabel.textAlignment = NSTextAlignmentCenter;
        _consumeMesLabel.text = @"客户消费(元)";
    }
    return _consumeMesLabel;
}
- (YTYellowBackgroundView *)yellowView
{
    if (!_yellowView) {
        _yellowView = [[YTYellowBackgroundView alloc] init];
        _yellowView.textLabel.text = @"买单就送等值红包";
    }
    return _yellowView;
}
- (YTStatisticsHeadView *)statisticsView
{
    if (!_statisticsView) {
        _statisticsView = [[YTStatisticsHeadView alloc] init];
        _statisticsView.displayTopLine = YES;
    }
    return _statisticsView;
}
- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.hidesWhenStopped = YES;
    }
    return _indicator;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
