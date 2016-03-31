#import "DealRecordTableCell.h"
#import "YTAccountDetailModel.h"
#import "NSStrUtil.h"
#import "UIImageView+YTImageWithURL.h"
#import "NSDate+TimeInterval.h"

static const NSInteger kLeftPadding = 15;

@implementation DealRecordTableCell

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
- (void)configDealTableCellWithAccountDetailModel:(YTAccountDetail *)accountDetail
{
    [self.userImageView setYTImageWithURL:[accountDetail.titleImg imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"cdealRecordUserPlace.png"]];
    self.nameLabel.text = accountDetail.title;
    self.orderLabel.text = accountDetail.typeDesc;;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",accountDetail.amount/100.];
    self.payLabel.text = [YTTaskHandler outPayAccountDetailWithType:accountDetail.type];
    self.timeLabel.text = [NSDate timestampToYear:accountDetail.createdAt/1000];
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
-(void)configureSubview
{
    [self.contentView addSubview:self.userImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.orderLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.payLabel];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(kLeftPadding);
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userImageView);
            make.left.mas_equalTo(_userImageView.right).offset(kLeftPadding);
            make.right.mas_equalTo(-85);
        }];
        [_orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLabel.bottom);
            make.left.right.mas_equalTo(_nameLabel);
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_orderLabel.bottom);
            make.left.right.mas_equalTo(_nameLabel);
        }];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-kLeftPadding);
            make.top.mas_equalTo(20);
        }];
        [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_priceLabel.bottom).offset(4);
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
    self.priceLabel.preferredMaxLayoutWidth = 90;
    self.payLabel.preferredMaxLayoutWidth = 90;
}

#pragma mark - Getters & Setters
- (UIImageView *)userImageView
{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc] init];
        _userImageView.clipsToBounds = YES;
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 2;
        _userImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}
- (UILabel *)orderLabel
{
    if (!_orderLabel) {
        _orderLabel = [[UILabel alloc] init];
        _orderLabel.numberOfLines = 1;
        _orderLabel.font = [UIFont systemFontOfSize:12];
        _orderLabel.textColor = CCCUIColorFromHex(0x999999);
        _orderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _orderLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = CCCUIColorFromHex(0x999999);
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _timeLabel;
}
- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.numberOfLines = 1;
        _priceLabel.font = [UIFont boldSystemFontOfSize:18];
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
- (UILabel *)payLabel
{
    if (!_payLabel) {
        _payLabel = [[UILabel alloc] init];
        _payLabel.numberOfLines = 1;
        _payLabel.font = [UIFont systemFontOfSize:12];
        _payLabel.textColor = CCCUIColorFromHex(0x999999);
        _payLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _payLabel.textAlignment = NSTextAlignmentRight;
    }
    return _payLabel;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
