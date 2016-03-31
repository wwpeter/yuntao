#import "ShopDetailPayTableCell.h"
#import "UIImage+HBClass.h"

@implementation ShopDetailPayTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
- (void)showDiscountPay:(NSInteger)discount
{
    self.buyLabel.text = [NSString stringWithFormat:@"折扣买单 %.1f折",discount / 10.];
    self.payType = PreferencePayTypeDiscount;
}
- (void)showHongbaoPay
{
    self.buyLabel.text = @"红包可抵现金买单";
    self.payType = PreferencePayTypeHongbao;
}
#pragma mark - Event response
- (void)payButtonClicked:(id)sender
{
    if (self.payBlock) {
        self.payBlock(_payType);
    }
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.buyLabel];
    [self.contentView addSubview:self.payButton];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_payButton mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(_iconImageView);
            make.size.mas_equalTo(CGSizeMake(120, 36));
        }];
        [_buyLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_iconImageView.right).offset(10);
            make.centerY.mas_equalTo(_iconImageView);
            make.right.mas_equalTo(_payButton.left).priorityLow();
        }];

        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}
#pragma mark - Setter & Getter
- (void)setPayType:(PreferencePayType)payType
{
    _payType = payType;
    if (payType == PreferencePayTypeDiscount) {
        self.iconImageView.image = [UIImage imageNamed:@"yt_zheIcon_02.png"];
        [self.payButton setBackgroundImage:[UIImage createImageWithColor:CCCUIColorFromHex(0xffb200)] forState:UIControlStateNormal];
        [self.payButton setTitle:@"折扣买单" forState:UIControlStateNormal];
    }
    else if (payType == PreferencePayTypeHongbao) {
        self.iconImageView.image = [UIImage imageNamed:@"yt_hongIcon_02.png"];
        [self.payButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [self.payButton setTitle:@"红包抵扣" forState:UIControlStateNormal];
    }
    else {
        self.iconImageView.image = [UIImage imageNamed:@"yt_redPayIcon.png"];
        [self.payButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [self.payButton setTitle:@"我要买单" forState:UIControlStateNormal];
    }

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UILabel*)buyLabel
{
    if (!_buyLabel) {
        _buyLabel = [[UILabel alloc] init];
        _buyLabel.textColor = [UIColor blackColor];
        _buyLabel.font = [UIFont systemFontOfSize:15];
        _buyLabel.numberOfLines = 1;
    }
    return _buyLabel;
}
- (UIButton*)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.layer.masksToBounds = YES;
        _payButton.layer.cornerRadius = 2;
        _payButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage createImageWithColor:YTDefaultRedColor] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(payButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
