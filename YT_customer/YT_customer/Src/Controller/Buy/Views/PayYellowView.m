
#import "PayYellowView.h"

@implementation PayYellowView

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

- (void)configSubViews
{
    self.backgroundColor = CCCUIColorFromHex(0xfff7d8);
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    UIColor* ccColor = CCCUIColorFromHex(0xdfd2a5);
    self.layer.borderColor = [ccColor CGColor];
    self.layer.cornerRadius = 2.0;
    
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
    }];
}
- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CCCUIColorFromHex(0xc1950e);
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.numberOfLines = 1;
        _leftLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _leftLabel;
}
- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = CCCUIColorFromHex(0xc1950e);
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.numberOfLines = 1;
        _rightLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
