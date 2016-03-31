#import "SearchHbDetailTableCell.h"
#import "YTHbShopModel.h"
#import <UIImageView+WebCache.h>
#import "NSStrUtil.h"

static const NSInteger kDefaultPadding = 10;

@implementation SearchHbDetailTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configSearchHbDetailCellWithModel:(YTHbShopModel *)shopModel
{
        [self.shopImageView sd_setImageWithURL:[shopModel.img imageUrlWithWidth:200] placeholderImage:YTNormalPlaceImage];
    self.nameLabel.attributedText = [shopModel nameAttributeStr];
    self.discountLabel.attributedText = [shopModel discountAttributed];
    NSString *costStr = [NSString stringWithFormat:@"￥%.2f/%@", shopModel.custFee/100., @"人"];
    self.costLabel.text = [NSString stringWithFormat:@"%@ %@",shopModel.catName,costStr];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",shopModel.zoneText,[shopModel userLocationDistance]];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.shopImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.costLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.discountLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kDefaultPadding);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_shopImageView).offset(2);
            make.left.mas_equalTo(_shopImageView.right).offset(kDefaultPadding);
            make.right.mas_equalTo(self.contentView);
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel);
            make.top.mas_equalTo(_nameLabel.bottom).offset(8);
            make.right.mas_equalTo(self.contentView).offset(-90);
        }];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel);
            make.right.mas_equalTo(_costLabel);
            make.top.mas_equalTo(_costLabel.bottom).offset(8);
        }];
        [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-kDefaultPadding);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(90);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}
#pragma mark - Getters & Setters
- (UIImageView *)shopImageView
{
    if (!_shopImageView) {
        _shopImageView = [[UIImageView alloc] init];
        _shopImageView.clipsToBounds = YES;
        _shopImageView.layer.masksToBounds = YES;
        _shopImageView.layer.cornerRadius = 2;
        _shopImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _shopImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.numberOfLines = 1;
        _costLabel.font = [UIFont systemFontOfSize:12];
        _costLabel.textColor = CCCUIColorFromHex(0x333333);
        _costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _costLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 1;
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textColor = CCCUIColorFromHex(0x999999);
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _addressLabel;
}
- (UILabel *)discountLabel
{
    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.numberOfLines = 1;
        _discountLabel.font = [UIFont systemFontOfSize:15];
        _discountLabel.textColor = YTDefaultRedColor;
        _discountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _discountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _discountLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
