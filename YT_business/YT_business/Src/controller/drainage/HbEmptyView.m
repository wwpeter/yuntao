#import "HbEmptyView.h"

static const NSInteger kDefaultPadding = 10;

@interface HbEmptyView ()

@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIView *centerView;

@end

@implementation HbEmptyView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self configSubviews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self configSubviews];
    return self;
}
- (void)configSubviews
{
    self.centerView = [[UIView alloc] init];
    [self addSubview:self.centerView];
    
    self.iconImageView = [[UIImageView alloc] init];
    [self.centerView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.centerView addSubview:self.titleLabel];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textColor = [UIColor grayColor];
    self.descriptionLabel.font = [UIFont systemFontOfSize:15];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.centerView addSubview:self.descriptionLabel];
    
    
    UIImage *arrowImage = [UIImage imageNamed:iPhone4?@"hbEmptyDownArrow_4.png":@"hbEmptyDownArrow.png"];
    self.arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    self.arrowImageView.hidden = !self.displayArrow;
    [self addSubview:self.arrowImageView];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(-50);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(200);
    }];
    //    CGFloat topHeight = iPhone4? 80:kIconTopPadding;
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_centerView);
        make.top.mas_equalTo(_centerView);
        make.size.mas_equalTo(CGSizeMake(130, 130));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_iconImageView.bottom).offset(2*kDefaultPadding);
        make.left.right.mas_equalTo(self);
    }];
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.bottom).offset(5);
        make.left.right.mas_equalTo(self);
    }];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_centerView.bottom).offset(3);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(arrowImage.size);
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.frame);
    [super layoutSubviews];
}

#pragma mark - Getters & Setters
- (void)setDisplayArrow:(BOOL)displayArrow
{
    _displayArrow = displayArrow;
    self.arrowImageView.hidden = !displayArrow;
}
- (void)setYOffset:(NSInteger)yOffset
{
    _yOffset = yOffset;
    [_centerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(self).offset(yOffset);
    }];
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}
- (void)setDescriptionColor:(UIColor *)descriptionColor
{
    _descriptionColor = descriptionColor;
    self.descriptionLabel.textColor = descriptionColor;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
