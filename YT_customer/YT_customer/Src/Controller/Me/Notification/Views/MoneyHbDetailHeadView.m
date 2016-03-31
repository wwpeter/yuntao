#import "MoneyHbDetailHeadView.h"
#import "NSStrUtil.h"
#import "UIImageView+YTImageWithURL.h"
#import "YTPublishListModel.h"

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
- (void)configHbDetailWithModel:(YTPublish *)publish
{
    [self.hbImageView setYTImageWithURL:[publish.shop.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.nameLabel.attributedText = [publish nameAttributedString];
    self.mesLabel.text = publish.content;
}
- (void)hideCostView
{
    self.costLabel.hidden = YES;
    self.wordLabel.hidden = YES;
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    UIImageView *backgroundImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"distribute_hbDetail_background.png"]];
    [self addSubview:backgroundImg];
    [self addSubview:self.hbImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.mesLabel];
    [self addSubview:self.costLabel];
    [self addSubview:self.wordLabel];
    
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
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_mesLabel.bottom).offset(10);
    }];
    [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-20);
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
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel *)mesLabel
{
    if (!_mesLabel) {
        _mesLabel = [[UILabel alloc] init];
        _mesLabel.textColor = CCCUIColorFromHex(0x666666);
        _mesLabel.font = [UIFont systemFontOfSize:15];
        _mesLabel.textAlignment = NSTextAlignmentCenter;
        _mesLabel.numberOfLines = 1;
    }
    return _mesLabel;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x333333);
        _costLabel.font = [UIFont systemFontOfSize:52];
        _costLabel.textAlignment = NSTextAlignmentCenter;
        _costLabel.numberOfLines = 1;
    }
    return _costLabel;
}
- (UILabel *)wordLabel
{
    if (!_wordLabel) {
        _wordLabel = [[UILabel alloc] init];
        _wordLabel.textColor = CCCUIColorFromHex(0x2F83FF);
        _wordLabel.font = [UIFont systemFontOfSize:14];
        _wordLabel.textAlignment = NSTextAlignmentCenter;
        _wordLabel.numberOfLines = 1;
        _wordLabel.text = @"已存入余额,可直接使用或体现";
    }
    return _wordLabel;
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
