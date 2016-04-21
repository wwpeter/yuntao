#import "LeftSideHeadView.h"

static const NSInteger kDefaultPadding = 25;

@implementation LeftSideHeadView

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
- (void)handleSignTap:(UITapGestureRecognizer*)recognizer
{
    if ([self.delegate respondsToSelector:@selector(leftSideHeadViewDidTap:)]) {
        [self.delegate leftSideHeadViewDidTap:self];
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignTap:)]];
    [self addSubview:self.arrowImageView];
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_leftSide_downline.png"]];
    [self addSubview:lineImageView];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.bottom.mas_equalTo(-30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headImageView.right).offset(10);
        make.centerY.mas_equalTo(_headImageView);
        // 7+kDefaultPadding
        make.right.mas_equalTo(self).offset(-(kDefaultPadding+7));
    }];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-kDefaultPadding);
        make.centerY.mas_equalTo(_headImageView);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(kDefaultPadding);
        make.right.mas_equalTo(self).offset(-kDefaultPadding);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(1);                                                                                                                                                                     
    }];
}
#pragma mark - Setter&Getter
- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.clipsToBounds = YES;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 60/2;
    }
    return _headImageView;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_leftSideIcon_arrow.png"]];
    }
    return _arrowImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
