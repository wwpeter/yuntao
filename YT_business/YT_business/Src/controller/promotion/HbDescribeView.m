#import "HbDescribeView.h"

static const NSInteger kLeftPadding = 15;
static const NSInteger kTopPadding = 10;

@implementation HbDescribeView

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
    [self addSubview:self.hbImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.describeLabel];
    
    [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.top.mas_equalTo(kTopPadding);
        make.bottom.mas_equalTo(-kTopPadding);
        make.width.mas_equalTo(_hbImageView.height);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_hbImageView.right).offset(kTopPadding);
        make.top.mas_equalTo(_hbImageView).offset(6);
        make.right.mas_equalTo(self);
    }];
    [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel);
        make.top.mas_equalTo(_nameLabel.bottom).offset(kTopPadding-3);
        make.right.mas_equalTo(self);
    }];

}

#pragma mark - Setter & Getter
- (UIImageView *)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.layer.masksToBounds = YES;
        _hbImageView.layer.cornerRadius = 2;
        _hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hbImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = CCCUIColorFromHex(0x999999);
        _describeLabel.font = [UIFont systemFontOfSize:14];
        _describeLabel.numberOfLines = 1;
    }
    return _describeLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
