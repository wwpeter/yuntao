#import "OrderDetailSectionFooterView.h"
#import "YTOrderModel.h"
@interface OrderDetailSectionFooterView ()

@property (nonatomic, strong) UIView* hbView;
@property (nonatomic, strong) UIView* refundView;
@property (nonatomic, strong) UIView* orderView;

@property (nonatomic, strong) MASConstraint* refundConstraint;
@end

@implementation OrderDetailSectionFooterView
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
- (void)configOrderDetailWithModel:(YTOrder*)order
{
    [self.refundConstraint uninstall];
    self.hbLabel.attributedText = [self hbAttributedStringWith:order];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号: %@", order.orderId];
    self.payOrderNumLabel.text = [NSString stringWithFormat:@"支付订单号: %@", order.toOuterId];
    self.timeLabel.text = [NSString stringWithFormat:@"成交时间: %@", [YTTaskHandler outDateStrWithTimeStamp:order.createdAt withStyle:@"yyyy-MM-dd HH:mm"]];
    if (order.status != YTORDERSTATUS_SUCCESS) {
         [self.refundConstraint install];
    }
}
#pragma mark - Event response
- (void)refundButtonClicked:(id)sender
{
    if (self.refundBlock) {
        self.refundBlock();
    }
}
#pragma mark - Private methods
- (NSAttributedString*)hbAttributedStringWith:(YTOrder*)order
{
    NSInteger totalNum = 0;
    for (YTCommonHongBao* commonHongbao in order.shopBuyHongbaos) {
        totalNum += commonHongbao.num;
    }
    NSString* hbNumberStr = [NSString stringWithFormat:@"%lu", (unsigned long)totalNum];
    NSString* costStr = [NSString stringWithFormat:@"￥%.2f", order.totalPrice / 100.];
    NSString* hbStr = [NSString stringWithFormat:@"共%@个红包      总价:%@", hbNumberStr, costStr];

    NSMutableAttributedString* numAttributedStr = [[NSMutableAttributedString alloc] initWithString:hbStr];
    [numAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1, hbNumberStr.length)];
    [numAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(hbStr.length - costStr.length, costStr.length)];
    [numAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(hbStr.length - costStr.length, costStr.length)];
    return [[NSAttributedString alloc] initWithAttributedString:numAttributedStr];
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.hbView = [[UIView alloc] init];
    self.hbView.clipsToBounds = YES;
    self.refundView = [[UIView alloc] init];
    self.refundView.clipsToBounds = YES;
    self.orderView = [[UIView alloc] init];
    self.orderView.clipsToBounds = YES;

    UIImageView* hbLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    UIImageView* refundLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    UIImageView* orderLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];

    [self addSubview:self.hbView];
    [self addSubview:self.refundView];
    [self addSubview:self.orderView];

    [self.hbView addSubview:self.hbLabel];
    [self.hbView addSubview:hbLine];
    [self.refundView addSubview:self.refundBtn];
    [self.refundView addSubview:refundLine];
    [self.orderView addSubview:self.orderNumLabel];
    [self.orderView addSubview:self.payOrderNumLabel];
    [self.orderView addSubview:self.timeLabel];
    [self.orderView addSubview:orderLine];

    [_hbView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(46);
    }];
    [_refundView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_hbView.bottom);
        make.height.mas_equalTo(46).priorityHigh();
        self.refundConstraint = make.height.mas_equalTo(0).priority(UILayoutPriorityRequired);
        [self.refundConstraint uninstall];
    }];
    [_orderView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(70);
    }];

    [_hbLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_hbView);
    }];
    [hbLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(_hbView);
        make.height.mas_equalTo(1);
    }];
    [_refundBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_refundView);
        make.size.mas_equalTo(CGSizeMake(68, 28));
    }];
    [refundLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.right.bottom.mas_equalTo(_refundView);
        make.height.mas_equalTo(1);
    }];
    [_orderNumLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
    }];
    [_payOrderNumLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_orderNumLabel);
        make.top.mas_equalTo(_orderNumLabel.bottom).offset(5);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_orderNumLabel);
        make.top.mas_equalTo(_payOrderNumLabel.bottom).offset(5);
    }];
    [orderLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(_orderView);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - Setter & Getter
- (UILabel*)hbLabel
{
    if (!_hbLabel) {
        _hbLabel = [[UILabel alloc] init];
        _hbLabel.numberOfLines = 1;
        _hbLabel.font = [UIFont systemFontOfSize:15];
        _hbLabel.textAlignment = NSTextAlignmentRight;
        _hbLabel.textColor = CCCUIColorFromHex(0x999999);
        _hbLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _hbLabel;
}
- (UILabel*)orderNumLabel
{
    if (!_orderNumLabel) {
        _orderNumLabel = [[UILabel alloc] init];
        _orderNumLabel.numberOfLines = 1;
        _orderNumLabel.font = [UIFont systemFontOfSize:13];
        _orderNumLabel.textColor = CCCUIColorFromHex(0x999999);
        _orderNumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _orderNumLabel;
}
- (UILabel*)payOrderNumLabel
{
    if (!_payOrderNumLabel) {
        _payOrderNumLabel = [[UILabel alloc] init];
        _payOrderNumLabel.numberOfLines = 1;
        _payOrderNumLabel.font = [UIFont systemFontOfSize:13];
        _payOrderNumLabel.textColor = CCCUIColorFromHex(0x999999);
        _payOrderNumLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _payOrderNumLabel;
}
- (UILabel*)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = CCCUIColorFromHex(0x999999);
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _timeLabel;
}
- (UIButton*)refundBtn
{
    if (!_refundBtn) {
        UIImage* norImage = [[UIImage imageNamed:@"pay_btn_nom"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        UIImage* higImage = [[UIImage imageNamed:@"pay_btn_hight"] stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        _refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _refundBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_refundBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        [_refundBtn setBackgroundImage:higImage forState:UIControlStateHighlighted];
        [_refundBtn setTitleColor:YTDefaultRedColor forState:UIControlStateNormal];
        [_refundBtn setTitle:@"退款" forState:UIControlStateNormal];
        [_refundBtn addTarget:self action:@selector(refundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refundBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
