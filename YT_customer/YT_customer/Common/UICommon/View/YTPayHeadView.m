
#import "YTPayHeadView.h"
#include "YTPaySingleView.h"

static const NSInteger kLeftPadding = 15;

@interface YTPayHeadView ()<YTPaySingleViewDelegate>

@property(strong, nonatomic)YTPaySingleView *wxPayView;
@property(strong, nonatomic)YTPaySingleView *zfbPayView;

@end

@implementation YTPayHeadView

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

#pragma mark - YTPaySingleViewDelegate
- (void)paySingleView:(YTPaySingleView *)view didSelectAccessoryButton:(UIButton *)button
{
    if (view == self.wxPayView) {
        return;
//        self.wxPayView.choiced = YES;
//        self.zfbPayView.choiced = NO;
//        self.payMode = YTPayModeWx;
    } else {
        self.zfbPayView.choiced = YES;
        self.wxPayView.choiced = NO;
        self.payMode = YTPayModeZfb;
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.payMode = YTPayModeZfb;
    UIView *topView = [[UIView alloc] init];
    [self addSubview:topView];
    [topView addSubview:self.titleLabel];
    [topView addSubview:self.messageLabel];
    [topView addSubview:self.costLabel];
    [self addSubview:self.wxPayView];
    [self addSubview:self.zfbPayView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.centerY.mas_equalTo(topView);
        make.width.mas_equalTo(100);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(topView).offset(-kLeftPadding);
        make.centerY.mas_equalTo(topView);
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_costLabel.left).offset(-kLeftPadding);
        make.centerY.mas_equalTo(topView);
    }];


    [_zfbPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(topView.bottom);
        make.height.mas_equalTo(60);
    }];
    [_wxPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_zfbPayView.bottom);
        make.bottom.mas_equalTo(self);
    }];
    self.zfbPayView.choiced = YES;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.messageLabel.preferredMaxLayoutWidth = 90;
    self.messageLabel.preferredMaxLayoutWidth = 100;
    [super layoutSubviews];
}
#pragma mark - Getters & Setters
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CCCUIColorFromHex(0x999999);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 1;

    }
    return _titleLabel;
}
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = CCCUIColorFromHex(0x999999);
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.numberOfLines = 1;
        _messageLabel.textAlignment = NSTextAlignmentRight;
    }
    return _messageLabel;
}

- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x999999);
        _costLabel.font = [UIFont systemFontOfSize:15];
        _costLabel.numberOfLines = 1;
        _costLabel.textAlignment = NSTextAlignmentRight;
    }
    return _costLabel;
}
- (YTPaySingleView *)wxPayView
{
    if (!_wxPayView) {
        _wxPayView = [[YTPaySingleView alloc] init];
        _wxPayView.iconImageView.image = [UIImage imageNamed:@"yt_payType_wx.png"];
        _wxPayView.titleLabel.text = @"微信支付";
//        _wxPayView.messageLabel.text = @"推荐安装微信5.0以上版本使用";
        _wxPayView.messageLabel.text = @"微信支付功能暂未开通，敬请期待";
        _wxPayView.delegate = self;
        _wxPayView.choiced = NO;
    }
    return _wxPayView;
}
- (YTPaySingleView *)zfbPayView
{
    if (!_zfbPayView) {
        _zfbPayView = [[YTPaySingleView alloc] init];
        _zfbPayView.iconImageView.image = [UIImage imageNamed:@"yt_payType_zfb.png"];
        _zfbPayView.titleLabel.text = @"支付宝支付";
        _zfbPayView.messageLabel.text = @"支持有支付宝、网银的用户使用";
        _zfbPayView.separatorMargin = kLeftPadding;
        _zfbPayView.delegate = self;
    }
    return _zfbPayView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 44)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 44)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}


@end
