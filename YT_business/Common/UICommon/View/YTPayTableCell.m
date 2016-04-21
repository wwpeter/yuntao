#import "YTPayTableCell.h"

static const NSInteger kLeftPadding = 15;

@implementation YTPayTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(kLeftPadding);
            make.centerY.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 36));
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_iconImageView.right).offset(kLeftPadding);
            make.top.mas_equalTo(kLeftPadding - 5);
            make.right.mas_equalTo(-40);

        }];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(_titleLabel);
            make.top.mas_equalTo(_titleLabel.bottom).offset(5);
            make.right.mas_equalTo(-40);
        }];

        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - Getters & Setters
- (void)setPayType:(int)payType
{
    _payType = payType;
    if (payType == YTPayTypeZfb) {
        _titleLabel.text = @"支付宝支付";
        _messageLabel.text = @"支持有支付宝、网银的用户使用";
        _iconImageView.image = [UIImage imageNamed:@"yt_payType_zfb.png"];
    }
    else {
        _titleLabel.text = @"微信支付";
        _messageLabel.text = @"支持安装微信5.0以上版本的用户使用";
        _iconImageView.image = [UIImage imageNamed:@"yt_payType_wx.png"];
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (UIImageView*)iconImageView
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
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UILabel*)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = CCCUIColorFromHex(0x999999);
        _messageLabel.font = [UIFont systemFontOfSize:14];
        _messageLabel.numberOfLines = 1;
    }
    return _messageLabel;
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
