#import "OrderDetailSectionHeadView.h"

@interface OrderDetailSectionHeadView ()
@end

@implementation OrderDetailSectionHeadView
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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(_iconImageView.right).offset(5);
        make.centerY.mas_equalTo(self);
    }];
}

#pragma mark - Setter & Getter
- (UIImageView*)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_list_shop"]];
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}
- (UILabel*)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = CCCUIColorFromHex(0x333333);
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), 0)];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    UIImage* myImageObj = [UIImage imageNamed:@"to_right_arr"];
    //[myImageObj drawAtPoint:CGPointMake(0, 0)];
    [myImageObj drawInRect:CGRectMake(_titleLabel.frame.origin.x + _titleLabel.frame.size.width + 15, CGRectGetHeight(rect) / 2 - 6, 7, 12)];
}

@end
