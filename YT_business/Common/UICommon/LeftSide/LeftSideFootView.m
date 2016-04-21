#import "LeftSideFootView.h"

static const NSInteger kDefaultPadding = 25;

@implementation LeftSideFootView

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
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(kDefaultPadding);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(kLeftDefaultSideWidth/2);
    }];
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.width.mas_equalTo(_leftButton);
        make.right.mas_equalTo(-kDefaultPadding);
    }];
}



#pragma mark - Events respones
-(void)buttonTap:(UIButton *)button
{
    [_delegate leftSideFootViewDidTap:button];
}

#pragma mark - Setter & Getter
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -62, 0, 0);
        _leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton setTitle:@"消息" forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"zhq_leftSideIcon_message_red.png"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        _rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 62, 0, 0);
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"设置" forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"yt_leftSideIcon_setting.png"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetWidth(rect)/2, kDefaultPadding)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)-2)];
    [[UIColor colorWithWhite:197.0/255.0 alpha:0.3] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
