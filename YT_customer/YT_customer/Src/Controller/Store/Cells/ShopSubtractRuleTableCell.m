#import "ShopSubtractRuleTableCell.h"
#import "UIView+DKAddition.h"
#import "NSStrUtil.h"

#define kDescribeTextFont [UIFont systemFontOfSize:14]
#define kTextMaxWidth kDeviceWidth-15

@implementation ShopSubtractRuleTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
- (void)configShopSubtractRules:(id)model
{
    self.timeView.describe = [self timeString];
    self.ruleView.describe = [self ruleString];
    self.dateView.describe = [self dateString];
}
- (NSString *)timeString
{
    return @"每天00：00-24：00";
}
- (NSString *)ruleString
{
    return @"啊得加快立法会上对方会计师对符合双方将卡恢复健康撒地方和房价快速返回数据库地方哈市疯狂减肥哈萨克减肥了挥洒的";
}
- (NSString *)dateString
{
    return @"2015-06-26至2015-06-25";
}
- (CGFloat)ruleRowHeight
{
    CGFloat timeHeight = [self ruleTextHeight:[self timeString]];
    CGFloat ruleHeight = [self ruleTextHeight:[self ruleString]];
    CGFloat dateHeight = [self ruleTextHeight:[self dateString]];
    CGFloat height = 20*3+timeHeight+ruleHeight+dateHeight+30;
    return height;
}
- (CGFloat)ruleTextHeight:(NSString *)text
{
    CGFloat height = [NSStrUtil stringHeightWithString:text stringFont:kDescribeTextFont textWidth:kTextMaxWidth];
    return height+16;
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.timeView];
    [self.contentView addSubview:self.ruleView];
    [self.contentView addSubview:self.dateView];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.ruleView.dk_y = self.timeView.dk_bottom;
    self.dateView.dk_y = self.ruleView.dk_bottom;
}
#pragma mark - Setter & Getter
- (SubtractRuleView*)timeView
{
    if (!_timeView) {
        _timeView = [[SubtractRuleView alloc] initWithFrame:CGRectMake(0, 15, CGRectGetWidth(self.contentView.bounds), 40)];
        _timeView.title = @"使用时间";
    }
    return _timeView;
}
- (SubtractRuleView *)ruleView
{
    if (!_ruleView) {
        _ruleView = [[SubtractRuleView alloc] initWithFrame:CGRectMake(0, _timeView.dk_bottom, CGRectGetWidth(self.contentView.bounds), 40)];
        _ruleView.title = @"注意事项";
    }
    return _ruleView;
}

- (SubtractRuleView *)dateView
{
    if (!_dateView) {
        _dateView = [[SubtractRuleView alloc] initWithFrame:CGRectMake(0, _ruleView.dk_bottom, CGRectGetWidth(self.contentView.bounds), 40)];
        _dateView.title = @"有效期";
    }
    return _dateView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation SubtractRuleView

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViews];
    return self;
}

#pragma mark - Subviews
- (void)configSubViews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.describeLabel];
}

- (CGSize)fitOptimumSize
{
    CGRect rect = self.frame;
    rect.size.height = _describeLabel.dk_bottom;
    self.frame = rect;
    
    return rect.size;
}

#pragma mark - Setter & Getter
- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = title;
}
- (void)setDescribe:(NSString *)describe
{
    _describe = [describe copy];
    NSString *describeText = [NSString stringWithFormat:@"• %@", describe];
    CGFloat describeTextHeight = [NSStrUtil stringHeightWithString:describeText stringFont:kDescribeTextFont textWidth:kTextMaxWidth];
    CGRect rect = _describeLabel.frame;
    rect.size.height = describeTextHeight+16;
    _describeLabel.frame = rect;
     _describeLabel.text = describeText;
    [self fitOptimumSize];
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kTextMaxWidth, 20)];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = kDescribeTextFont;
        _titleLabel.textColor = CCCUIColorFromHex(0x999999);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _titleLabel.dk_bottom, kTextMaxWidth, 30)];
        _describeLabel.numberOfLines = 0;
        _describeLabel.font = kDescribeTextFont;
        _describeLabel.textColor = CCCUIColorFromHex(0x333333);
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _describeLabel;
}
@end