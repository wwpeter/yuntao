

#import "YTTradeModel.h"
#import "CDealRecordDetailTableHeadView.h"
#import "RGLrTextView.h"
#import "CDealLrTextView.h"
#import "NSStrUtil.h"

static const NSInteger kLeftPadding = 10;
static const NSInteger kTopPadding = 15;

@interface CDealRecordDetailTableHeadView ()

@end

@implementation CDealRecordDetailTableHeadView
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
- (void)configDealRecordDetailHeadWithIntroModel:(YTTrade *)trade
{
    [self.userImageView setYTImageWithURL:[trade.user.avatar imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"cdealRecordUserPlace.png"]];
    self.nameLabel.text = trade.user.userName;
    if (trade.payType == YTPAYTYPE_FACErREFUND) {
        [self changeSubviewFacePayType];
    }
    else {
        if (trade.payType == YTPAYTYPE_FACEPAY) {
            self.feePriceView.rightLabel.text = [NSString stringWithFormat:@"-￥%.2f", trade.shouxvfei / 100.];
            self.procedurePriceView.leftLabel.text = @"平台补贴";
            self.procedurePriceView.rightLabel.text = [NSString stringWithFormat:@"+￥%.2f", trade.shopCashbackAmount / 100.];
            CGFloat total = trade.originPrice - trade.shouxvfei + trade.shopCashbackAmount;
            self.totalPriceView.rightLabel.text = [NSString stringWithFormat:@"￥%.2f", total / 100.];
            self.remarkView.hidden = YES;
            self.subsidyView.hidden = YES;
        }
        else {
//            CGFloat total = [trade promotionTotalPrice];
//            CGFloat promotion = trade.promotion < 2 ? 2 : trade.promotion;
            self.totalPriceView.rightLabel.text = [NSString stringWithFormat:@"￥%.2f", trade.inCome / 100.];
            self.feePriceView.rightLabel.text = [NSString stringWithFormat:@"￥%.2f", trade.shouxvfei / 100.];
            self.procedurePriceView.rightLabel.text = [NSString stringWithFormat:@"￥%.2f", (trade.originPrice  - trade.totalPrice) / 100.];
            self.remarkView.rightLabel.text = trade.trademessage;
        }
    }
    self.orderPriceView.rightLabel.text = [NSString stringWithFormat:@"￥%.2f", trade.originPrice / 100.];
    self.orderView.rightLabel.text = trade.toOuterId;
    self.payView.rightLabel.text = [YTTaskHandler outPayTyoeStrWithType:trade.payType];
    self.timeView.rightLabel.text = [YTTaskHandler outDateStrWithTimeStamp:trade.createdAt withStyle:@"yyyy-MM-dd HH:mm"];
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.clipsToBounds = YES;
//    self.backgroundColor = CCCUIColorFromHex(0xeeeeee);
    [self addSubview:self.userImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.totalPriceView];
    [self addSubview:self.orderPriceView];
    [self addSubview:self.procedurePriceView];
    [self addSubview:self.feePriceView];
    [self addSubview:self.subsidyView];
    [self addSubview:self.payView];
    [self addSubview:self.timeView];
    [self addSubview:self.orderView];
    [self addSubview:self.remarkView];
    
    UIImageView *horizontalLine1 = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    [self addSubview:horizontalLine1];

    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.top.mas_equalTo(kTopPadding);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userImageView.right).offset(kLeftPadding);
        make.centerY.mas_equalTo(_userImageView);
        make.right.mas_equalTo(self);
    }];
    [_totalPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(70);
        make.height.mas_equalTo(50);
    }];
    [_orderPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_totalPriceView.bottom);
        make.height.mas_equalTo(_totalPriceView);
    }];
    [_procedurePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_orderPriceView.bottom);
        make.height.mas_equalTo(_totalPriceView);
    }];
    [_feePriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_procedurePriceView.bottom);
        make.height.mas_equalTo(_totalPriceView);
    }];
    [_subsidyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_feePriceView.bottom);
        make.height.mas_equalTo(_totalPriceView);
    }];
    [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_subsidyView.bottom).offset(10);
        make.height.mas_equalTo(24);
    }];
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_payView.bottom);
        make.height.mas_equalTo(_payView);
    }];
    [_orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_timeView.bottom);
        make.height.mas_equalTo(32);
    }];
    
    [horizontalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.top.mas_equalTo(_orderView.bottom).offset(5);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [_remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(horizontalLine1.bottom).offset(5);
        make.height.mas_equalTo(_payView);
    }];
}
- (void)changeSubviewFacePayType
{
    [_totalPriceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(70);
        make.height.mas_equalTo(@0);
    }];
    [_orderPriceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_totalPriceView.bottom);
        make.height.mas_equalTo(@50);
    }];
    [_procedurePriceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_orderPriceView.bottom);
        make.height.mas_equalTo(@0);
    }];
    [_feePriceView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_procedurePriceView.bottom);
        make.height.mas_equalTo(@0);
    }];
    [_subsidyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_feePriceView.bottom);
        make.height.mas_equalTo(@0);
    }];
    [_remarkView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_feePriceView.bottom);
        make.height.mas_equalTo(@0);
    }];
    _totalPriceView.hidden = YES;
    _procedurePriceView.hidden = YES;
    _feePriceView.hidden = YES;
    _subsidyView.hidden = YES;
    _remarkView.hidden = YES;
}
#pragma mark - Getters & Setters
- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
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
        _nameLabel = [[UILabel alloc] init];
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
        _totalPriceView = [[RGLrTextView alloc] init];
        _totalPriceView.displayTopLine = YES;
        _totalPriceView.leftMargin = kLeftPadding;
        _totalPriceView.leftLabel.font = [UIFont systemFontOfSize:16];
        _totalPriceView.leftLabel.textColor = [UIColor blackColor];
        _totalPriceView.rightLabel.textColor = YTDefaultRedColor;
        _totalPriceView.leftLabel.text = @"合计收入";
    }
    return _totalPriceView;
}
- (RGLrTextView *)orderPriceView
{
    if (!_orderPriceView) {
        _orderPriceView = [[RGLrTextView alloc] init];
        _orderPriceView.leftMargin = kLeftPadding;
        _orderPriceView.leftLabel.textColor = CCCUIColorFromHex(0x999999);
        _orderPriceView.rightLabel.textColor = [UIColor blackColor];
        _orderPriceView.leftLabel.text = @"订单总额";
    }
    return _orderPriceView;
}
- (RGLrTextView *)procedurePriceView
{
    if (!_procedurePriceView) {
        _procedurePriceView = [[RGLrTextView alloc] init];
        _procedurePriceView.leftMargin = kLeftPadding;
        _procedurePriceView.leftLabel.textColor = CCCUIColorFromHex(0x999999);
        _procedurePriceView.rightLabel.textColor = YTDefaultRedColor;
        _procedurePriceView.leftLabel.text = @"用户折扣";
    }
    return _procedurePriceView;
}
- (RGLrTextView *)feePriceView
{
    if (!_feePriceView) {
        _feePriceView = [[RGLrTextView alloc] init];
        _feePriceView.leftMargin = kLeftPadding;
        _feePriceView.leftLabel.textColor = CCCUIColorFromHex(0x999999);
        _feePriceView.rightLabel.textColor = YTDefaultRedColor;
        _feePriceView.leftLabel.text = @"手续费";
    }
    return _feePriceView;
}
- (RGLrTextView *)subsidyView
{
    if (!_subsidyView) {
        _subsidyView = [[RGLrTextView alloc] init];
        _subsidyView.leftMargin = kLeftPadding;
        _subsidyView.leftLabel.textColor = CCCUIColorFromHex(0x999999);
        _subsidyView.rightLabel.textColor = YTDefaultRedColor;
        _subsidyView.leftLabel.text = @"平台补贴";
    }
    return _subsidyView;
}
- (CDealLrTextView *)payView
{
    if (!_payView) {
        _payView = [[CDealLrTextView alloc] init];
        _payView.leftLabel.text = @"交易类型";
    }
    return _payView;
}
- (CDealLrTextView *)timeView
{
    if (!_timeView) {
        _timeView = [[CDealLrTextView alloc] init];
        _timeView.leftLabel.text = @"创建时间";
    }
    return _timeView;
}
- (CDealLrTextView *)orderView
{
    if (!_orderView) {
        _orderView = [[CDealLrTextView alloc] init];
        _orderView.leftLabel.text = @"订单号";
        _orderView.rightLabel.numberOfLines = 2;
    }
    return _orderView;
}
- (CDealLrTextView *)remarkView
{
    if (!_remarkView) {
        _remarkView = [[CDealLrTextView alloc] init];
        _remarkView.leftLabel.text = @"备注";
    }
    return _remarkView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
