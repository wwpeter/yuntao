
#import "VipIncomTableHeadView.h"

@implementation VipIncomTableHeadView

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
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor clearColor];
    UIImageView* redBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb_throw_redBackground.png"]];
    [self addSubview:redBackImageView];
    [self addSubview:self.leftView];
    [self addSubview:self.rightView];
    UIImageView *verticalLine = [[UIImageView alloc] initWithImage:YTlightGrayLineImage];
    verticalLine.alpha = 0.5f;
    [self addSubview:verticalLine];
    
    [redBackImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.mas_equalTo(self);
    }];
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(_leftView.right).offset(10);
    }];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.bottom.mas_equalTo(-25);
        make.width.mas_equalTo(1);
        make.centerX.mas_equalTo(self);
    }];
}
#pragma mark - Getters & Setters
- (void)setTotalIncome:(NSString *)totalIncome
{
    _totalIncome = [totalIncome copy];
    _leftView.costLabel.text = totalIncome;
}
- (void)setYesterdayIncom:(NSString *)yesterdayIncom
{
    _yesterdayIncom = [yesterdayIncom copy];
    _rightView.costLabel.text = yesterdayIncom;
}
- (IncomCostView *)leftView
{
    if (!_leftView) {
        _leftView = [[IncomCostView alloc] init];
        _leftView.titleLabel.text = @"累计总收益(元)";
    }
    return _leftView;
}
- (IncomCostView *)rightView
{
    if (!_rightView) {
        _rightView = [[IncomCostView alloc] init];
        _rightView.titleLabel.text = @"昨日总收益(元)";
    }
    return _rightView;
}
@end


@implementation IncomCostView

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

#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.costLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(28);
        make.right.mas_equalTo(self);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.bottom).offset(5);
    }];
}

#pragma mark - Setter & Getter
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel*)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.numberOfLines = 1;
        _costLabel.font = [UIFont systemFontOfSize:38];
        _costLabel.textColor = [UIColor whiteColor];
        _costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _costLabel;
}

@end