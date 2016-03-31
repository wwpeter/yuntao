#import "ShopSubractDateTableCell.h"
#import "UIView+DKAddition.h"
#import "SubtractFullModel.h"

@implementation ShopSubractDateTableCell
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
- (void)configShopSubtractDateRules:(SubtractFullRule *)fullRule
{
    self.timeView.describeLabel.text = [NSString stringWithFormat:@"• %@-%@", fullRule.startTime,fullRule.endTime];
    NSString *dateStr = [fullRule.dateStr stringByReplacingOccurrencesOfString:@"/"
                                                                    withString:@"至"];
    self.dateView.describeLabel.text = [NSString stringWithFormat:@"• %@", dateStr];
}
#pragma maek - SubViews
- (void)configureSubview
{
    [self.contentView addSubview:self.timeView];
    [self.contentView addSubview:self.dateView];
}
#pragma mark - Setter & Getter
- (SubtractRuleView*)timeView
{
    if (!_timeView) {
        _timeView = [[SubtractRuleView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.contentView.bounds), 50)];
        _timeView.title = @"使用时间";
    }
    return _timeView;
}

- (SubtractRuleView *)dateView
{
    if (!_dateView) {
        _dateView = [[SubtractRuleView alloc] initWithFrame:CGRectMake(0, _timeView.dk_bottom, CGRectGetWidth(self.contentView.bounds), 50)];
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
