
#import "VipShowTextView.h"
#import "UIView+BlockGesture.h"

@interface VipShowTextView ()

@property (nonatomic, strong)UIView *bgWhiteView;
@property (nonatomic, strong)UILabel *textLabel;
@end

@implementation VipShowTextView

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
+ (void)showText:(NSString *)text
{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    VipShowTextView *hud = [[VipShowTextView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    hud.textLabel.text = text;
    [view addSubview:hud];
    [hud show];
}
#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.bgWhiteView];
    [self.bgWhiteView addSubview:self.textLabel];
    __weak __typeof(self)weakSelf = self;
    [self addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf hide];
    }];
}
- (void)show
{
    self.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.5];
    [UIView animateWithDuration:0.25f animations:^{
        _bgWhiteView.frame = CGRectMake(15, 60, kDeviceWidth-30, KDeviceHeight-120);
    }];
}
- (void)hide
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
- (UIView *)bgWhiteView
{
    if (!_bgWhiteView) {
        _bgWhiteView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgWhiteView.center = self.center;
        _bgWhiteView.backgroundColor = [UIColor whiteColor];
        _bgWhiteView.clipsToBounds=  YES;
        _bgWhiteView.layer.masksToBounds = YES;
        _bgWhiteView.layer.cornerRadius = 5;
    }
    return _bgWhiteView;
}
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth-50, KDeviceHeight-120)];
        _textLabel.textColor = CCCUIColorFromHex(0x333333);
        _textLabel.font = [UIFont systemFontOfSize:18];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
