#import "HbDetailNotesView.h"
#import "HbDetaiDescribeView.h"
#import "HbDetailRuleView.h"
#import "NSStrUtil.h"
#import "UIView+DKAddition.h"
#import "HbDetailModel.h"
#import "YTResultHbDetailModel.h"
#import "NSDate+TimeInterval.h"

@implementation HbDetailNotesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithUsrHongBao:(HbDetailModel *)hongbao frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _hongbao = hongbao;
        [self configSubViews];
    }
    return self;
}
-(instancetype)initWithResultHongBao:(YTResultHongbao *)hongbao frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _hongbao = [[HbDetailModel alloc] init];
        _hongbao.describe = hongbao.title;
        _hongbao.moveState = [NSString stringWithFormat:@"%@ 至 %@", [NSDate timestampToYear:hongbao.startTime/1000], [NSDate timestampToYear:hongbao.endTime/1000]];
        _hongbao.ruleDesc = hongbao.ruleDesc;
        [self configSubViews];
    }
    return self;
}
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    _describeView = [[HbDetaiDescribeView alloc] initWithDescribe:_hongbao.describe frame:CGRectMake(0, _titleLabel.dk_bottom+10, CGRectGetWidth(self.bounds), 0)];
    _describeView.titleLabel.text = @"红包概述:";
    [_describeView fitOptimumSize];
    [self addSubview:_describeView];
    
    _timeView = [[HbDetaiDescribeView alloc] initWithDescribe:_hongbao.moveState frame:CGRectMake(0, _describeView.dk_bottom, CGRectGetWidth(self.bounds), 0)];
    _timeView.titleLabel.text = @"有效期限:";
    [_timeView fitOptimumSize];
    [self addSubview:_timeView];
    
    _ruleView = [[HbDetailRuleView alloc] initWithRulesDesc:_hongbao.ruleDesc frame:CGRectMake(0, _timeView.dk_bottom, CGRectGetWidth(self.bounds), 0)];
    _ruleView.titleLabel.text = @"使用规则:";
    [_ruleView fitOptimumSize];
    [self addSubview:_ruleView];
}
- (CGSize)fitOptimumSize
{
    CGRect rect = self.frame;
    rect.size.height = _ruleView.dk_bottom;
    self.frame = rect;
    return rect.size;
}
#pragma mark - Setter & Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(self.bounds)-15, 40)];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text= @"购买须知";
    }
    return _titleLabel;
}
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    UIBezierPath *bezierPath;
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(15, 40)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 40)];
    [ccColor setStroke];
    [bezierPath setLineWidth:0.5f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}


@end
