

#import "VipIncomTableCell.h"
#import "YTVipIncomeModel.h"

@implementation VipIncomTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configIncomTableCellWithModel:(YTIncome*)income
{
    self.nameLabel.text = [NSString stringWithFormat:@"会员: %@",income.mobile];
    self.costLabel.text = [NSString stringWithFormat:@"%.2f",income.vipShopAmountSum/100.];
    self.mesLabel.text = @"总收益(元)";

    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.costLabel];
    [self.contentView addSubview:self.mesLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(_nameLabel).offset(-8);
            make.width.mas_equalTo(_nameLabel);
        }];
        [_mesLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.mas_equalTo(_costLabel);
            make.width.mas_equalTo(_costLabel);
            make.top.mas_equalTo(_costLabel.bottom).offset(3);
        }];

        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Getters & Setters
- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
- (UILabel*)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.numberOfLines = 1;
        _costLabel.font = [UIFont systemFontOfSize:15];
        _costLabel.textColor = CCCUIColorFromHex(0x333333);
        _costLabel.textAlignment = NSTextAlignmentRight;
        _costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _costLabel;
}
- (UILabel*)mesLabel
{
    if (!_mesLabel) {
        _mesLabel = [[UILabel alloc] init];
        _mesLabel.numberOfLines = 1;
        _mesLabel.font = [UIFont systemFontOfSize:13];
        _mesLabel.textColor = CCCUIColorFromHex(0x999999);
        _mesLabel.textAlignment = NSTextAlignmentRight;
        _mesLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _mesLabel;
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
