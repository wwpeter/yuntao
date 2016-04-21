#import "ShopDetailHbTableCell.h"
#import "YTOrderModel.h"
#import "NSStrUtil.h"

static const NSInteger kTopPadding = 10;
static const NSInteger kLeftPadding = 15;

@implementation ShopDetailHbTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configShopDetailHbTableCellModel:(YTCommonHongBao *)hongbao
{
    
    NSString *costStr = [NSString stringWithFormat:@"￥%.2f",hongbao.price/100.];
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",hongbao.name,hongbao.cost/100.];
    self.describeLabel.text = hongbao.title;
    self.costLabel.text = costStr;
    self.remainLabel.text = [NSString stringWithFormat:@"剩余%@",@(hongbao.remainNum)];
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.hbImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.costLabel];
    [self.contentView addSubview:self.remainLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(kTopPadding);
            make.left.mas_equalTo(self.contentView).offset(kLeftPadding);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hbImageView).offset(2);
            make.left.mas_equalTo(_hbImageView.right).offset(5);
            make.right.mas_equalTo(self.contentView).offset(-95);
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kLeftPadding);
            make.top.mas_equalTo(_nameLabel).offset(2);
            make.width.mas_equalTo(80);
        }];
        [_remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_costLabel);
            make.top.mas_equalTo(_costLabel.bottom);
            make.width.mas_equalTo(_costLabel);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(3);
            make.left.mas_equalTo(_nameLabel);
            make.right.mas_equalTo(_costLabel.left).offset(-kTopPadding);
        }];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
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
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.textColor = CCCUIColorFromHex(0x999999);
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.numberOfLines = 1;
    }
    return _describeLabel;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0xfd5c63);
        _costLabel.font = [UIFont systemFontOfSize:20];
        _costLabel.numberOfLines = 1;
        _costLabel.textAlignment = NSTextAlignmentRight;
    }
    return _costLabel;
}
- (UILabel *)remainLabel
{
    if (!_remainLabel) {
        _remainLabel = [[UILabel alloc] init];
        _remainLabel.textColor = CCCUIColorFromHex(0x999999);
        _remainLabel.font = [UIFont systemFontOfSize:13];
        _remainLabel.numberOfLines = 1;
        _remainLabel.textAlignment = NSTextAlignmentRight;
    }
    return _remainLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
