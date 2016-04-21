#import "HBStoreSearchResultCell.h"
#import "YTTradeModel.h"
static const NSInteger kTopPadding = 10;
static const NSInteger kLeftPadding = 15;

@implementation HBStoreSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configHbStoreSearchResultModel:(YTUsrHongBao*)hongbao
{
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元", hongbao.name, hongbao.cost / 100.];
    self.describeLabel.text = hongbao.shop.name;
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.hbImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.describeLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(self.contentView).offset(kTopPadding);
            make.left.mas_equalTo(self.contentView).offset(kLeftPadding);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_hbImageView).offset(5);
            make.left.mas_equalTo(_hbImageView.right).offset(kTopPadding);
            make.right.mas_equalTo(self.contentView);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(kTopPadding);
            make.left.right.mas_equalTo(_nameLabel);
        }];
        self.didSetupConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - Setter & Getter

- (UIImageView*)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.layer.masksToBounds = YES;
        _hbImageView.layer.cornerRadius = 2;
        _hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hbImageView;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel*)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = CCCUIColorFromHex(0x999999);
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.numberOfLines = 1;
    }
    return _describeLabel;
}
- (UILabel*)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x999999);
        _costLabel.font = [UIFont systemFontOfSize:13];
        _costLabel.numberOfLines = 1;
    }
    return _costLabel;
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
