

#import "HbDetailHeadView.h"
#import "HbDetailModel.h"
#import "UIImageView+WebCache.h"
#import "NSStrUtil.h"
#import "YTResultHbDetailModel.h"

static const NSInteger kDefaultPadding = 15;

@implementation HbDetailHeadView

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    [self configSubViewsWithDisplayTime:NO];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configSubViewsWithDisplayTime:NO];
    return self;
}
- (instancetype)initWithDisplayTime:(BOOL)displayTime frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    _displayTime = displayTime;
    [self configSubViewsWithDisplayTime:displayTime];
    return self;
}
#pragma mark - Public methods
- (void)configDetailHeadViewWithHongBao:(HbDetailModel *)hongbao;
{
    [self.hbImageView sd_setImageWithURL:[hongbao.imageUrl imageUrlWithWidth:kDeviceCurrentWidth] placeholderImage:[UIImage imageNamed:@"hb_detail_placeImage.png"]];
    self.nameLabel.text= hongbao.hbName;
    self.costLabel.text = [NSString stringWithFormat:@"￥%@",hongbao.cost];
    if (_displayTime) {
        self.timeLabel.text = [NSString stringWithFormat:@"使用期限至%@",hongbao.userEndTime];
        self.statusImageView.image = [UIImage imageNamed:hongbao.hbStatusImageName];
    }
}
- (void)configDetailHeadViewWithResultHongBao:(YTResultHongbao *)hongbao
{
    [self.hbImageView sd_setImageWithURL:[hongbao.img imageUrlWithWidth:kDeviceCurrentWidth] placeholderImage:[UIImage imageNamed:@"hb_detail_placeImage.png"]];
    self.nameLabel.text= hongbao.name;
    self.costLabel.text = [NSString stringWithFormat:@"￥%.2f",hongbao.cost/100.];
}
#pragma mark - Subviews
- (void)configSubViewsWithDisplayTime:(BOOL)displayTime
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.hbImageView];
    [self addSubview:self.statusImageView];
    [self addSubview:self.costLabel];
    [self addSubview:self.nameLabel];
    
    [_hbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(200);
    }];
    [_statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(81, 81));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kDefaultPadding);
        make.top.mas_equalTo(_hbImageView.bottom).offset(10);
        make.right.mas_equalTo(self);
    }];
    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.bottom).offset(5);
        make.left.mas_equalTo(kDefaultPadding);
        make.right.mas_equalTo(self);
    }];
    if (displayTime) {
        [self addSubview:self.timeIconImageView];
        [self addSubview:self.timeLabel];
        [_timeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kDefaultPadding);
            make.bottom.mas_equalTo(self).offset(-10);
            make.size.mas_equalTo(CGSizeMake(13, 14));
        }];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_timeIconImageView.right).offset(2);
            make.centerY.mas_equalTo(_timeIconImageView);
            make.right.mas_equalTo(self);
        }];
    }
}
#pragma mark - Setter & Getter
- (UIImageView *)hbImageView
{
    if (!_hbImageView) {
        _hbImageView = [[UIImageView alloc] init];
        _hbImageView.clipsToBounds = YES;
        _hbImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _hbImageView;
}
- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
    }
    return _statusImageView;
}
- (UIImageView *)timeIconImageView
{
    if (!_timeIconImageView) {
        _timeIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_store_hb_usertime.png"]];
    }
    return _timeIconImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 1;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (UILabel *)costLabel
{
    if (!_costLabel) {
        _costLabel = [[UILabel alloc] init];
        _costLabel.numberOfLines = 1;
        _costLabel.font = [UIFont systemFontOfSize:24];
        _costLabel.textColor = YTDefaultRedColor;
        _costLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _costLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _costLabel;
}
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.numberOfLines = 1;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = CCCUIColorFromHex(0x999999);
        _timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = [UIColor colorWithWhite:0.5 alpha:0.5f];
    UIBezierPath *bezierPath;
    
    if (_displayTime) {
        bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(15, CGRectGetHeight(rect)-35)];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect)-35)];
        [ccColor setStroke];
        [bezierPath setLineWidth:0.5f];
        [bezierPath stroke];
    }

    
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
