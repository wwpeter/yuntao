
#import "OrderCellHeadView.h"
#import "MyOrderListViewController.h"

@implementation OrderCellHeadView
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
#pragma mark - Event response
- (void)whiteViewTap:(UITapGestureRecognizer*)tap
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}
#pragma mark - Public methods
- (void)configStatusLabel:(NSInteger)status viewType:(MyOrderListViewType)type
{
    _statusLabel.hidden = NO;
    if (type == MyOrderListViewTypePayment) {
        //WAITE_PAY(1, "待支付"), TRADE_SUCCESS(2, "交易成功"), REFUNDING(3, "退款中"), REFUNDED(4, "已退款"), CLOSED(5, "已关闭");支付状态
        
        switch (status) {
            case 1:{
                _statusLabel.text = type == MyOrderListViewTypePayment ? @"待支付" : @"审核中";
                _statusLabel.backgroundColor = CCCUIColorFromHex(0xfd5c63);
            }
                break;
            case 2:{
                _statusLabel.text = type == MyOrderListViewTypePayment ? @"交易成功" : @"退款中";
                _statusLabel.backgroundColor = CCCUIColorFromHex(0x39be7a);
            }
                break;
            case 3:{
                _statusLabel.text = type == MyOrderListViewTypePayment ? @"退款中" : @"退款成功";
                _statusLabel.backgroundColor = CCCUIColorFromHex(0xfd5c63);
            }
                break;
            case 4: {
                _statusLabel.text = type == MyOrderListViewTypePayment ? @"已退款" : @"";
                _statusLabel.backgroundColor = CCCUIColorFromHex(0x39be7a);
            }
                break;
            case 5: {
                _statusLabel.text = type == MyOrderListViewTypePayment ? @"超时关闭" : @"";
                _statusLabel.backgroundColor = CCCUIColorFromHex(0xeeeeee);
            }
                break;
            default:
                break;
        }
    }else {
        
    }
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor clearColor];
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    [self addSubview:self.marginView];
    [whiteView addSubview:self.iconImageView];
    [whiteView addSubview:self.titleLabel];
    [whiteView addSubview:self.arrowImageView];
    [whiteView addSubview:self.statusLabel];

    [_marginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(15);
    }];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.top.mas_equalTo(_marginView.bottom);
    }];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(whiteView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(whiteView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_iconImageView.right).offset(8);
        make.right.mas_equalTo(_statusLabel.left).priorityHigh();
        make.centerY.mas_equalTo(whiteView);
    }];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.right).offset(5);
        make.centerY.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(6, 9));
    }];
    
    [whiteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whiteViewTap:)]];
}

#pragma mark - Getters & Setters
- (UIView*)marginView
{
    if (!_marginView) {
        _marginView = [[UIView alloc] init];
    }
    return _marginView;
}
- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_store_smallicon.png"]];
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_cell_rightArrow.png"]];
    }
    return _arrowImageView;
}
- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor whiteColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont systemFontOfSize:11];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.numberOfLines = 1;
        _statusLabel.hidden = YES;
    }
    return _statusLabel;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIColor *ccColor = CCCUIColorFromHex(0xcccccc);
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0,15)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect),15)];
    [ccColor setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
