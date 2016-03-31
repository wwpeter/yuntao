
#import "ShopDetailHeadView.h"
#import "ShopDetailAddressView.h"
#import "JSBadgeView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShopDetailModel.h"
#import "JSBadgeView.h"
#import "FXBlurView.h"
#import "NSStrUtil.h"
#import "UIImageView+YTImageWithURL.h"

@interface ShopDetailHeadView ()
@property (strong, nonatomic) UIView* discountView;
@property (strong, nonatomic) UIView* shopView;
@property (strong, nonatomic) UIImageView* shopLine;
@property (strong, nonatomic) UIImageView* addressLine;
@property (strong, nonatomic) FXBlurView* blurView;
@property (strong, nonatomic) JSBadgeView* badgeView;
@end
@implementation ShopDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    return self;
}
- (instancetype)initWithShopDetailModel:(ShopDetailModel*)shopModel Frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViewsWithShopDetailModel:shopModel];
    return self;
}
#pragma mark - Public methods
- (void)configShopDetailHeadViewWithModel:(ShopDetailModel*)shopModel
{
    if (shopModel.isPromotion) {
        [self.backImageView sd_setImageWithURL:[shopModel.backImgUrl imageUrlWithWidth:200] placeholderImage:[UIImage imageNamed:@"yt_store_default_background.png"]];
        if (shopModel.promotionType == 1) {
            self.discountLabel.font = [UIFont systemFontOfSize:80];
            self.discountLabel.text = [NSString stringWithFormat:@"%.1f", shopModel.discount / 10.];
        }else{
            self.discountLabel.font = [UIFont systemFontOfSize:16];
            self.discountLabel.attributedText = shopModel.subtractAttributed;
            self.subtractTimeLabel.attributedText = shopModel.subtractTimeAttributed;
        }
    }
    NSString *hjImageStr = [shopModel.hjImages firstObject][@"img"];
    [self.hjButton sd_setImageWithURL:[hjImageStr imageUrlWithWidth:200] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"yt_store_hjdefault.png"]];
    self.shopNameLabel.attributedText = shopModel.nameAttributed;
    self.rankImageView.image = [UIImage imageNamed:@"yt_star_level_10.png"];
    self.costLabel.text = [NSString stringWithFormat:@"¥%.2f/人", shopModel.equalPrice.floatValue / 100.];
    self.addressView.addressLabel.text = shopModel.shopAddress;
    if ([NSStrUtil isEmptyOrNull:shopModel.startDate]) {
        self.timeView.hidden = YES;
    }
    else {
        self.timeView.messageLabel.text = [NSString stringWithFormat:@"%@-%@", shopModel.startDate, shopModel.endDate];
    }
    if (shopModel.parking.integerValue == 0) {
        self.parkView.hidden = YES;
    }else{
        self.parkView.messageLabel.text = @"商家提供停车位";
    }
    _badgeView = [[JSBadgeView alloc] initWithParentView:self.hjButton alignment:JSBadgeViewAlignmentBottomRight];
    _badgeView.badgeTextFont = [UIFont systemFontOfSize:12];
    _badgeView.badgeBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    NSString* badgeText = [NSString stringWithFormat:@"%@", @(shopModel.hjImages.count)];
    CGFloat bx = 20 - badgeText.length;
    self.badgeView.badgePositionAdjustment = CGPointMake(-bx, -10);
    _badgeView.badgeText = badgeText;
}
#pragma mark - Event response
- (void)hjButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(shopDetailHeadView:didClickedIndex:)]) {
        [self.delegate shopDetailHeadView:self didClickedIndex:2];
    }
}
#pragma mark - Subviews
- (void)configSubViewsWithShopDetailModel:(ShopDetailModel*)shopModel
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.discountView];
    [self addSubview:self.shopView];
    [self.shopView addSubview:self.shopNameLabel];
    [self.shopView addSubview:self.rankImageView];
    [self.shopView addSubview:self.costLabel];
    [self.shopView addSubview:self.hjButton];
    [self.shopView addSubview:self.shopLine];
    [self addSubview:self.addressView];
    [self addSubview:self.addressLine];
    [self addSubview:self.timeView];
    [self addSubview:self.parkView];

    [_discountView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.mas_equalTo(self);
        if (shopModel.isPromotion) {
            make.height.mas_equalTo(200);
        }
        else {
            make.height.mas_equalTo(0);
        }
    }];
    [_shopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(_discountView.bottom);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(90);
    }];
    [_hjButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_shopView);
        make.size.mas_equalTo(CGSizeMake(70, 60));
    }];
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(_hjButton.left).priorityMedium();
        make.top.mas_equalTo(20);
    }];
    [_rankImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(_shopNameLabel.bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(76, 12));
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_rankImageView.right).offset(10);
        make.centerY.mas_equalTo(_rankImageView);
        make.right.mas_equalTo(_shopNameLabel);
    }];
    [_shopLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(_shopView);
        make.height.mas_equalTo(1);
    }];
    [_addressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_shopView.bottom);
        make.height.mas_equalTo(60);
    }];
    [_addressLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(_addressView.bottom);
        make.height.mas_equalTo(1);
    }];
    [_timeView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_addressLine.bottom);
        make.height.mas_equalTo([NSStrUtil isEmptyOrNull:shopModel.startDate]?0:44);
    }];
    [_parkView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(_timeView);
        make.top.mas_equalTo(_timeView.bottom);
        make.height.mas_equalTo(shopModel.parking.integerValue == 0?0:44);
    }];

    if (shopModel.promotionType > 0) {
        [self.discountView addSubview:self.backImageView];
        [self.discountView addSubview:self.blurView];
        [self.discountView addSubview:self.discountLabel];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.mas_equalTo(_discountView);
        }];
        [_blurView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.mas_equalTo(_discountView);
        }];
        [_discountLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.mas_equalTo(_discountView);
            make.bottom.mas_equalTo(shopModel.promotionType == 1 ? -20 : -50);
        }];
        if (shopModel.promotionType == 1) {
            [self.discountView addSubview:self.zheLabel];
            [_zheLabel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.bottom.mas_equalTo(_discountLabel).offset(-18);
                make.left.mas_equalTo(_discountLabel.right).offset(2);
            }];
        }else {
            [self.discountView addSubview:self.subtractTimeLabel];
            [_subtractTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_discountLabel.bottom).offset(5);
                make.centerX.mas_equalTo(_discountLabel);
            }];
        }

    }
    [self configShopDetailHeadViewWithModel:shopModel];

    __weak __typeof(self) weakSelf = self;
    _addressView.selectBlock = ^(NSInteger selectIndex) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(shopDetailHeadView:didClickedIndex:)]) {
            [strongSelf.delegate shopDetailHeadView:strongSelf didClickedIndex:selectIndex];
        }
    };
}

