
#import "YTStatisticsHeadView.h"

@implementation YTStatisticsHeadView

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

#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftOnView];
    [self addSubview:self.leftTwView];
    [self addSubview:self.rightOnView];
    [self addSubview:self.rightTwView];
    [_leftOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.25f);
    }];
    [_leftTwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(_leftOnView.right);
        make.width.mas_equalTo(_leftOnView);
    }];
    [_rightTwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(_leftOnView);
    }];
    [_rightOnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(_leftTwView.right);
        make.right.mas_equalTo(_rightTwView.left);
    }];
}
#pragma mark - Setter & Getter
- (YTUpdoTextView*)leftOnView
{
    if (!_leftOnView) {
        _leftOnView = [[YTUpdoTextView alloc] init];
        _leftOnView.downLabel.text = @"创建数";
    }
    return _leftOnView;
}
- (YTUpdoTextView*)leftTwView
{
    if (!_leftTwView) {
        _leftTwView = [[YTUpdoTextView alloc] init];
        _leftTwView.downLabel.text = @"投放数";
    }
    return _leftTwView;
}
- (YTUpdoTextView*)rightOnView
{
    if (!_rightOnView) {
        _rightOnView = [[YTUpdoTextView alloc] init];
        _rightOnView.downLabel.text = @"领取数";
    }
    return _rightOnView;
}
- (YTUpdoTextView*)rightTwView
{
    if (!_rightTwView) {
        _rightTwView = [[YTUpdoTextView alloc] init];
        _rightTwView.downLabel.text = @"引流数";
    }
    return _rightTwView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    UIColor *ccColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    UIBezierPath *bezierPath;
    if (_displayTopLine) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0, 0)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),0)];
        [ccColor  setStroke];
        [bezierPath setLineWidth:1.0f];
        [bezierPath stroke];
    }

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),CGRectGetHeight(rect))];
    [ccColor  setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    CGFloat width = CGRectGetWidth(rect)/4;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(width, 12)];
    [bezierPath addLineToPoint:CGPointMake(width, CGRectGetHeight(rect)-12)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(2*width, 12)];
    [bezierPath addLineToPoint:CGPointMake(2*width, CGRectGetHeight(rect)-12)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(3*width, 12)];
    [bezierPath addLineToPoint:CGPointMake(3*width, CGRectGetHeight(rect)-12)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
