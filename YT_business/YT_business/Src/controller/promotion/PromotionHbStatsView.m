#import "PromotionHbStatsView.h"
#import "UIImage+HBClass.h"

@interface PromotionHbStatsView ()

@property (strong, nonatomic) UILabel *costLabel;
@property (strong, nonatomic) UIButton *doneButton;
@end
@implementation PromotionHbStatsView

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
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self addSubview:self.costLabel];
    [self addSubview:self.doneButton];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self).offset(6);
        make.bottom.mas_equalTo(self).offset(-6);
        make.width.mas_equalTo(120);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(_doneButton.left);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - Event response
- (void)doneButtonDidClicked:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}
#pragma mark - Getters & Setters
- (void)setCost:(NSString *)cost
{
    _cost = cost;
    _costLabel.text = [NSString stringWithFormat:@"￥%@",cost];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
