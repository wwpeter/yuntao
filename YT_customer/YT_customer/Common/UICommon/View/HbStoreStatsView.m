#import "HbStoreStatsView.h"
#import "UIImage+HBClass.h"
#import "JSBadgeView.h"

@interface HbStoreStatsView ()<UIAlertViewDelegate>

@property (strong, nonatomic) UIButton *statsButton;
@property (strong, nonatomic) UIImageView *verticalLine;
@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) JSBadgeView *badgeView;

@end

@implementation HbStoreStatsView

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
- (void)statsButtonDidClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(hbStoreStatsView:clickedButtonAtIndex:)]) {
        [_delegate hbStoreStatsView:self clickedButtonAtIndex:0];
    }
}
- (void)doneButtonDidClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(hbStoreStatsView:clickedButtonAtIndex:)]) {
        [_delegate hbStoreStatsView:self clickedButtonAtIndex:1];
    }
}

#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.statsButton];
    [self addSubview:self.verticalLine];
    [self addSubview:self.costLabel];
    [self addSubview:self.doneButton];
    
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self.statsButton alignment:JSBadgeViewAlignmentCenterRight];
    self.badgeView.badgeTextFont = [UIFont systemFontOfSize:12];
    UIColor *badgeColor = YTDefaultRedColor;
    self.badgeView.badgeBackgroundColor = [badgeColor colorWithAlphaComponent:0.8];
    
    [_statsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(self);
        make.width.mas_equalTo(65);
        
    }];
    [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_statsButton.right);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(1);
    }];
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self).offset(8);
        make.bottom.mas_equalTo(self).offset(-8);
        make.width.mas_equalTo(115);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_verticalLine).offset(11);
        make.right.mas_equalTo(_doneButton.left);
        make.centerY.mas_equalTo(self);
    }];
}
#pragma mark - Getters & Setters
- (void)setBadgeText:(NSString *)badgeText
{
    _badgeText = badgeText;
    CGFloat bx = 26 - badgeText.length;
    self.badgeView.badgePositionAdjustment = CGPointMake(-bx, -10);
    self.badgeView.badgeText = badgeText;
}
- (void)setCost:(NSString *)cost
{
    _cost = cost;
    _costLabel.text = [NSString stringWithFormat:@"￥%@",cost];
}
- (void)setButtonTitle:(NSString *)buttonTitle
{
    _buttonTitle = buttonTitle;
    [_doneButton setTitle:buttonTitle forState:UIControlStateNormal];
}
- (UIButton *)statsButton
{
    if (!_statsButton) {
        _statsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statsButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [_statsButton setImage:[UIImage imageNamed:@"hb_store_total_icon.png"] forState:UIControlStateNormal];
        [_statsButton addTarget:self action:@selector(statsButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statsButton;
}
- (UIImageView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIImageView alloc] initWithImage:YTlightGrayLineImage];
        _verticalLine.alpha = 0.8f;
    }
    return _verticalLine;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = [UIColor whiteColor];
        _costLabel.font = [UIFont boldSystemFontOfSize:20];
        _costLabel.numberOfLines = 1;
    }
    return _costLabel;
}
- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.layer.masksToBounds = YES;
        _doneButton.layer.cornerRadius = 3;
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_doneButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_doneButton setTitle:@"选好了" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}
@end
