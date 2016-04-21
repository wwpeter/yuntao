#import "DealRecordDetailUserHeadView.h"

static const NSInteger kLeftPadding = 10;
static const NSInteger kTopPadding = 15;

@implementation DealRecordDetailUserHeadView
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
    self.clipsToBounds = YES;
    [self addSubview:self.userImageView];
    [self addSubview:self.nameLabel];
    
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kLeftPadding);
        make.top.mas_equalTo(kTopPadding);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userImageView.right).offset(kLeftPadding);
        make.centerY.mas_equalTo(_userImageView);
        make.right.mas_equalTo(self);
    }];
    
}
#pragma mark - Getters & Setters
- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = [imageUrl copy];
    [_userImageView setYTImageWithURL:[imageUrl imageStringWithWidth:200] placeHolderImage:[UIImage imageNamed:@"cdealRecordUserPlace.png"]];
}
- (void)setName:(NSString *)name
{
    _name =[name copy];
    _nameLabel.text = name;
}
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
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = CCCUIColorFromHex(0x333333);
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _nameLabel;
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, CGRectGetHeight(rect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect))];
    [[UIColor colorWithWhite:0.5 alpha:0.5] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
}

@end
