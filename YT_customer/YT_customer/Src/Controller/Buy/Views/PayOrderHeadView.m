#import "PayOrderHeadView.h"
#import "RGLrTextView.h"
#import "UIImageView+WebCache.h"
#import "NSDate+TimeInterval.h"
#import "PaySuccessModel.h"
#import "UIView+DKAddition.h"
#import "NSStrUtil.h"

static const NSInteger kLeftPadding = 10;
static const NSInteger kTopPadding = 15;

@implementation PayOrderHeadView

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
- (void)configPayOrderHeadViewWithIntroModel:(PaySuccessModel *)payModel
{
    [self.userImageView sd_setImageWithURL:[payModel.storeImg imageUrlWithWidth:200] placeholderImage:[UIImage imageNamed:@"cdealRecordUserPlace.png"]];
    self.nameLabel.text = payModel.storeName;
    self.totalPriceView.rightLabel.text = [NSString stringWithFormat:@"￥%.2f",payModel.totalPrice/100.];
    self.orderPriceView.rightLabel.text = [NSString stringWithFormat:@"￥%.2f",payModel.originPrice/100.];
        self.feePriceView.rightLabel.text= [NSString stringWithFormat:@"￥%.2f",(payModel.originPrice-payModel.totalPrice)/100.];
        self.orderView.rightLabel.text = payModel.orderCode;
        self.payView.rightLabel.text = @"用户付款";
        self.timeView.rightLabel.text = payModel.createTime;
    self.remarkView.rightLabel.text = payModel.message;
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.userImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.totalPriceView];
    [self addSubview:self.orderPriceView];
    [self addSubview:self.feePriceView];
    [self addSubview:self.payView];
    [self addSubview:self.timeView];
    [self addSubview:self.orderView];
    [self addSubview:self.remarkView];
    
    UIImageView *horizontalLine1 = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    horizontalLine1.frame = CGRectMake(kLeftPadding, _orderView.dk_bottom+5, CGRectGetWidth(self.bounds)-kLeftPadding, 1);
    [self addSubview:horizontalLine1];

}

#pragma mark - Getters & Setters
- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftPadding, kTopPadding, 40, 40)];
        _userImageView.clipsToBounds = YES;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 2;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userImageView.dk_right+kLeftPadding, kTopPadding, CGRectGetWidth(self.bounds), 40)];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
- (RGLrTextView *)totalPriceView
{
    if (!_totalPriceView) {
        _totalPriceView = [[RGLrTextView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.bounds), 50)];
        _totalPriceView.displayTopLine = YES;
        _totalPriceView.leftMargin = kLeftPadding;
        _totalPriceView.leftLabel.font = [UIFont systemFontOfSize:16];
        _totalPriceView.leftLabel.textColor = [UIColor blackColor];
        _totalPriceView.rightLabel.textColor = YTDefaultRedColor;
        _totalPriceView.leftLabel.text = @"合计付费";
    }
    return _totalPriceView;
}
- (RGLrTextView *)orderPriceView
{
    if (!_orderPriceView) {
        _orderPriceView = [[RGLrTextView alloc] initWithFrame:CGRectMake(0, _totalPriceView.dk_bottom, CGRectGetWidth(self.bounds), 50)];
        _orderPriceView.leftMargin = kLeftPadding;
        _orderPriceView.leftLabel.textColor = CCCUIColorFromHex(0x999999);
        _orderPriceView.rightLabel.textColor = [UIColor blackColor];
        _orderPriceView.leftLabel.text = @"订单总额";
    }
    return _orderPriceView;
}
- (RGLrTextView *)feePriceView
{
    if (!_feePriceView) {
        _feePriceView = [[RGLrTextView alloc] initWithFrame:CGRectMake(0, _orderPriceView.dk_bottom, CGRectGetWidth(self.bounds), 50)];
        _feePriceView.leftMargin = kLeftPadding;
        _feePriceView.leftLabel.textColor = YTDefaultRedColor;
        _feePriceView.rightLabel.textColor = YTDefaultRedColor;
        _feePriceView.leftLabel.text = @"折扣优惠";
    }
    return _feePriceView;
}
- (DealLrTextView *)payView
{
    if (!_payView) {
        _payView = [[DealLrTextView alloc] initWithFrame:CGRectMake(0, _feePriceView.dk_bottom+10,CGRectGetWidth(self.bounds) , 24)];
        _payView.leftLabel.text = @"交易类型";
    }
    return _payView;
}
- (DealLrTextView *)timeView
{
    if (!_timeView) {
        _timeView = [[DealLrTextView alloc] initWithFrame:CGRectMake(0, _payView.dk_bottom,CGRectGetWidth(self.bounds) , 24)];
        _timeView.leftLabel.text = @"创建时间";
    }
    return _timeView;
}
- (DealLrTextView *)orderView
{
    if (!_orderView) {
        _orderView = [[DealLrTextView alloc] initWithFrame:CGRectMake(0, _timeView.dk_bottom,CGRectGetWidth(self.bounds) , 24)];
        _orderView.leftLabel.text = @"订单号";
    }
    return _orderView;
}
- (DealLrTextView *)remarkView
{
    if (!_remarkView) {
        _remarkView = [[DealLrTextView alloc] initWithFrame:CGRectMake(0, _orderView.dk_bottom+6,CGRectGetWidth(self.bounds) , 24)];
        _remarkView.leftLabel.text = @"备注";
    }
    return _remarkView;
}

 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
     
     UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
     UIBezierPath *bezierPath;
     
     bezierPath = [UIBezierPath bezierPath];
     [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
     [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
     [ccColor setStroke];
     [bezierPath setLineWidth:1.0];
     [bezierPath stroke];
 }
 

@end

@implementation DealLrTextView
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
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_leftLabel.right).offset(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}

#pragma mark - Setter & Getter
- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.numberOfLines = 1;
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = CCCUIColorFromHex(0x999999);
        _leftLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.numberOfLines = 1;
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textColor = CCCUIColorFromHex(0x333333);
        _rightLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _rightLabel;
}

@end
