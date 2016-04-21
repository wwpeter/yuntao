#import "YTHorizontalHeadView.h"
#import "YTUpdoTextView.h"

@interface YTHorizontalHeadView () {
    NSMutableArray* _updoViews;
}

@end
@implementation YTHorizontalHeadView
- (instancetype)initWithNumercals:(NSArray<YTNumerical>*)numercals
{
    if ((self = [self init])) {
        _numercals = numercals;
        _updoViews = [[NSMutableArray alloc] initWithCapacity:1];
        [self configSubViews];
    }
    return self;
}
- (void)reloadNumercals:(NSArray<YTNumerical>*)numercals
{
    _numercals = numercals;
    for (NSInteger i = 0; i < numercals.count; i++) {
        if (i >= _updoViews.count) {
            return;
        }
        YTUpdoTextView* updoView = _updoViews[i];
        YTNumerical* numerica = numercals[i];
        updoView.upLabel.text = numerica.caption;
        updoView.downLabel.text = numerica.message;
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    YTUpdoTextView* lastView;

    CGFloat viewWidth = kDeviceWidth / self.numercals.count;
    for (YTNumerical* numercal in self.numercals) {
        YTUpdoTextView* updoView = [[YTUpdoTextView alloc] init];
        updoView.upLabel.text = numercal.caption;
        updoView.downLabel.text = numercal.message;
        [self addSubview:updoView];
        [_updoViews addObject:updoView];
        [updoView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(lastView ? lastView.right : @0);
            make.width.equalTo(@(viewWidth));
        }];
        lastView = updoView;
    }
}

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
    
    CGFloat width = CGRectGetWidth(rect)/_numercals.count;
    for (NSInteger i = 1; i < _numercals.count; i++) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(i*width, 12)];
        [bezierPath addLineToPoint:CGPointMake(i*width, CGRectGetHeight(rect)-12)];
        [ccColor setStroke];
        [bezierPath setLineWidth:1.0];
        [bezierPath stroke];
    }
}

@end

@implementation YTNumerical
- (instancetype)initWithCaption:(NSString*)caption message:(NSString*)message
{
    if ((self = [super init])) {
        _caption = caption;
        _message = message;
    }
    return self;
}
@end