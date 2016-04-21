
#import "OrderDetailHeadView.h"
#import "YTOrderModel.h"

@interface OrderDetailHeadView ()
@property(nonatomic, strong)UIImageView *bgImageView;
@end

@implementation OrderDetailHeadView

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
- (void)configDetailWithModel:(YTOrder *)order
{
    self.statusImageView.image = [self imageStatus:order.status];
    self.statusLabel.text = [YTTaskHandler outOrderStatusStrWithStatus:order.status];
    self.amountLabel.text = [NSString stringWithFormat:@"订单金额: ¥%.2f",order.totalPrice / 100.];
    NSString *timeStr = [YTTaskHandler outDateStrWithTimeStamp:order.createdAt withStyle:@"yyyy-MM-dd HH:mm"];
    if (order.status == YTORDERSTATUS_WAITEPAY || order.status == YTORDERSTATUS_SUCCESS) {
        self.payLabel.text = [NSString stringWithFormat:@"支付方式: %@",[YTTaskHandler outPayTyoeStrWithType:order.payType]];
    }else if (order.status == YTORDERSTATUS_REFUND) {
           self.payLabel.text = [NSString stringWithFormat:@"申请退款时间: %@",timeStr];
    }else if (order.status == YTORDERSTATUS_REFUNDSUCCESS) {
        self.payLabel.text = [NSString stringWithFormat:@"退款时间: %@",timeStr];
    }else {
         self.payLabel.text = [NSString stringWithFormat:@"关闭时间: %@",timeStr];
    }
}
#pragma mark - Private methods
- (UIImage *)imageStatus:(YTORDERSTATUS)status
{
    if (status == YTORDERSTATUS_WAITEPAY) {
        return [UIImage imageNamed:@"red_clock"];
        
    }else if (status == YTORDERSTATUS_SUCCESS) {
        return [UIImage imageNamed:@"pay_suc"];
    }else if (status == YTORDERSTATUS_REFUND) {
        return [UIImage imageNamed:@"red_clock"];
    }else if (status == YTORDERSTATUS_REFUNDSUCCESS) {
        return [UIImage imageNamed:@"pay_suc"];
    }else if (status == YTORDERSTATUS_TIMEOUT) {
        return [UIImage imageNamed:@"grey_clock"];
    }else {
        return [UIImage imageNamed:@"grey_clock"];
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor hexFloatColor:@"f1f1f1"];
    [self addSubview:self.bgImageView];
    [self addSubview:self.statusImageView];
    [self addSubview:self.statusLabel];
    [self addSubview:self.amountLabel];
    [self addSubview:self.payLabel];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(-5);
    }];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_statusImageView.right).offset(10);
        make.top.mas_equalTo(_statusImageView);
        make.right.mas_equalTo(self);
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_statusLabel);
        make.top.mas_equalTo(_statusLabel.bottom).offset(5);
    }];
    [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_statusLabel);
        make.top.mas_equalTo(_amountLabel.bottom).offset(5);
    }];
}

#pragma mark - Setter & Getter
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        UIImage *image = [[UIImage imageNamed:@"wave_line"] stretchableImageWithLeftCapWidth:0 topCapHeight:5];
        _bgImageView = [[UIImageView alloc] initWithImage:image];
    }
    return _bgImageView;
}
- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        _statusImageView.clipsToBounds = YES;
    }
    return _statusImageView;
}
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.numberOfLines = 1;
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.textColor = CCCUIColorFromHex(0x333333);
        _statusLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _statusLabel;
}
- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.numberOfLines = 1;
        _amountLabel.font = [UIFont systemFontOfSize:13];
        _amountLabel.textColor = CCCUIColorFromHex(0x999999);
        _amountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _amountLabel;
}
- (UILabel *)payLabel
{
    if (!_payLabel) {
        _payLabel = [[UILabel alloc] init];
        _payLabel.numberOfLines = 1;
        _payLabel.font = [UIFont systemFontOfSize:13];
        _payLabel.textColor = CCCUIColorFromHex(0x999999);
        _payLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _payLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
