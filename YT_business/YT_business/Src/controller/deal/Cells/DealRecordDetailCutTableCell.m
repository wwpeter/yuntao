#import "DealRecordDetailCutTableCell.h"
#import "YTTradeModel.h"
#import "CDealLrTextView.h"
#import "NSStrUtil.h"

@implementation DealRecordDetailCutTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureSubview];
    }
    return self;
}
#pragma mark - Public methods
- (void)configDealRecordDetailCut:(YTTrade *)trade
{
    self.orderView.rightLabel.text = trade.toOuterId;
    self.payView.rightLabel.text = [YTTaskHandler outPayTyoeStrWithType:trade.payType];
    self.timeView.rightLabel.text = [YTTaskHandler outDateStrWithTimeStamp:trade.createdAt withStyle:@"yyyy-MM-dd HH:mm"];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
#pragma maek - SubViews
-(void)configureSubview
{
    self.payView.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeView.translatesAutoresizingMaskIntoConstraints = NO;
    self.orderView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.payView];
    [self.contentView addSubview:self.timeView];
    [self.contentView addSubview:self.orderView];
}
- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(24);
        }];
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(_payView.bottom);
            make.height.mas_equalTo(_payView);
        }];
        [_orderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.top.mas_equalTo(_timeView.bottom);
            make.height.mas_equalTo(32);
        }];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Getters & Setters

- (CDealLrTextView *)payView
{
    if (!_payView) {
        _payView = [[CDealLrTextView alloc] init];
        _payView.leftLabel.text = @"交易类型";
    }
    return _payView;
}
- (CDealLrTextView *)timeView
{
    if (!_timeView) {
        _timeView = [[CDealLrTextView alloc] init];
        _timeView.leftLabel.text = @"创建时间";
    }
    return _timeView;
}
- (CDealLrTextView *)orderView
{
    if (!_orderView) {
        _orderView = [[CDealLrTextView alloc] init];
        _orderView.leftLabel.text = @"订单号";
        _orderView.rightLabel.numberOfLines = 2;
    }
    return _orderView;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.f, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
