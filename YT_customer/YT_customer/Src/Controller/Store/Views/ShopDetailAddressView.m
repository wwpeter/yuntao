#import "ShopDetailAddressView.h"

static const NSInteger kDefaultPadding = 15;

@implementation ShopDetailAddressView

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
- (void)phoneButtonClicked:(id)sender
{
    if (self.selectBlock) {
        self.selectBlock(0);
    }
}
#pragma mark - Event response
- (void)addressViewTap:(UITapGestureRecognizer*)tap
{
    if (self.selectBlock) {
        self.selectBlock(1);
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.addressIcon];
    [self addSubview:self.addressLabel];
    [self addSubview:self.phoneButton];
    [self addSubview:self.verticalLine];
    [_addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(14, 16));
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_addressIcon.right).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(57);
    }];
    [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kDefaultPadding);
        make.bottom.mas_equalTo(-kDefaultPadding);
        make.right.mas_equalTo(_phoneButton.left);
        make.width.mas_equalTo(1);
    }];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressViewTap:)]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 20 + 10 + 14 + 10 + 1
    self.addressLabel.preferredMaxLayoutWidth = kDeviceWidth-58-55;
    [super layoutSubviews];
}
#pragma mark - Setter & Getter
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = UILabel.new;
        _addressLabel.numberOfLines = 2;
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = CCCUIColorFromHex(0x666666);
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _addressLabel;
}

- (UIImageView *)addressIcon
{
    if (!_addressIcon) {
        _addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_store_location.png"]];
    }
    return _addressIcon;
}
- (UIButton *)phoneButton
{
    if (!_phoneButton) {
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setImage:[UIImage imageNamed:@"yt_store_phone.png"] forState:UIControlStateNormal];
        [_phoneButton addTarget:self action:@selector(phoneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneButton;
}
- (UIImageView *)verticalLine
{
    if (!_verticalLine) {
        _verticalLine = [[UIImageView alloc] initWithImage:YTlightGrayLineImage];
    }
    return _verticalLine;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
