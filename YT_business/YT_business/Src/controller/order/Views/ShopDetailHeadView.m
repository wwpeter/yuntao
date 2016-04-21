#import "ShopDetailHeadView.h"
#import "ShopDetailAddressView.h"
#import "YTUpdateShopInfoModel.h"
#import "JSBadgeView.h"
#import "UIImageView+WebCache.h"

@interface ShopDetailHeadView ()
@property (strong, nonatomic) JSBadgeView* badgeView;
@property (strong, nonatomic) UIImageView* addressLine;
@end

@implementation ShopDetailHeadView
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
- (instancetype)initWithShopInfoModel:(YTUpdateShopInfoModel*)shopInfoModel frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    _shopInfoModel = shopInfoModel;
    [self configSubViews];
    return self;
}
#pragma mark - Public methods
- (void)configShopDetailHeadViewWithModel:(YTUpdateShopInfoModel*)shopInfoModel
{
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:shopInfoModel.shopInfo.shop.img] placeholderImage:YTNormalPlaceImage];
    NSArray* hnImgArray = shopInfoModel.shopInfo.hjImg;
    if (hnImgArray.count > 0) {
        self.insideImageView.hidden = NO;
        YTImage* insideImage = [hnImgArray firstObject];
        [self.insideImageView sd_setImageWithURL:[NSURL URLWithString:insideImage.img] placeholderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
        if (hnImgArray.count > 1) {
            self.outsideImageView.hidden = NO;
            [self.outsideImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSignTap:)]];
            YTImage* outsideImage = shopInfoModel.shopInfo.hjImg[1];
            [self.outsideImageView sd_setImageWithURL:[NSURL URLWithString:outsideImage.img] placeholderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
            _badgeView = [[JSBadgeView alloc] initWithParentView:_outsideImageView alignment:JSBadgeViewAlignmentBottomRight];
            _badgeView.badgeTextFont = [UIFont systemFontOfSize:12];
            _badgeView.badgeBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            NSString* badgeText = [NSString stringWithFormat:@"%@", @(hnImgArray.count)];
            CGFloat bx = 20 - badgeText.length;
            self.badgeView.badgePositionAdjustment = CGPointMake(-bx, -10);
            _badgeView.badgeText = badgeText;
        }
        else {
            [self.insideImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageSignTap:)]];
        }
    }
    self.shopNameLabel.attributedText = [shopInfoModel.shopInfo.shop nameAttributeStr];
    self.rankImageView.image = [UIImage imageNamed:@"yt_star_level_10.png"];
    self.costLabel.text = [NSString stringWithFormat:@"￥%.2f/人", shopInfoModel.shopInfo.shop.custFee / 100.];
    self.addressView.addressLabel.text = shopInfoModel.shopInfo.shop.address;
    if ([NSStrUtil isEmptyOrNull:shopInfoModel.shopInfo.shop.startTime]) {
        self.timeView.hidden = YES;
    }
    else {
        self.timeView.messageLabel.text = [NSString stringWithFormat:@"%@-%@", shopInfoModel.shopInfo.shop.startTime, shopInfoModel.shopInfo.shop.endTime];
    }

    if (shopInfoModel.shopInfo.shop.parkingSpace == 0) {
        self.parkView.hidden = YES;
    }
    else {
        self.parkView.messageLabel.text = @"商家提供停车位";
    }
}
#pragma mark - Event response
- (void)imageSignTap:(UITapGestureRecognizer*)recognizer
{
    if ([self.delegate respondsToSelector:@selector(shopDetailHeadView:didClickedIndex:)]) {
        [self.delegate shopDetailHeadView:self didClickedIndex:2];
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backImageView];
    [self addSubview:self.insideImageView];
    [self addSubview:self.outsideImageView];
    [self addSubview:self.rankImageView];
    [self addSubview:self.costLabel];
    [self addSubview:self.shopNameLabel];
    [self addSubview:self.addressView];
    [self addSubview:self.addressLine];
    [self addSubview:self.timeView];
    [self addSubview:self.parkView];

    [_backImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(200);
    }];
    [_insideImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(117);
        make.size.mas_equalTo(CGSizeMake(90, 90));
    }];
    [_outsideImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_insideImageView);
        make.top.mas_equalTo(_insideImageView.top).offset(4);
        make.size.mas_equalTo(_insideImageView);
    }];
    [_rankImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(30 + 90);
        make.bottom.mas_equalTo(_backImageView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(76, 12));
    }];
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_rankImageView);
        make.bottom.mas_equalTo(_rankImageView.top).offset(-10);
        make.right.mas_equalTo(self);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_rankImageView.right).offset(10);
        make.centerY.mas_equalTo(_rankImageView);
        make.right.mas_equalTo(self);
    }];
    [_addressView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(_backImageView.bottom).offset(10);
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
        make.height.mas_equalTo([NSStrUtil isEmptyOrNull:_shopInfoModel.shopInfo.shop.startTime] ? 0 : 44);
    }];
    [_parkView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(_timeView);
        make.top.mas_equalTo(_timeView.bottom);
        make.height.mas_equalTo(_shopInfoModel.shopInfo.shop.parkingSpace == 0 ? 0 : 44);
    }];

    wSelf(wSelf);
    _addressView.selectBlock = ^(NSInteger selectIndex) {
        __strong __typeof(wSelf) strongSelf = wSelf;
        if ([strongSelf.delegate respondsToSelector:@selector(shopDetailHeadView:didClickedIndex:)]) {
            [strongSelf.delegate shopDetailHeadView:strongSelf didClickedIndex:selectIndex];
        }
    };
}

