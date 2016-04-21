

#import "DealHbIntroModel.h"
#import "CDealHbIntroTableCell.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"

static const NSInteger kDefaultPadding = 10;

@implementation CDealHbIntroTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}

#pragma mark - Public methods
- (void)configDealHbIntroCellWithIntroModel:(YTHongBao *)hongbao {
    self.nameLabel.text = hongbao.name;
    self.describeLabel.text = hongbao.title;
    self.backImageView.image = [UIImage imageNamed:@"hb_cell_background_red.png"];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",hongbao.cost/100.];
    [self.hbImageView setYTImageWithURL:[hongbao.img imageStringWithWidth:200] placeHolderImage:YTNormalPlaceImage];
    self.timeLabel.text = [YTTaskHandler outDateStrWithTimeStamp:hongbao.createdAt withStyle:@"yyyy-MM-dd"];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.backImageView];
    [self.contentView addSubview:self.hbImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.describeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.hbStatusImageView];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 10));
        }];
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_backImageView).offset(10);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_hbImageView).offset(2);
            make.left.mas_equalTo(_hbImageView.right).offset(kDefaultPadding);
            make.right.mas_equalTo(-100);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.bottom).offset(3);
            make.left.right.mas_equalTo(_nameLabel);
        }];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel).offset(-3);
            make.left.mas_equalTo(_nameLabel.right);
            make.right.mas_equalTo(-20);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_describeLabel);
            make.left.right.mas_equalTo(_priceLabel);
        }];
        [_hbStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-80);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(73, 56));
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
    self.priceLabel.preferredMaxLayoutWidth = 65;
    self.timeLabel.preferredMaxLayoutWidth = 65;
}
#pragma mark - Getters & Setters
- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
    }
    return _backImageView;
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
- (UIImageView *)hbStatusImageView
{
    if (!_hbStatusImageView) {
        _hbStatusImageView = [[UIImageView alloc] init];
    }
    return _hbStatusImageView;
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
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = YTDefaultRedColor;
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
