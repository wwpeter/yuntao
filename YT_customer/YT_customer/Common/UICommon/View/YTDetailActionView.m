#import "YTDetailActionView.h"

@interface YTDetailActionView ()

// 箭头
@property (strong, nonatomic) UIImageView *arrowImageView;
@property (strong, nonatomic) UIImageView *topLine;
@property (strong, nonatomic) UIImageView *bottomLine;

@end

@implementation YTDetailActionView


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
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (self.actionBlock) {
        self.actionBlock();
    }
}
#pragma mark - Public methods
- (void)displayTopLine:(BOOL)topShow bottomLine:(BOOL)bottomShow
{
    self.topLine.hidden = !topShow;
    self.bottomLine.hidden = !bottomShow;
}
#pragma mark - Subviews
- (void)configSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.arrowImageView];
    
    [_topLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(15);
    }];
    
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(6, 9));
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(_arrowImageView.left).offset(-10);
    }];
    
    // 单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTap:)];
    [self addGestureRecognizer:singleTap];
    
}

#pragma mark - Setter & Getter
- (void)setDisplayArrow:(BOOL)displayArrow
{
    _displayArrow = displayArrow;
    self.arrowImageView.hidden = !displayArrow;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = UILabel.new;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}
- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = UILabel.new;
        _detailLabel.numberOfLines = 1;
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
            _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yt_cell_rightArrow.png"]];
    }
    return _arrowImageView;
}
- (UIImageView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIImageView alloc] initWithImage:YTlightGrayTopLineImage];
    }
    return _topLine;
}
- (UIImageView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc] initWithImage:YTlightGrayBottomLineImage];
    }
    return _bottomLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
