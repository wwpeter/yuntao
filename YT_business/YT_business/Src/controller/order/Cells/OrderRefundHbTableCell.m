#import "OrderRefundHbTableCell.h"
#import "YTOrderModel.h"

static const NSInteger kLeftPadding = 15;

@implementation OrderRefundHbTableCell

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
- (void)configOrderRefundTableCellModel:(YTCommonHongBao *)hongbao
{
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元", hongbao.name,hongbao.cost / 100.];
    self.describeLabel.text = hongbao.title;
    self.costLabel.text = [NSString stringWithFormat:@"¥%.2f \n剩余%d",hongbao.price / 100., hongbao.remainNum];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma mark - Event response
- (void)selectButtonDidClicked:(id)sender
{
    
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:self.hbImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.costLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 60));
        }];
        
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_selectBtn.right);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kLeftPadding);
            make.top.mas_equalTo(_nameLabel).offset(2);
            make.width.mas_equalTo(80);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hbImageView).offset(2);
            make.left.mas_equalTo(_hbImageView.right).offset(5);
            make.right.mas_equalTo(self.contentView).offset(-95);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(3);
            make.left.right.mas_equalTo(_nameLabel);
        }];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}


#pragma mark - Setter & Getter
- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"un_select"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"is_select_red"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

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
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
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
        _describeLabel.font = [UIFont systemFontOfSize:14];
        _describeLabel.numberOfLines = 1;
    }
    return _describeLabel;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.textColor = CCCUIColorFromHex(0x666666);
        _costLabel.font = [UIFont systemFontOfSize:13];
        _costLabel.numberOfLines = 2;
        _costLabel.textAlignment = NSTextAlignmentRight;
    }
    return _costLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
