


#import "UIView+DKAddition.h"
#import "YTDrainageDetailModel.h"
#import "DrainageDetailTableHeadView.h"

@interface DrainageDetailTableHeadView ()
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UILabel *bottomLeftLabel;
@property (strong, nonatomic) UILabel *bottomCenterLabel;
@property (strong, nonatomic) UILabel *bottomRightLabel;
@end
@implementation DrainageDetailTableHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureSubview:frame];
    }
    return self;
}
#pragma mark - Public methods
- (void)configDrainageDetailHeadViewWithModel:(YTDrainageDetail *)drainageDetail
{
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",drainageDetail.hongbao.name,drainageDetail.hongbao.cost/100.];
    self.statusLabel.text = [YTTaskHandler outDrainageStatusStrWithStatus:drainageDetail.hongbao.status];
    self.throwLabel.text = [NSString stringWithFormat:@"%d",drainageDetail.touCount];
    self.pullLabel.text = [NSString stringWithFormat:@"%d",drainageDetail.lingCount];
    self.leadLabel.text = [NSString stringWithFormat:@"%d",drainageDetail.yinCount];
    self.bottomLeftLabel.text = @"投放红包";
    self.bottomCenterLabel.text = @"领取人数";
    self.bottomRightLabel.text = @"引流人数";
}
#pragma mark - Event response
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(drainageDetailHeadViewDidTap:)])
        [self.delegate drainageDetailHeadViewDidTap:self];

}
#pragma mark - Subviews
- (void)configureSubview:(CGRect)frame
{
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backImageView.image = [UIImage imageNamed:@"hb_throw_redBackground.png"];
    [self addSubview:backImageView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 44)];
    [self addSubview:topView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [self addGestureRecognizer:singleTap];

    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-17, 16, 7, 12)];
    arrowImageView.image = [UIImage imageNamed:@"yt_cell_rightWhiteArrow.png"];
    [topView addSubview:arrowImageView];
    
    UIImageView *horizontalLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43, viewWidth, 1)];
    horizontalLine.image = YTlightGrayBottomLineImage;
    [topView addSubview:horizontalLine];
    
    UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/3, 70, 1, 50)];
    verticalLine.image = YTlightGrayLineImage;
    [self addSubview:verticalLine];
    
    UIImageView *verticalLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(2*(viewWidth/3), 70, 1, 50)];
    verticalLine2.image = YTlightGrayLineImage;
    [self addSubview:verticalLine2];
    
    [topView addSubview:self.nameLabel];
    [topView addSubview:self.statusLabel];
    [self addSubview:self.throwLabel];
    [self addSubview:self.pullLabel];
    [self addSubview:self.leadLabel];
    [self addSubview:self.bottomLeftLabel];
    [self addSubview:self.bottomCenterLabel];
    [self addSubview:self.bottomRightLabel];

}
#pragma mark - Setter & Getter
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kDeviceWidth-125, 44)];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-105, 0, 80, 44)];
        _statusLabel.numberOfLines = 1;
        _statusLabel.font = [UIFont systemFontOfSize:16];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UILabel *)throwLabel
{
    if (!_throwLabel) {
        CGFloat width = CGRectGetWidth(self.bounds)/3;
        _throwLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, width, 30)];
        _throwLabel.numberOfLines = 1;
        _throwLabel.font = [UIFont boldSystemFontOfSize:25];
        _throwLabel.textColor = [UIColor whiteColor];
        _throwLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _throwLabel;
}
- (UILabel *)pullLabel
{
    if (!_pullLabel) {
        CGFloat width = CGRectGetWidth(self.bounds)/3;
        _pullLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 66, width, 30)];
        _pullLabel.numberOfLines = 1;
        _pullLabel.font = [UIFont boldSystemFontOfSize:25];
        _pullLabel.textColor = [UIColor whiteColor];
        _pullLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pullLabel;
}
- (UILabel *)leadLabel
{
    if (!_leadLabel) {
        CGFloat width = CGRectGetWidth(self.bounds)/3;
        _leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*width, 66, width, 30)];
        _leadLabel.numberOfLines = 1;
        _leadLabel.font = [UIFont boldSystemFontOfSize:25];
        _leadLabel.textColor = [UIColor whiteColor];
        _leadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leadLabel;
}
- (UILabel *)bottomLeftLabel
{
    if (!_bottomLeftLabel) {
        _bottomLeftLabel = [[UILabel alloc] initWithFrame:self.throwLabel.frame];
        _bottomLeftLabel.dk_y = 96;
        _bottomLeftLabel.numberOfLines = 1;
        _bottomLeftLabel.font = [UIFont systemFontOfSize:14];
        _bottomLeftLabel.textColor = [UIColor whiteColor];
        _bottomLeftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLeftLabel;
}
- (UILabel *)bottomCenterLabel
{
    if (!_bottomCenterLabel) {
        _bottomCenterLabel = [[UILabel alloc] initWithFrame:self.pullLabel.frame];
        _bottomCenterLabel.dk_y = 96;
        _bottomCenterLabel.numberOfLines = 1;
        _bottomCenterLabel.font = [UIFont systemFontOfSize:14];
        _bottomCenterLabel.textColor = [UIColor whiteColor];
        _bottomCenterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomCenterLabel;
}
- (UILabel *)bottomRightLabel
{
    if (!_bottomRightLabel) {
        _bottomRightLabel = [[UILabel alloc] initWithFrame:self.leadLabel.frame];
        _bottomRightLabel.dk_y = 96;
        _bottomRightLabel.numberOfLines = 1;
        _bottomRightLabel.font = [UIFont systemFontOfSize:14];
        _bottomRightLabel.textColor = [UIColor whiteColor];
        _bottomRightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomRightLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
