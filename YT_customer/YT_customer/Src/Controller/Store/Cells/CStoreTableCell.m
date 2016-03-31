#import "CStoreTableCell.h"
#import "CStoreIntroModel.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"

static const NSInteger kDefaultPadding = 10;

@implementation CStoreTableCell
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
- (void)configStoreCellWithModel:(CStoreIntroModel *)introModel
{
    [self.storeImageView sd_setImageWithURL:[introModel.imageUrl imageUrlWithWidth:200] placeholderImage:YTNormalPlaceImage];
    self.rankImageView.image = [UIImage imageNamed:@"yt_star_level_10.png"];
    self.costLabel.text = introModel.costStr;
    self.catLabel.text = [NSString stringWithFormat:@"%@ %@",introModel.sort,introModel.distanceStr];
    self.discountLabel.attributedText = introModel.discountAttributed;
    self.nameLabel.attributedText = introModel.nameAttributed;
    if (introModel.promotionType == 2 && [NSStrUtil notEmptyOrNull:introModel.curFullSubtract] && introModel.conflictVer) {
        self.subtractLabel.text = [NSString stringWithFormat:@" 满%@减%@  ",@(introModel.subtractFull),@(introModel.subtractCur)];
    }else{
        self.subtractLabel.text = @"";
    }
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.storeImageView];
    [self.contentView addSubview:self.rankImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.costLabel];
    [self.contentView addSubview:self.catLabel];
    [self.contentView addSubview:self.discountLabel];
    [self.contentView addSubview:self.subtractLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_storeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kDefaultPadding);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_storeImageView).offset(2);
            make.left.mas_equalTo(_storeImageView.right).offset(kDefaultPadding);
            make.right.mas_equalTo(self.contentView);
        }];
        [_rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(8);
            make.left.mas_equalTo(_nameLabel);
            make.size.mas_equalTo(CGSizeMake(76, 12));
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_rankImageView.right).offset(kDefaultPadding);
            make.top.mas_equalTo(_rankImageView);
            make.right.mas_equalTo(self.contentView);
        }];
        [_subtractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-kDefaultPadding);
            make.top.mas_equalTo(_rankImageView);
            make.height.mas_equalTo(20);
        }];
        [_catLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_rankImageView);
            make.top.mas_equalTo(_rankImageView.bottom).offset(8);
            make.right.mas_equalTo(self.contentView).offset(-90);
        }];
        [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).offset(-kDefaultPadding);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(120);
        }];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Getters & Setters
- (UIImageView *)storeImageView
{
    if (!_storeImageView) {
        _storeImageView = [[UIImageView alloc] init];
        _storeImageView.clipsToBounds = YES;
        _storeImageView.layer.masksToBounds = YES;
        _storeImageView.layer.cornerRadius = 2;
        _storeImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _storeImageView;
}
- (UIImageView *)rankImageView
{
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
    }
    return _rankImageView;
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
- (UILabel *)catLabel
{
    if (!_catLabel) {
        _catLabel = [[UILabel alloc] init];
        _catLabel.numberOfLines = 1;
        _catLabel.font = [UIFont systemFontOfSize:13];
        _catLabel.textColor = CCCUIColorFromHex(0x999999);
        _catLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _catLabel;
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
- (UILabel *)subtractLabel
{
    if (!_subtractLabel) {
        _subtractLabel = [[UILabel alloc] init];
        _subtractLabel.layer.masksToBounds = YES;
        _subtractLabel.layer.borderWidth = 1;
        _subtractLabel.layer.borderColor = [YTDefaultRedColor CGColor];
        _subtractLabel.layer.cornerRadius = 3.0;
        _subtractLabel.numberOfLines = 1;
        _subtractLabel.font = [UIFont systemFontOfSize:13];
        _subtractLabel.textColor = YTDefaultRedColor;
        _subtractLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subtractLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