#pragma mark - Setter & Getter
- (UIView*)discountView
{
    if (!_discountView) {
        _discountView = [[UIView alloc] init];
    }
    return _discountView;
}
- (UIView*)shopView
{
    if (!_shopView) {
        _shopView = [[UIView alloc] init];
        _shopView.backgroundColor = [UIColor whiteColor];
    }
    return _shopView;
}
- (UIImageView*)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backImageView.image = [UIImage imageNamed:@"yt_store_default_background.png"];
    }
    return _backImageView;
}
- (UIImageView*)rankImageView
{
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rankImageView;
}
- (UIImageView*)shopLine
{
    if (!_shopLine) {
        _shopLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    }
    return _shopLine;
}
- (UIImageView*)addressLine
{
    if (!_addressLine) {
        _addressLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    }
    return _addressLine;
}
- (UIButton*)hjButton
{
    if (!_hjButton) {
        _hjButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hjButton.clipsToBounds = YES;
        _hjButton.contentMode = UIViewContentModeScaleAspectFill;
        _hjButton.layer.masksToBounds = YES;
        _hjButton.layer.cornerRadius = 4;
        [_hjButton addTarget:self action:@selector(hjButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hjButton;
}
- (UILabel*)discountLabel
{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.numberOfLines = 1;
        _discountLabel.font = [UIFont systemFontOfSize:80];
        _discountLabel.textColor = [UIColor whiteColor];
        _discountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _discountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _discountLabel;
}
- (UILabel*)zheLabel
{
    if (!_zheLabel) {
        _zheLabel = [[UILabel alloc] init];
        _zheLabel.numberOfLines = 1;
        _zheLabel.font = [UIFont systemFontOfSize:15];
        _zheLabel.textColor = [UIColor whiteColor];
        _zheLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _zheLabel.text = @"折";
    }
    return _zheLabel;
}
- (UILabel *)subtractTimeLabel
{
    if (!_subtractTimeLabel) {
        _subtractTimeLabel = [[UILabel alloc] init];
        _subtractTimeLabel.numberOfLines = 1;
        _subtractTimeLabel.font = [UIFont systemFontOfSize:14];
        _subtractTimeLabel.textColor = [UIColor whiteColor];
        _subtractTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _subtractTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtractTimeLabel;
}
- (UILabel*)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.numberOfLines = 1;
        _shopNameLabel.font = [UIFont systemFontOfSize:15];
        _shopNameLabel.textColor = CCCUIColorFromHex(0x333333);
        _shopNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _shopNameLabel;
}
- (UILabel*)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.numberOfLines = 1;
        _costLabel.font = [UIFont systemFontOfSize:12];
        _costLabel.textColor = [UIColor whiteColor];
        _costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _costLabel;
}
- (ShopDetailAddressView*)addressView
{
    if (!_addressView) {
        _addressView = [[ShopDetailAddressView alloc] init];
    }
    return _addressView;
}
- (ShopDetailSignView*)timeView
{
    if (!_timeView) {
        _timeView = [[ShopDetailSignView alloc] init];
        _timeView.clipsToBounds = YES;
        _timeView.iconImageView.image = [UIImage imageNamed:@"yt_store_time.png"];
        _timeView.leftMargin = 15;
    }
    return _timeView;
}
- (ShopDetailSignView*)parkView
{
    if (!_parkView) {
        _parkView = [[ShopDetailSignView alloc] init];
        _parkView.clipsToBounds = YES;
        _parkView.iconImageView.image = [UIImage imageNamed:@"yt_store_car.png"];
    }
    return _parkView;
}
- (FXBlurView*)blurView
{
    if (!_blurView) {
        _blurView = [[FXBlurView alloc] init];
        _blurView.tintColor = [UIColor colorWithWhite:0 alpha:0.5f];
        _blurView.dynamic = NO;
        //        _blurView.iterations = 1;
        _blurView.blurRadius = 10;
    }
    return _blurView;
}
@end

@implementation ShopDetailSignView

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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.iconImageView];
    [self addSubview:self.messageLabel];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14, 16));
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_iconImageView.right).offset(10);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self);
    }];
}

#pragma mark - Setter & Getter
- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel*)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 1;
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.textColor = CCCUIColorFromHex(0x333333);
        _messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _messageLabel;
}
- (void)drawRect:(CGRect)rect
{
    UIBezierPath* bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(_leftMargin, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}
@end
