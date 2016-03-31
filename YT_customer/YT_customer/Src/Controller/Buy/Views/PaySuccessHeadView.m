#import "PaySuccessHeadView.h"
#import "PaySuccessModel.h"

static const NSInteger kLeftPadding = 15;
static const NSInteger kTextPadding = 2;

@interface PaySuccessHeadView ()
@property (strong, nonatomic) UIImageView* lineImageView;
@end
@implementation PaySuccessHeadView

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
- (void)configPaySuccessHeadViewWithModel:(PaySuccessModel*)paySuccessModel
{
    if (paySuccessModel.payStatus == UserPayModelStatusWaitePayed || paySuccessModel.payStatus == UserPayModelStatusWaiteUserPayRefundSuccess) {
        _iconImageView.image = [UIImage imageNamed:@"yt_notification_success.png"];
    }
    else {
        _iconImageView.image = [UIImage imageNamed:@"yt_notification_fail.png"];
    }
    self.titleLabel.text = paySuccessModel.payStatusStr;
    self.nameLabel.text = [NSString stringWithFormat:@"商户名称: %@", paySuccessModel.storeName];
    self.costLabel.text = [NSString stringWithFormat:@"支付金额: ￥%2.f", paySuccessModel.totalPrice/100.];
    self.orderLabel.text = [NSString stringWithFormat:@"订单号: %@", paySuccessModel.orderCode];
    if (paySuccessModel.payStatus == UserPayModelStatusWaitePay) {
        self.timeLabel.text = [NSString stringWithFormat:@"消费时间: %@", paySuccessModel.createTime];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"消费时间: %@", paySuccessModel.consumeTime];
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    UIView* whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [self addSubview:self.lineImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.costLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.orderLabel];

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(kLeftPadding);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_iconImageView.right).offset(10);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(_iconImageView);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.bottom).offset(5);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.bottom).offset(kTextPadding);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_costLabel.bottom).offset(kTextPadding);
    }];
    [_orderLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_timeLabel.bottom).offset(kTextPadding);
    }];

    UIImage* lineImage = [UIImage imageNamed:@"yt_breakline.png"];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(lineImage.size.height);
    }];
    self.lineImageView.image = lineImage;
    [whiteView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(_lineImageView.top);
    }];
}
#pragma mark - Getters & Setters
- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ye_paySuccess_greenIcon.png"]];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}
- (UIImageView*)lineImageView
{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.clipsToBounds = YES;
        _lineImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _lineImageView;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CCCUIColorFromHex(0x666666);
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel*)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x666666);
        _costLabel.font = [UIFont systemFontOfSize:13];
        _costLabel.numberOfLines = 1;
    }
    return _costLabel;
}
- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CCCUIColorFromHex(0x666666);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
}
- (UILabel*)orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.textColor = CCCUIColorFromHex(0x666666);
        _orderLabel.font = [UIFont systemFontOfSize:13];
        _orderLabel.numberOfLines = 1;
    }
    return _orderLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
