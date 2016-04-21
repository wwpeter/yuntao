

#import "UIView+DKAddition.h"
#import "YTDrainageDetailModel.h"
#import "DrainageDetailTableCell.h"

static const NSInteger kDefaultPadding = 15;

@interface DrainageDetailTableCell ()

@property (strong, nonatomic) UILabel *bottomLeftLabel;
@property (strong, nonatomic) UILabel *bottomCenterLabel;
@property (strong, nonatomic) UILabel *bottomRightLabel;

@end

@implementation DrainageDetailTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
- (void)configDrainageDetailCellWithModel:(YTCommonShop *)commonShop
{
    self.statusImageView.image = [UIImage imageNamed:@"hb_select_orangeStatus.png"];
    self.nameLabel.text = commonShop.name;
    self.leadLabel.text = [NSString stringWithFormat:@"%d",commonShop.yin];
    self.throwLabel.text = [NSString stringWithFormat:@"%d",commonShop.tou];
    self.pullLabel.text = [NSString stringWithFormat:@"%d",commonShop.ling];
    self.bottomLeftLabel.text = @"投放红包";
    self.bottomCenterLabel.text = @"领取人数";
    self.bottomRightLabel.text = @"引流人数";

}
#pragma maek - SubViews
-(void)configureSubview
{
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth-16, 17, 6, 9)];
    arrowImageView.image = [UIImage imageNamed:@"yt_cell_rightArrow.png"];
    [self addSubview:arrowImageView];
    
    UIImageView *horizontalLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44, kDeviceWidth, 1)];
    horizontalLine.image = YTlightGrayBottomLineImage;
    [self addSubview:horizontalLine];
    
    UIImageView *verticalLine = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth/3, 52, 1, 35)];
    verticalLine.image = YTlightGrayLineImage;
    [self addSubview:verticalLine];
    
    UIImageView *verticalLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(2*(kDeviceWidth/3), 52, 1, 35)];
    verticalLine2.image = YTlightGrayLineImage;
    [self addSubview:verticalLine2];

    [self addSubview:arrowImageView];
    [self addSubview:horizontalLine];
    [self addSubview:verticalLine];
    [self addSubview:verticalLine2];
    [self addSubview:self.statusImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.throwLabel];
    [self addSubview:self.pullLabel];
    [self addSubview:self.leadLabel];
    [self addSubview:self.bottomLeftLabel];
    [self addSubview:self.bottomCenterLabel];
    [self addSubview:self.bottomRightLabel];
}
#pragma mark - Setter & Getter
- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, kDefaultPadding, 16, 16)];
    }
    return _statusImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultPadding+26, 0, kDeviceWidth-kDefaultPadding-26-30, 44)];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}


- (UILabel *)throwLabel
{
    if (!_throwLabel) {
        CGFloat width = kDeviceWidth/3;
        _throwLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 52, width, 20)];
        _throwLabel.numberOfLines = 1;
        _throwLabel.font = [UIFont systemFontOfSize:16];
        _throwLabel.textColor = CCCUIColorFromHex(0xfd5c36);
        _throwLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _throwLabel;
}
- (UILabel *)pullLabel
{
    if (!_pullLabel) {
        CGFloat width = kDeviceWidth/3;
        _pullLabel = [[UILabel alloc] initWithFrame:CGRectMake(width, 52, width, 20)];
        _pullLabel.numberOfLines = 1;
        _pullLabel.font = [UIFont systemFontOfSize:16];
        _pullLabel.textColor = CCCUIColorFromHex(0xfd5c36);
        _pullLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pullLabel;
}
- (UILabel *)leadLabel
{
    if (!_leadLabel) {
        CGFloat width = kDeviceWidth/3;
        _leadLabel = [[UILabel alloc] initWithFrame:CGRectMake(2*width, 52, width, 20)];
        _leadLabel.numberOfLines = 1;
        _leadLabel.font = [UIFont systemFontOfSize:16];
        _leadLabel.textColor = CCCUIColorFromHex(0xfd5c36);
        _leadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leadLabel;
}
- (UILabel *)bottomLeftLabel
{
    if (!_bottomLeftLabel) {
        _bottomLeftLabel = [[UILabel alloc] initWithFrame:self.throwLabel.frame];
        _bottomLeftLabel.dk_y = 70;
        _bottomLeftLabel.numberOfLines = 1;
        _bottomLeftLabel.font = [UIFont systemFontOfSize:13];
        _bottomLeftLabel.textColor = CCCUIColorFromHex(0x999999);
        _bottomLeftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomLeftLabel;
}
- (UILabel *)bottomCenterLabel
{
    if (!_bottomCenterLabel) {
        _bottomCenterLabel = [[UILabel alloc] initWithFrame:self.pullLabel.frame];
        _bottomCenterLabel.dk_y = 70;
        _bottomCenterLabel.numberOfLines = 1;
        _bottomCenterLabel.font = [UIFont systemFontOfSize:13];
        _bottomCenterLabel.textColor = CCCUIColorFromHex(0x999999);
        _bottomCenterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomCenterLabel;
}
- (UILabel *)bottomRightLabel
{
    if (!_bottomRightLabel) {
        _bottomRightLabel = [[UILabel alloc] initWithFrame:self.leadLabel.frame];
        _bottomRightLabel.dk_y = 70;
        _bottomRightLabel.numberOfLines = 1;
        _bottomRightLabel.font = [UIFont systemFontOfSize:13];
        _bottomRightLabel.textColor = CCCUIColorFromHex(0x999999);
        _bottomRightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomRightLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