#pragma mark - Setter & Getter
- (UIImageView*)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}
- (UIImageView*)insideImageView
{
    if (!_insideImageView) {
        _insideImageView = [[UIImageView alloc] init];
        _insideImageView.backgroundColor = [UIColor clearColor];
        _insideImageView.clipsToBounds = YES;
        _insideImageView.contentMode = UIViewContentModeScaleAspectFill;
        _insideImageView.layer.masksToBounds = YES;
        _insideImageView.layer.cornerRadius = 4;
        _insideImageView.layer.borderWidth = 1;
        _insideImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _insideImageView.userInteractionEnabled = YES;
        _insideImageView.hidden = YES;
    }
    return _insideImageView;
}
- (UIImageView*)outsideImageView
{
    if (!_outsideImageView) {
        _outsideImageView = [[UIImageView alloc] init];
        _outsideImageView.backgroundColor = [UIColor clearColor];
        _outsideImageView.clipsToBounds = YES;
        _outsideImageView.contentMode = UIViewContentModeScaleAspectFill;
        _outsideImageView.layer.masksToBounds = YES;
        _outsideImageView.layer.cornerRadius = 4;
        _outsideImageView.layer.borderWidth = 1;
        _outsideImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _outsideImageView.userInteractionEnabled = YES;
        _outsideImageView.hidden = YES;
    }
    return _outsideImageView;
}
- (UIImageView*)rankImageView
{
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rankImageView;
}

- (UILabel*)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.numberOfLines = 1;
        _shopNameLabel.font = [UIFont systemFontOfSize:15];
        _shopNameLabel.textColor = [UIColor whiteColor];
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
- (UIImageView*)addressLine
{
    if (!_addressLine) {
        _addressLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    }
    return _addressLine;
}
- (ShopDetailSignView*)timeView
{
    if (!_timeView) {
        _timeView = [[ShopDetailSignView alloc] init];
        _timeView.clipsToBounds = YES;
        _timeView.iconImageView.image = [UIImage imageNamed:@"zhq_shop_clock.png"];
        _timeView.leftMargin = 15;
    }
    return _timeView;
}
- (ShopDetailSignView*)parkView
{
    if (!_parkView) {
        _parkView = [[ShopDetailSignView alloc] init];
        _parkView.clipsToBounds = YES;
        _parkView.iconImageView.image = [UIImage imageNamed:@"zhq_shop_park.png"];
    }
    return _parkView;
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
        _messageLabel.textColor = CCCUIColorFromHex(0x666666);
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
