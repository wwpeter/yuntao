#import "OpenHongbaoHeadView.h"
#import "NSStrUtil.h"
#import "UIImageView+YTImageWithURL.h"
#import "YTPublishListModel.h"

@interface OpenHongbaoHeadView ()

@property (nonatomic, strong)UIImageView *bgImageView;
@end

@implementation OpenHongbaoHeadView

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
    [self.hbImageView setYTImageWithURL:[publish.shop.img imageStringWithWidth:200] placeHolderImage:YTNormalPlaceImage];
    self.nameLabel.text = publish.shop.name;
    if (publish.hongbaoLx == YTDistributeHongbaoTypePsqhb) {
        self.hbtypeLabel.text = @"给您发了一个红包,金额随机";
    }else{
        self.hbtypeLabel.text = @"给您发了一个红包";
    }
    self.mesLabel.text = publish.content;
}
- (void)startAnimation
{
    // 自旋转动画
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    rotationAnimation.duration = 2.5;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.openBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (void)endAnimation
{
     [self.openBtn.layer removeAnimationForKey:@"rotationAnimation"];
}
- (void)openButtonDidClicked:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock(self);
    }
    [self startAnimation];
}

#pragma mark - Subviews
- (void)configSubViews
{
    UIView *btnView = [[UIView alloc] init];
    [self addSubview:self.bgImageView];
    [self addSubview:self.hbImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.hbtypeLabel];
    [self addSubview:self.mesLabel];
    [self addSubview:btnView];
    [btnView addSubview:self.openBtn];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.top.mas_equalTo(self);
        make.height.mas_equalTo(300);
    }];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(90);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_hbImageView.bottom).offset(13);
    }];
    [_hbtypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_nameLabel.bottom).offset(5);
    }];
    [_mesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_hbtypeLabel.bottom).offset(10);
    }];
    [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(btnView);
        make.top.mas_equalTo(btnView.bottom).offset(-(96    ));
        make.size.mas_equalTo(CGSizeMake(90, 95));
    }];
}
#pragma mark - Getters & Setters
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        UIImage* bgImage = [[UIImage imageNamed:@"yt_hbhead_background_red.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:2];
        _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
- (UIImageView*)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.layer.masksToBounds = YES;
        _hbImageView.layer.cornerRadius = 50/2;
        _hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hbImageView;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel *)hbtypeLabel
{
    if (!_hbtypeLabel) {
        _hbtypeLabel = [[UILabel alloc] init];
        _hbtypeLabel.textColor = CCCUIColorFromHex(0xFFB2B5);
        _hbtypeLabel.font = [UIFont systemFontOfSize:15];
        _hbtypeLabel.textAlignment = NSTextAlignmentCenter;
        _hbtypeLabel.numberOfLines = 1;
    }
    return _hbtypeLabel;
}
- (UILabel *)mesLabel
{
    if (!_mesLabel) {
        _mesLabel = [[UILabel alloc] init];
        _mesLabel.textColor = [UIColor whiteColor];
        _mesLabel.font = [UIFont systemFontOfSize:18];
        _mesLabel.textAlignment = NSTextAlignmentCenter;
        _mesLabel.numberOfLines = 1;
    }
    return _mesLabel;
}
- (UIButton *)openBtn
{
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openBtn setImage:[UIImage imageNamed:@"openhongbao_btn.png"] forState:UIControlStateNormal];
        [_openBtn addTarget:self action:@selector(openButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}
@end
