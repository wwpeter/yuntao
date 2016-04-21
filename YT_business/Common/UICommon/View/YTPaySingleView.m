#import "YTPaySingleView.h"

static const NSInteger kLeftPadding = 15;

@implementation YTPaySingleView

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

- (void)accessoryButtonDidClicked:(UIButton *)sender
{
    [self.delegate paySingleView:self didSelectAccessoryButton:sender];
}
#pragma mark - Public methods
#pragma mark - Private methods
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.separatorMargin = 0;
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.accessoryButton];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImageView.right).offset(kLeftPadding);
        make.top.mas_equalTo(kLeftPadding-5);
        make.right.mas_equalTo(-40);
        
    }];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.bottom).offset(5);
        make.right.mas_equalTo(-40);
    }];
    [_accessoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kLeftPadding);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
}

#pragma mark - Getters & Setters
- (void)setChoiced:(BOOL)choiced
{
    _choiced = choiced;
    _accessoryButton.selected = choiced;
    _accessoryButton.userInteractionEnabled =!choiced;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 2;
    }
    return _iconImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = CCCUIColorFromHex(0x999999);
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 1;
    }
    return _messageLabel;
}
- (UIButton *)accessoryButton
{
    if (!_accessoryButton) {
        _accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accessoryButton setImage:[UIImage imageNamed:@"yt_cell_left_normal.png"] forState:UIControlStateNormal];
        [_accessoryButton setImage:[UIImage imageNamed:@"yt_cell_left_select.png"] forState:UIControlStateSelected];
        [_accessoryButton addTarget:self action:@selector(accessoryButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accessoryButton;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(_separatorMargin, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}


@end
