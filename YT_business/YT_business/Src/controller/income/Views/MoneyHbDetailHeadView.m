#import "MoneyHbDetailHeadView.h"
#import "YTVipManageModel.h"

@interface MoneyHbDetailHeadView ()

@end

@implementation MoneyHbDetailHeadView
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
- (void)configHbDetailWithModel:(YTVipManage *)vipManage
{
    NSString* imgUrl = [YTUsr usr].shop.img;
    [self.hbImageView setYTImageWithURL:[imgUrl imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.nameLabel.attributedText = [vipManage nameAttributedString];
    self.mesLabel.text = @"商户留言,商户留言";
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"distribute_hbDetail_background.png"]];
    [self addSubview:backgroundImg];
    [self addSubview:self.hbImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.mesLabel];
    
    [backgroundImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(149);
    }];
    [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(backgroundImg.bottom).offset(-38);
        make.size.mas_equalTo(CGSizeMake(76, 76));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_hbImageView.bottom).offset(13);
    }];
    [_mesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_nameLabel.bottom).offset(5);
    }];
}
#pragma mark - Getters & Setters
- (UIImageView*)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.layer.masksToBounds = YES;
        _hbImageView.layer.cornerRadius = 76/2;
        _hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hbImageView;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel *)mesLabel
{
    if (!_mesLabel) {
        _mesLabel = [[UILabel alloc] init];
        _mesLabel.textColor = [UIColor blackColor];
        _mesLabel.font = [UIFont systemFontOfSize:15];
        _mesLabel.textAlignment = NSTextAlignmentCenter;
        _mesLabel.numberOfLines = 1;
    }
    return _mesLabel;
}
- (void)drawRect:(CGRect)rect {
    
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
}

@end
