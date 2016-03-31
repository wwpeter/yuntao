#import "CHbDetailAddressView.h"

static const NSInteger kDefaultPadding = 15;

@implementation CHbDetailAddressView

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
- (void)addressTapGesture:(UITapGestureRecognizer *)tap
{
    if (self.selectBlock) {
        self.selectBlock(1);
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTapGesture:)]];
    [self addSubview:self.titleLabel];
    [self addSubview:self.shopLabel];
    [self addSubview:self.addressIcon];
    [self addSubview:self.addressLabel];
    [self addSubview:self.phoneButton];
    [self addSubview:self.verticalLine];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(self);
    }];
    
    [_phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.bottom.right.mas_equalTo(self);
        make.width.mas_equalTo(57);
    }];
    [_verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.bottom.mas_equalTo(-kDefaultPadding);
        make.right.mas_equalTo(_phoneButton.left);
        make.width.mas_equalTo(1);
    }];
    
    [_shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(_verticalLine.left).priorityHigh();
    }];
    
    [_addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.top.mas_equalTo(_shopLabel.bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(14, 16));
    }];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_addressIcon.right).offset(5);
        make.centerY.mas_equalTo(_addressIcon);
        make.right.mas_equalTo(_verticalLine.left).priorityHigh();
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 20 + 10 + 14 + 10 + 1
    self.addressLabel.preferredMaxLayoutWidth = kDeviceWidth-58-55;
    [super layoutSubviews];
}
#pragma mark - Setter & Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text= @"商家信息";
    }
    return _titleLabel;
}
- (UILabel *)shopLabel
{
    if (!_shopLabel) {
        _shopLabel = [[UILabel alloc] init];
        _shopLabel.numberOfLines = 1;
        _shopLabel.font = [UIFont systemFontOfSize:14];
        _shopLabel.textColor = CCCUIColorFromHex(0x333333);
        _shopLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _shopLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _shopLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = UILabel.new;
        _addressLabel.numberOfLines = 2;
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = CCCUIColorFromHex(0x999999);
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

- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(15, 40)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 40)];
    [ccColor setStroke];
    [bezierPath setLineWidth:0.5f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
