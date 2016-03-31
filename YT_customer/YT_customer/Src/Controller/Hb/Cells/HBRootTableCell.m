#import "HBRootTableCell.h"
#import "YTResultHbModel.h"
#import <UIImageView+WebCache.h>
#import "NSStrUtil.h"

@implementation HBRootTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configHbIntroCellWithIntroModel:(YTResultHongbao *)hongbao
{
    [self.hbImageView sd_setImageWithURL:[hongbao.img imageUrlWithWidth:200] placeholderImage:YTNormalPlaceImage];
    self.nameLabel.text = hongbao.name;
    self.addressLabel.text = hongbao.shop.name;
    self.distanceLabel.text = [hongbao userLocationDistance];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.hbImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.distanceImageView];
    [self.contentView addSubview:self.distanceLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hbImageView).offset(2);
            make.left.mas_equalTo(_hbImageView.right).offset(10);
            make.right.mas_equalTo(self.contentView);
        }];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_nameLabel);
            make.top.mas_equalTo(_nameLabel.bottom).offset(5);
        }];
        [_distanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel);
            make.top.mas_equalTo(_addressLabel.bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_distanceImageView.right).offset(3);
            make.centerY.mas_equalTo(_distanceImageView);
            make.right.mas_equalTo(self.contentView);
        }];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Getters & Setters
- (UIImageView *)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.clipsToBounds = YES;
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
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.numberOfLines = 1;
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = CCCUIColorFromHex(0x666666);
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _addressLabel;
}
- (UIImageView *)distanceImageView
{
    if (!_distanceImageView) {
        _distanceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hb_cell_compass.png"]];
    }
    return _distanceImageView;
}
- (UILabel *)distanceLabel
{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.numberOfLines = 1;
        _distanceLabel.font = [UIFont systemFontOfSize:13];
        _distanceLabel.textColor = CCCUIColorFromHex(0x999999);
        _distanceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _distanceLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
