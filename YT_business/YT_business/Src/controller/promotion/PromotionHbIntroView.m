
#import "YTPromotionModel.h"
#import "PromotionHbIntroView.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"

static const NSInteger kLeftPadding = 15;

@implementation PromotionHbIntroView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self configSubviews];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self configSubviews];
    return self;
}
#pragma mark - Public methods
- (void)configPromotionHbIntroViewWithModel:(YTPromotionHongbao *)promotionHongbao {
        self.describeView.describeLabel.text = promotionHongbao.shop.name;
    self.statusLabel.text = [YTTaskHandler outShopBuyHbStatusStrWithStatus:promotionHongbao.status];
    self.describeView.nameLabel.text = [NSString stringWithFormat:@"%@ 价值%.2f元",promotionHongbao.name,promotionHongbao.cost/100.];
    [self.describeView.hbImageView setYTImageWithURL:[promotionHongbao.img imageStringWithWidth:200]placeHolderImage:[UIImage imageNamed:@"hbPlaceImage.png"]];
    self.timeLabel.text = [NSString stringWithFormat:@"到期时间:%@",[YTTaskHandler outDateStrWithTimeStamp:promotionHongbao.sellerShopEndTime withStyle:@"yyyy-MM-dd"]];
}

#pragma mark - SubViews
- (void)configSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.timeLabel];
    [self addSubview:self.statusLabel];
    [self addSubview:self.describeView];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.right.mas_equalTo(-110);
        make.top.mas_equalTo(15);
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_timeLabel);
    }];
    [_describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(44);
        make.left.right.bottom.mas_equalTo(self);
    }];
}


#pragma mark - Setter & Getter
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CCCUIColorFromHex(0x666666);
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.numberOfLines = 1;
    }
    return _timeLabel;
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
- (HbDescribeView *)describeView
{
    if (!_describeView) {
        _describeView = [[HbDescribeView alloc] init];
    }
    return _describeView;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),0)];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 44)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),44)];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];

    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),CGRectGetHeight(rect))];
    [[ccColor colorWithAlphaComponent:0.8] setStroke];
    [bezierPath setLineWidth:1.0f];
    [bezierPath stroke];
}

@end
