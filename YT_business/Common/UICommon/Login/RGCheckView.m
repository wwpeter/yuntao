#import "RGCheckView.h"
#import "NSStrUtil.h"
#import "UIView+DKAddition.h"


static const NSInteger kDefaultPadding = 10;

#define RGTextFont [UIFont systemFontOfSize:14]


@implementation RGCheckView

- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    [self configureWithTitle:title frame:frame];
    return self;
}
-(void)configureWithTitle:(NSString *)title frame:(CGRect)frame
{
    _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 1)];
    _topLine.image = YTlightGrayTopLineImage;
    _topLine.hidden = !_displayTopLine;
    [self addSubview:_topLine];
    
    _bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(kDefaultPadding, CGRectGetHeight(frame)-1, CGRectGetWidth(frame), 1)];
    _bottomLine.image = YTlightGrayBottomLineImage;
    [self addSubview:_bottomLine];
    
    CGFloat width = [NSStrUtil stringWidthWithString:title stringFont:RGTextFont];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultPadding, 0, width, CGRectGetHeight(frame))];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = RGTextFont;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.text = title;
    [self addSubview:_titleLabel];
    
    CGFloat cY = CGRectGetHeight(frame)-22-11;
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkButton.frame = CGRectMake(CGRectGetWidth(frame)-kDefaultPadding-22, cY, 22, 22);
    _checkButton.backgroundColor = [UIColor clearColor];
    [_checkButton setImage:[UIImage imageNamed:@"yt_register_selectBtn_cancel.png"] forState:UIControlStateNormal];
     [_checkButton setImage:[UIImage imageNamed:@"yt_register_selectBtn_select.png"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkButton];
    _checkButton.selected = YES;
    _didSelect = YES;
}

#pragma mark - Action
- (void)checkButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    _didSelect = button.selected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
