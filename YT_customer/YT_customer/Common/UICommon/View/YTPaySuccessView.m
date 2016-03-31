
#import "YTPaySuccessView.h"
#import "UIImage+HBClass.h"

@implementation YTPaySuccessView

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
    if ([self.delegate respondsToSelector:@selector(paySuccessView:clickedButtonAtIndex:)]) {
        [self.delegate paySuccessView:self clickedButtonAtIndex:0];
    }
}
- (void)lookButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(paySuccessView:clickedButtonAtIndex:)]) {
        [self.delegate paySuccessView:self clickedButtonAtIndex:1];
    }
}
#pragma mark - Public methods
#pragma mark - Private methods
#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.describeLabel];
    [self addSubview:self.buyButton];
    [self addSubview:self.lookButton];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(50);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_iconImageView.bottom).offset(25);
    }];
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_titleLabel.bottom).offset(20);
    }];
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(_describeLabel.bottom).offset(44);
        make.height.mas_equalTo(45);
    }];
    [_lookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_buyButton);
        make.top.mas_equalTo(_buyButton.bottom).offset(18);
        make.height.mas_equalTo(_buyButton);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.describeLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.describeLabel.frame);
    [super layoutSubviews];
}

#pragma mark - Getters & Setters
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_paySuccess.png"]];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"支付成功";
    }
    return _titleLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = CCCUIColorFromHex(0x666666);
        _describeLabel.font = [UIFont systemFontOfSize:15];
        _describeLabel.numberOfLines = 0;
        _describeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _describeLabel;
}
- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyButton.layer.masksToBounds = YES;
        _buyButton.layer.cornerRadius = 3;
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_buyButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xfd5c63)] forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setTitle:@"继续购买" forState:UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyButton;
}
- (UIButton *)lookButton
{
    if (!_lookButton) {
        _lookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookButton.layer.masksToBounds = YES;
        _lookButton.layer.cornerRadius = 3;
        _lookButton.layer.borderWidth = 1;
        _lookButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _lookButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_lookButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xf5f5f5)] forState:UIControlStateNormal];
        [_lookButton setTitleColor:CCCUIColorFromHex(0x333333) forState:UIControlStateNormal];
        [_lookButton setTitle:@"查看订单" forState:UIControlStateNormal];
        [_lookButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookButton;
}
@end
