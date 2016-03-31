
#import "PrEmptyView.h"

@interface PrEmptyView ()

@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation PrEmptyView

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
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.iconImageView = [[UIImageView alloc] init];
    [self addSubview:self.iconImageView];
    

    UIImage *arrowImage = [UIImage imageNamed:@"pr_empty_arrow.png"];
    self.arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    self.arrowImageView.hidden = !self.displayArrow;
    [self addSubview:self.arrowImageView];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-30);
        make.size.mas_equalTo(arrowImage.size);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_arrowImageView.bottom).offset(15);
        make.left.right.mas_equalTo(self);
    }];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_titleLabel.bottom).offset(55);
        make.size.mas_equalTo(CGSizeMake(130, 130));
    }];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    [super layoutSubviews];
}

#pragma mark - Getters & Setters
- (void)setDisplayArrow:(BOOL)displayArrow
{
    _displayArrow = displayArrow;
    self.arrowImageView.hidden = !displayArrow;
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
