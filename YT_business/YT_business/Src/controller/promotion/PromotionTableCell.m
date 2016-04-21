

#import "YTPromotionModel.h"
#import "PromotionTableCell.h"
#import "UIImageView+WebCache.h"

static const NSInteger kTopPadding = 10;
static const NSInteger kLeftPadding = 15;

@interface PromotionTableCell ()
@end

@implementation PromotionTableCell

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
- (void)configPromotionTableIntroModel:(YTPromotionHongbao *)promotionHongbao
{
    [self.hbImageView setYTImageWithURL:[promotionHongbao.img imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];

//    self.describeLabel.text = promotionHongbao.title;
    self.thanLabel.attributedText = [promotionHongbao remainNumStr];
    self.provideLabel.attributedText = [promotionHongbao releaseNumStr];
    if (promotionHongbao.remainNum == 0) {
        self.statusLabel.text = @"已经被领完";
    }else{
         self.statusLabel.text = [YTTaskHandler outShopBuyHbStatusStrWithStatus:promotionHongbao.status];
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",promotionHongbao.name,promotionHongbao.cost/100.];
    self.describeLabel.text = promotionHongbao.shop.name;

}
#pragma mark - Private methods
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.provideLabel];
    [self.contentView addSubview:self.thanLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.hbImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.describeLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_provideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kLeftPadding);
            make.top.mas_equalTo(kLeftPadding);
        }];
        [_thanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_provideLabel);
            make.left.mas_equalTo(_provideLabel.right).offset(kLeftPadding);
            make.right.mas_equalTo(-110);
        }];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kLeftPadding);
            make.top.mas_equalTo(_thanLabel);
        }];
        [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(54);
            make.left.mas_equalTo(kLeftPadding);
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hbImageView.right).offset(kTopPadding);
            make.top.mas_equalTo(_hbImageView).offset(5);
            make.right.mas_equalTo(self.contentView);
        }];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel);
            make.top.mas_equalTo(_nameLabel.bottom).offset(10);
            make.right.mas_equalTo(self.contentView);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    self.provideLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.provideLabel.frame);
    self.thanLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.thanLabel.frame);
    self.statusLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.statusLabel.frame);
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
- (UILabel *)provideLabel
{
    if (!_provideLabel) {
        _provideLabel = [[UILabel alloc] init];
        _provideLabel.textColor = CCCUIColorFromHex(0x999999);
        _provideLabel.font = [UIFont systemFontOfSize:14];
        _provideLabel.numberOfLines = 1;
    }
    return _provideLabel;
}
- (UILabel *)thanLabel
{
    if (!_thanLabel) {
        _thanLabel = [[UILabel alloc] init];
        _thanLabel.textColor = CCCUIColorFromHex(0x999999);
        _thanLabel.font = [UIFont systemFontOfSize:14];
        _thanLabel.numberOfLines = 1;
    }
    return _thanLabel;
}
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = CCCUIColorFromHex(0xfd5c63);
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.numberOfLines = 1;
        _statusLabel.textAlignment = NSTextAlignmentRight;

    }
    return _statusLabel;
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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 44)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),44)];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
}
@end
