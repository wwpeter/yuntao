#import "RGActionView.h"
#import "NSStrUtil.h"
#import "UIView+DKAddition.h"

static const NSInteger kDefaultPadding = 10;

#define RGTextFont [UIFont systemFontOfSize:14]

@implementation RGActionView
- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configureWithTitle:title frame:frame];
    return self;
}

-(void)configureWithTitle:(NSString *)title frame:(CGRect)frame
{
    CGFloat viewWidth = CGRectGetWidth(frame);
    _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 1)];
    _topLine.image = YTlightGrayTopLineImage;
    _topLine.hidden = !_displayTopLine;
    [self addSubview:_topLine];
    
    _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, CGRectGetHeight(frame)-1, viewWidth, 1)];
    _bottomLine.image = YTlightGrayBottomLineImage;
    [self addSubview:_bottomLine];
    
    _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickButton.frame = self.bounds;
    [_clickButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_clickButton];
    
    CGFloat width = [NSStrUtil stringWidthWithString:title stringFont:RGTextFont];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, width, CGRectGetHeight(frame))];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = RGTextFont;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.text = title;
    [self addSubview:_titleLabel];
    
    CGFloat FX = 2*kDefaultPadding+width;
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(FX, 0, CGRectGetWidth(frame)-FX-(2*kDefaultPadding), CGRectGetHeight(frame))];
    _detailLabel.numberOfLines = 2;
    _detailLabel.font = RGTextFont;
    _detailLabel.textColor = [UIColor blackColor];
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_detailLabel];
    
    UIImage *arrowImage = [UIImage imageNamed:@"yt_register_rightArrow.png"];
    CGFloat aY = (CGRectGetHeight(self.bounds) - arrowImage.size.height)/2;
    _arrowView = [[UIImageView alloc] initWithImage:arrowImage];
    _arrowView.frame = CGRectMake(viewWidth-kDefaultPadding-arrowImage.size.width, aY, arrowImage.size.width, arrowImage.size.height);
    [self addSubview:_arrowView];
}
- (void)changeArrowViewImage
{
    UIImage *arrowImage = [UIImage imageNamed:@"yt_register_downArrow.png"];
    CGFloat aY = (CGRectGetHeight(self.bounds) - arrowImage.size.height)/2;
    _arrowView.image = arrowImage;
    _arrowView.frame = CGRectMake(CGRectGetWidth(self.bounds)-kDefaultPadding-arrowImage.size.width, aY, arrowImage.size.width, arrowImage.size.height);
}

#pragma mark - Action
- (void)actionButtonClicked:(id)sender
{
    if (_diversification) {
        if (_didSelect) {
            [self rotateArrow:0];
        } else {
            [self rotateArrow:M_PI];
        }
        _didSelect = !_didSelect;
    }
    if ([_delegate respondsToSelector:@selector(rgactionViewDidClicked:)]) {
        [self.delegate rgactionViewDidClicked:self];
    }
}
- (void)rotateArrow:(CGFloat)degrees {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrowView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}
#pragma mark - Setter
- (void)setLeftMargin:(CGFloat)leftMargin
{
    _leftMargin = leftMargin;
    [_bottomLine setDk_x:leftMargin];
}
- (void)setDisplayTopLine:(BOOL)displayTopLine
{
    _displayTopLine = displayTopLine;
    if (displayTopLine) {
        _topLine.hidden = !displayTopLine;
    }
}
- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrowImage = arrowImage;
    _arrowView.image = arrowImage;
}
- (void)setDiversification:(BOOL)diversification
{
    _diversification = diversification;
    if (diversification) {
        [self changeArrowViewImage];
    }
}
@end
