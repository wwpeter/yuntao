#import "HbSelectTableCell.h"
#import "UIImageView+WebCache.h"
#import "HbIntroModel.h"
#import "NSStrUtil.h"

static const NSInteger kDefaultPadding = 10;

@implementation HbSelectTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureSubview];
    }
    return self;
}

#pragma mark - Public methods
- (void)configHbSelectCellWithIntroModel:(HbIntroModel *)introModel
{
    self.introModel = introModel;
    self.leftSelectButton.selected = introModel.didSelect;
    [self.hbImageView sd_setImageWithURL:[introModel.imageUrl imageUrlWithWidth:200] placeholderImage:YTNormalPlaceImage];
    self.nameLabel.text = introModel.hbName;
    self.describeLabel.text = introModel.shopName;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",introModel.cost];
    self.thanLabel.text = [NSString stringWithFormat:@"剩余%@",@(introModel.thanNum)];
}
- (void)configHbSelectCellWithSingleModel:(SingleHbModel *)introModel
{
    
}
#pragma mark - Private methods
#pragma mark - Event response
- (void)leftButtonDidClicked:(id)sender
{
    [self.delegate hbSelectTableCell:self didSelect:self.introModel];
}
#pragma maek - SubViews
-(void)configureSubview
{
     [self.contentView addSubview:self.leftSelectButton];
     [self.contentView addSubview:self.hbImageView];
     [self.contentView addSubview:self.nameLabel];
     [self.contentView addSubview:self.describeLabel];
     [self.contentView addSubview:self.priceLabel];
     [self.contentView addSubview:self.thanLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [_leftSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 60));
        }];
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_leftSelectButton.right);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hbImageView).offset(4);
            make.left.mas_equalTo(_hbImageView.right).offset(kDefaultPadding);
            make.right.mas_equalTo(-70);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(3);
            make.left.right.mas_equalTo(_nameLabel);
        }];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel).offset(-3);
            make.right.mas_equalTo(-15);
        }];
        [_thanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_describeLabel);
            make.right.mas_equalTo(_priceLabel);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.priceLabel.preferredMaxLayoutWidth = 70;
    self.thanLabel.preferredMaxLayoutWidth = 70;
}
#pragma mark - Getters & Setters
- (UIButton *)leftSelectButton
{
    if (!_leftSelectButton) {
       _leftSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftSelectButton setImage:[UIImage imageNamed:@"ye_circle_normal.png"] forState:UIControlStateNormal];
        [_leftSelectButton setImage:[UIImage imageNamed:@"ye_circle_select.png"] forState:UIControlStateSelected];
        [_leftSelectButton addTarget:self action:@selector(leftButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftSelectButton;
}
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
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] init];
        _describeLabel.numberOfLines = 1;
        _describeLabel.font = [UIFont systemFontOfSize:13];
        _describeLabel.textColor = CCCUIColorFromHex(0x666666);
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _describeLabel;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.numberOfLines = 1;
        _priceLabel.font = [UIFont boldSystemFontOfSize:18];
        _priceLabel.textColor = YTDefaultRedColor;
        _priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
- (UILabel *)thanLabel
{
    if (!_thanLabel) {
        _thanLabel = [[UILabel alloc] init];
        _thanLabel.numberOfLines = 1;
        _thanLabel.font = [UIFont systemFontOfSize:13];
        _thanLabel.textColor = CCCUIColorFromHex(0x666666);
        _thanLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _thanLabel.textAlignment = NSTextAlignmentRight;
    }
    return _thanLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
