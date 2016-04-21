

#import "HbDetailHeadView.h"
#import "YTDrainageDetailModel.h"

static const NSInteger kDefaultPadding = 15;

@implementation HbDetailHeadView

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
- (void)configDetailHeadViewWithUsrHongBao:(YTUsrHongBao *)hongbao
{
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:kDeviceCurrentWidth]placeHolderImage:[UIImage imageNamed:@"hb_detail_placeImage.png"]];
    if (hongbao.status != YTDRAINAGESTATUS_PASS) {
        self.statusImageView.image = [UIImage imageNamed:[YTTaskHandler hbDetailStatusImageNameWithCommon:hongbao.status]];
    }
//    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",hongbao.name,hongbao.cost/100.];
//    self.shopLabel.text = hongbao.shop.name;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",hongbao.name];
    self.shopLabel.text = [NSString stringWithFormat:@"价值%.2f元",hongbao.cost/100.];
}
- (void)configDetailHeadViewWithCommonHongBao:(YTCommonHongBao *)hongbao
{
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:kDeviceCurrentWidth] placeHolderImage:[UIImage imageNamed:@"yt_normalplaceImage.png"]];
    self.statusImageView.image = [UIImage imageNamed:[YTTaskHandler hbDetailStatusImageNameWithCommon:hongbao.status]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",hongbao.name];
//    self.shopLabel.text = [NSString stringWithFormat:@"价值%.2f元",hongbao.cost/100.];
    self.shopLabel.text = hongbao.shop.name;
}

#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.hbImageView];
    [self addSubview:self.statusImageView];
    [self addSubview:self.shopIconImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.shopLabel];
    
    [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(200);
    }];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(81, 81));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.top.mas_equalTo(_hbImageView.bottom).offset(kDefaultPadding);
        make.right.mas_equalTo(self);
    }];
    [_shopIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.top.mas_equalTo(_nameLabel.bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(16, 15));
    }];
    [_shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_shopIconImageView.right).offset(2);
        make.centerY.mas_equalTo(_shopIconImageView);
        make.right.mas_equalTo(self);
    }];
}
#pragma mark - Setter & Getter
- (UIImageView *)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.clipsToBounds = YES;
        _hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hbImageView;
}
- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
    }
    return _statusImageView;
}
- (UIImageView *)shopIconImageView
{
    if (!_shopIconImageView) {
        _shopIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_store_smallicon_02.png"]];
    }
    return _shopIconImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (UILabel *)shopLabel
{
    if (!_shopLabel) {
        _shopLabel = [[UILabel alloc] init];
        _shopLabel.numberOfLines = 1;
        _shopLabel.font = [UIFont systemFontOfSize:14];
        _shopLabel.textColor = CCCUIColorFromHex(0x999999);
        _shopLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _shopLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _shopLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
